**************************************
*Author: Carla Colina
*Date: May 19, 2021
*Task: Map US Insta Pilot Survey
**************************************


clear

*INSTALL PACKAGES
*ssc inst spmap
*ssc inst shp2dta
*ssc inst mif2dta
*ssc inst  geo2xy

// Guide for US Map: https://www.stata.com/support/faqs/graphics/spmap-and-maps/

cd "${tmp}/map_guide"

********************************************************************************

*******************************************************************************
*import dbase using tl_2020_us_state.dbf, case(lower)


shp2dta using tl_2020_us_state.shp, database(us_states_map) coordinates(uscoord) genid(id) gencentroids(c)  replace

* Prepare labels for the future map


use uscoord, clear
geo2xy _Y _X,   projection( mercator) replace
local lon0 = r(lon0)
local f = r(f)
local a = r(a)
di "`f'"
di "`a'"
save "state_coordinates_mercator.dta", replace

use us_states_map, clear
quietly destring STATEFP, generate(st)
//keep contiguous US
drop if st==2 | st==15 | st>56
gen x = runiform()

save "state_data2",replace
gen labtype  = 1
append using state_data2
replace labtype = 2 if labtype==.
*replace NAME = string(x, "%3.2f") if labtype ==2
keep x_c y_c NAME labtype
geo2xy  y_c x_c,   projection( mercator, `a' `f' `lon0' ) replace
save maplabels, replace


* Create the map
use us_states_map, clear

rename *, lower

destring statefp , replace 

keep if statefp < 60 
ren name state_us

* keep if state_us != "Alaska" & state_us != "Hawaii"

keep statefp state_us stusps id

sort state_us

merge 1:1 state_us using "${analysis}/insta_pilotsurvey_cleaned_map.dta", nogen keep(master match)

replace respondents = 0 if respondents == .
*keep if _merge==3

*drop _merge 

*MAP 

* map without labels
*spmap respondents using uscoord if state_us != "Alaska" & state_us != "Hawaii", id(id) fcolor(Blues) 

* map with labels
*spmap respondents using "state_coordinates_mercator.dta" if state_us != "Alaska" & state_us != "Hawaii", id(id) fcolor(Blues)  ocolor(white ..)  label(data(maplabels) xcoord(x_c)  ycoord(y_c)    label(NAME) by(labtype)  size(*0.85 ..) pos(12 0) )

spmap respondents using "state_coordinates_mercator.dta" if state_us != "Alaska" & state_us != "Hawaii", id(id) fcolor(Blues)  ocolor(white ..)  label(data(maplabels) xcoord(x_c)  ycoord(y_c)    label(NAME)  size(*0.85 ..) pos(12 0) )
