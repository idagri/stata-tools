

/*   P A R T    1   -   Create a spatial dataset for STATA from Shapefile  */

/* convert the shapefile into a geodatabase */
shp2dta using $iec1/gis/pc11/pc11-state, database($tmp/state_db) coordinates($tmp/state_coord) genid(geo_id)  replace 


/*   P A R T    2   -   Merge spatial data  with  data for display */

/* use the created database, it is the one that the map can be created from */
use $tmp/state_db, clear 

/*  rename the state id variable to match the one in the dataset with the variable values we want to map */
rename  pc11_s_id  pc11_state_id

/* merge with the dataset with variables to be displayed on the map  */
	merge 1:1 pc11_state_id  using ~/iec/output/pn/test.dta , nogen

	cap destring pc11_state_id, replace

	/* format the variable before mapping to display it in this format on the map */
	format rf_conditions %5.2f

/* test by making kerala (32) / rajasthan (8) into outliers */
replace rf_conditions = 5  if pc11_state_name == "kerala"
replace rf_conditions = -1 if pc11_state_name == "rajasthan"



/*  set legend options for spmap: add number of obs per category (legcount), size and position */
local legend_opt_blues  legenda(on) legcount legstyle(2)  legend(size(medium)) legend(position(6) col(1) ring(1) size(*.75) forcesize )  
local legend_opt_rd_grn legenda(on)   		 legstyle(3)  legend(size(medium)) legend(position(3) 		 ring(1) size(*.6)  region(lcolor(black)) )  

/* set colors for spmap:  for the polygons (fcolor) and outline/border colors (ocolor) */
local  map_blues   	 fcolor(Blues)   osize(vvthin ..)    ocolor(gray ..)   ndsize(vvthin ..)
local  map_gren_red  fcolor(RdYlGn)  osize(vvthin ..)    ocolor(white ..)  ndsize(vvthin ..)

/* test blank map by state (the id needs to match the id listed in shp2dta command */
spmap using $tmp/state_coord, id(geo_id)  osize(vvthin ..) title("Blank Map of Indian States", size(*0.8))
		
	graphout map_blank 

/* state-level heatmap of rf_conditions */
spmap rf_conditions using $tmp/state_coord, id(geo_id) clmethod(quantile)  clnumber(4)   ///
	title("Indian States by RF Conditions", size(*0.8))  legtitle("RF Conditions (state count in brackets)") `legend_opt_blues'  `map_blues'

	graphout heatmap_blues

/* state-level heatmap of rf_conditions */
spmap rf_conditions using $tmp/state_coord, id(geo_id) clmethod(quantile) clnumber(8)   ///
	title("Indian States by RF Conditions", size(*0.8))    `legend_opt_rd_grn'  `map_gren_red'

	graphout heatmap_red_gr
