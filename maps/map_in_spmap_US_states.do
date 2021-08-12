*****************************************************
*Author:  Idaliya Grigoryeva
*Date:    summer 2021
*Goal:    Create a template for making maps in SPMAP
*****************************************************


clear

*INSTALL PACKAGES
*ssc inst spmap
*ssc inst shp2dta
*ssc inst mif2dta
*ssc inst  geo2xy

// Guide for US Map: https://www.stata.com/support/faqs/graphics/spmap-and-maps/

cd "${tmp}/map_guide"



********************************************************************************
* Import and clean soc-ec data 
*******************************************************************************

import excel raw/US_wellbeing_Gallup_2018.xlsx, sheet("Clean") firstrow clear

	drop I-Z
	
	rename sample_size_2018 N_sample

	label var wellbeing_rank "Rank of state-level wellbeing (1 for most well off, 50 for the least well)"

	sort state_name
	
save US_states_wellbeing_2018.dta, replace



********************************************************************************
* Convert shapefile to a file that STATA can read
*******************************************************************************

shp2dta using raw/US_states_census_gov_2018/cb_2018_us_state_500k.shp, database(us_states_db) coordinates(us_states_coord) genid(id) gencentroids(c)  replace


*******************************************************************************
* Prepare labels for the future map
*******************************************************************************

/* Source of label adding: STATA discussion https://www.statalist.org/forums/forum/general-stata-discussion/general/1395567-how-to-add-state-names-and-labels-using-spmap */

use us_states_coord, clear
geo2xy _Y _X,   projection( mercator) replace
local lon0 = r(lon0)
local f = r(f)
local a = r(a)
// di "`f'"
// di "`a'"
save "state_coordinates_mercator.dta", replace


use us_states_db, clear
quietly destring STATEFP, generate(st)

* keep only contiguous US
drop if st==2 | st==15 | st>56
gen x = runiform()

save "tmp_state_data",replace


gen labtype  = 1
append using tmp_state_data
replace labtype = 2 if labtype==.
*replace NAME = string(x, "%3.2f") if labtype ==2
keep x_c y_c NAME labtype
geo2xy  y_c x_c,   projection( mercator, `a' `f' `lon0' ) replace

save maplabels, replace


local state_labeling " label(data(maplabels) xcoord(x_c)  ycoord(y_c)    label(NAME)  size(*0.75 ..) pos(12 0) ) "


/* *********************** */
/*     Create the maps     */
/* *********************** */

use us_states_db, clear

rename *, lower

destring statefp , replace 

keep if statefp < 60 
ren name state_name

/* keep continental contiguous US states only, otherwise the map is all over the place including islands */
keep if state_name != "Alaska" & state_name != "Hawaii"

keep statefp state_name stusps id

sort state_name


/* test blank map by state (the id needs to match the id listed in shp2dta command */

spmap using us_states_coord.dta, id(id)  osize(vvthin ..) title("Blank Map of US States", size(*0.8))
		
	graphout map_US_blank 


/* Merge in soc-ec data on well-being */

merge 1:1 state_name using "US_states_wellbeing_2018.dta", nogen  keep(master match)
	* verified that non-matches are DC, Alaska, Hawaii, acceptable for us for this task


/* Create maps  */

/* draw a blank map with labels */
spmap                using  state_coordinates_mercator.dta,   id(id)   ocolor(gray ..)  `state_labeling'  title("Blank Map of US States (labeled)", size(*0.8)) 
 
	graphout map_US_blank_labeled


/* draw the wellbeing map with labels with defaults */
spmap wellbeing_rank using  state_coordinates_mercator.dta , id(id)  `state_labeling' 
	
	graphout map_US_wellbeing_0 

/* draw the wellbeing map with labels, beautifying parameters */
spmap wellbeing_rank using  state_coordinates_mercator.dta , id(id) fcolor(BuYlRd)  ocolor(white ..)  clnumber(5)  legcount `state_labeling' 

	graphout map_US_wellbeing_ed







*******************************************************************************


*import dbase using tl_2020_us_state.dbf, case(lower)






