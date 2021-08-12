

* This is for the ECON 531 research project on LA urbanization 

  cd "C:\Users\idali\Dropbox\UBC 2018+\ECON 531 Econ History\Data Urban LA\Analysis"
		* change before running the code
		
* Necessary packages, already installed
* Uncomment if not
*
*		ssc install spmap
*		ssc install shp2dta
* 		ssc install labutil 
			* this is a package enabling to use a string var to assign value labels to a numeric var



*******************************************************************************
**
*			LOADING THE WORLD MAP OF COUNTRIES
**
*******************************************************************************

shp2dta using "QGIS_countries", database("country_db") coordinates("country_coord") genid(country_id)

use country_db, clear
	describe
	gen WB_code = iso3
	
	save country_db.dta, replace

spmap  using country_coord, id(country_id) legenda(on) legtitle("World Map (blank)") leglabel("Countries (N = 255)") 
	
drop if iso3 == "ATA"
	* drop Antarctica (not relevant)

spmap  using country_coord, id(country_id) legenda(on) legtitle("World Map (blank)") leglabel("Countries (N = 254)") 
		* graph export Blank_map.png, as(png) replace
		graph export Blank_map.wmf, as(wmf) replace
		

spmap country_id using country_coord, id(country_id) legenda(on) legtitle("World Map (blank)") leglabel("Country ID")   clmethod(quantile) clnumber(5) fcolor(YlGnBu)
	* Checking the map and the commands, just coloring by ID number (not meaningful)

		save country_db.dta, replace

*******************************************************************************
**
*					MERGING WITH COUNTRY CODES
**
*******************************************************************************

* Creating dta files from Excel spreadsheets

import excel Data_for_STATA\Country_code_region_capital.xlsx, sheet("for_STATA_min") firstrow clear

	gen WB_code = Lettercode

save country_codes_region.dta, replace



* use country_codes_region.dta, clear
* describe

/*		 Contains data from country_codes_region.dta
			obs:           195                          
			vars:          20  

    Result                           # of obs.
    -----------------------------------------
    not matched                            59
        from master                        59  (_merge==1)
        from using                          0  (_merge==2)

    matched                               195  (_merge==3)
*/






  cd "C:\Users\idali\Dropbox\UBC 2018+\ECON 531 Econ History\Data Urban LA\Analysis"

  use country_db.dta, clear 

egen subregion_ord = group(subregion )
separate Urbanrate_2016, by(subregion_ord )


*******************************************************************************
**
*							MAPS 
**
*******************************************************************************

grmap, activate

grmap Urbanrate_2014 using country_coord, id(country_id) legenda(on) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100) fcolor(Blues) title("Urban rate in 2014") legtitle("% living in urban areas") legend(size(medium))
	graph export Urban_rate_2014.png, as(png) replace

grmap urb_rate_avg_1960s  using country_coord, id(country_id) legenda(on) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100) fcolor(Blues) title("Urban rate in 2014") legtitle("% living in urban areas") legend(size(medium))
	graph export Urban_rate_1960s.png, as(png) replace

grmap  urban_rate_1950 using country_coord, id(country_id) legenda(on) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100) fcolor(Blues) title("Urban rate in 2014") legtitle("% living in urban areas") legend(size(medium))
	graph export Urban_rate_1950.png, as(png) replace
	
grmap  urban_rate_1950 using country_coord, id(country_id) legenda(on) clmethod(custom) clbreaks(0 10 20 30 40 50 60 70 80 100) fcolor(YlGnBu) title("Urban rate in 2014") legtitle("% living in urban areas") legend(size(medium))
	graph export Urban_rate_1950_color.png, as(png) replace
	
grmap Gini_avg_10y using country_coord, id(country_id) legenda(on) legtitle("World Map - Gini Index") leglabel("Countries")   clmethod(quantile) clnumber(5) fcolor(PuRd) legend(size(medium))
	graph export Gini_map.wmf, as(wmf) replace
	graph export Gini_map.png, as(png) replace

grmap region using country_coord, id(country_id) legenda(on) legtitle("Regions") leglabel("Countries") fcolor(YlGnBu)   clmethod(unique)  legstyle(3) legend(size(medium))
	graph export Regions_map.png, as(png) replace

grmap subregion using country_coord, id(country_id) legenda(on) legtitle("Subregions") leglabel("Countries") fcolor(YlGnBu)   clmethod(unique)  legend(size(medium))
	graph export Regions_subregion_map.png, as(png) replace

grmap small_region using country_coord, id(country_id) legenda(on) legtitle("Subregions") leglabel("Countries") fcolor(Rainbow)   clmethod(unique) plotregion(icolor(gs16)) 
	graph export Regions_small_region_map.png, as(png) replace

grmap Spanish_colony using country_coord, id(country_id) legenda(on) legtitle("Spanish_colonies") leglabel("Countries") fcolor(BuPu) legend(size(medium))
	graph export Spanish_colonies.png, as(png) replace

grmap British_colony using country_coord, id(country_id) legenda(on) legtitle("British_colonies") leglabel("Countries") fcolor(PuBuGn) legend(size(medium))
	graph export British_colonies.png, as(png) replace

grmap colony_fra  using country_coord, id(country_id) legenda(on) legtitle("French colonies") leglabel("Countries") fcolor(PuBuGn) legend(size(medium))
	graph export French_colonies.png, as(png) replace
	
grmap urban_under_50_1950 using country_coord, id(country_id) legenda(on) clmethod(unique) title("Under 50% urban in 1950") legtitle("Dummy for under 50% urban") fcolor(PuBuGn) legend(size(medium))
	graph export urban_under_50_1950.png, as(png) replace
	
grmap AgricultureofGDP_2016  using country_coord, id(country_id) legenda(on) legtitle("Share of Agriculture in GDP") leglabel("Countries") fcolor(YlGnBu) legend(size(medium))
	graph export AgricultureofGDP_2016.png, as(png) replace

grmap IndustryofGDP_2016  using country_coord, id(country_id) legenda(on) legtitle("Share of Industry in GDP") leglabel("Countries") fcolor(YlGnBu) legend(size(medium))
	graph export IndustryofGDP_2016.png, as(png) replace

grmap ManufacturingofGDP_2016  using country_coord, id(country_id) legenda(on) legtitle("Share of Manufacturing in GDP") leglabel("Countries") fcolor(YlGnBu) legend(size(medium))
	graph export ManufacturingofGDP_2016.png, as(png) replace

grmap ServicesofGDP_2016  using country_coord, id(country_id) legenda(on) legtitle("Share of Services in GDP") leglabel("Countries") fcolor(YlGnBu) legend(size(medium))
	graph export ServicesofGDP_2016.png, as(png) replace

grmap Developing1 using country_coord, id(country_id) legenda(on) legtitle("Developing")  fcolor(Blues) legend(size(medium))
	graph export ServicesofGDP_2016.png, as(png) replace

grmap inform_empl_avg_2004_2016 using country_coord, id(country_id) legenda(on) legtitle("Informal employment (non-agric)") leglabel("Countries") clmethod(quantile) clnumber(5) fcolor(Blues) legend(size(medium))
	graph export Informality_inform_empl_map.png, as(png) replace

grmap Firms_w_inform_compet using country_coord, id(country_id) legenda(on) legtitle("Firms facing informal competition") leglabel("Countries") clmethod(quantile) clnumber(5) fcolor(Blues) legend(size(medium))
	graph export Informality_Firms_w_inform_competition_map.png, as(png) replace

grmap schooling_avg_yr_comb_2010 using country_coord, id(country_id) legenda(on) clmethod(custom)  clbreaks(0 5 8 10 14) fcolor(Oranges) title("Educational attainment, 2010") legtitle("Avg years of schooling") legend(size(medium))
	graph export Schooling_years_map.png, as(png) replace

grmap Pplninlargestcityofurban  using country_coord, id(country_id) legenda(on) clmethod(custom) clbreaks(0 20 30 40 50 80) fcolor(Blues) title("Urban primacy") legtitle("Population in largest city (% of urban)") legend(size(medium))
	graph export Urban_primacy_map.png, as(png) replace
	
grmap Urbanrate_2016 using country_coord, id(country_id) legenda(on) clmethod(custom) clbreaks(0 50 100) fcolor(Blues) title("Urbanization 2016") legtitle("Share of urban population (%)") legend(size(medium))
	graph export Urbanization_50cutoff_2016.png, as(png) replace	

	
grmap GDPpercapitaPPPconst2011  using country_coord, id(country_id) legenda(on) clmethod(custom) clbreaks(0 2500 5000 10000 15000 25000 35000 50000 100000) fcolor(YlGnBu) title("GDP per capita (PPP), 2016") legtitle("Const PPP USD $ 2011") legend(size(medium))
	graph export GDPpercapita_map.png, as(png) replace
	
grmap Totalnaturalresourcesrents using country_coord, id(country_id) legenda(on) clmethod(custom) clbreaks(0 5 10 20 30 40 50) fcolor(Greens) title("Natural Resource Rents") legtitle("Resource Rents (% of GDP)") legend(size(medium))
	graph export NatResRents_map.png, as(png) replace

grmap MineralrentsofGDP_2014  using country_coord, id(country_id) legenda(on) clmethod(custom) clbreaks(0 1 5 10 15 30) fcolor(Greens) title("Mineral Rents") legtitle("Mineral Rents (% of GDP)") legend(size(medium))
	graph export MineralRents_map.png, as(png) replace

grmap rugged_norm  using country_coord, id(country_id) legenda(on) clmethod(quantile) fcolor(RdYlGn) title("Terrain Ruggedness by country") legtitle("Ruggedness Index, standardized (Puga)") legend(size(medium))
	graph export Ruggedness_stdd.png, as(png) replace

