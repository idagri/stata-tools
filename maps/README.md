


# Making maps in STATA with SPMAP / GRMAP

`Spmap` is a tool that enables you to produce a basic map in STATA. `Grmap` is its updated version in more recent versions of STATA, works with a very similar syntax.

While it has many customization options for changing the look of the map (sometimes pretty verbose), 
this package doesn't let you do any spatial statistical analysis or change the underlying geographies. 

STATA can be your go-to tool to produce a basic map that is pretty enough for exploration and context, 
plus, the convenience of not having to switch programs if you are already conducting your analysis in STATA. 
However, it's UNLIKELY to be your primary mapping tool if the project requires more sophisticated or extensive spatial work.

_______________________________________________________________________________________________________

_Before trying to use `spmap` or the `shp2dta` commands, make sure you've installed the programs, i.e. open Stata and run:_

* `ssc install spmap` 
* `ssc install shp2dta`


_______________________________________________________________________________________________________

## Learning Objectives (LOs) <img src="https://user-images.githubusercontent.com/33915653/129183783-856bf107-9dff-42fc-aa95-ea93ef604ecd.png" height="50">


By the end of the reading and working through this guide, you will be able to:

* Name and distinguish the main types and subtypes of spatial data
* Identify the mapping package and its key options in STATA
* Create an original map from a new spatial data source (after practicing)

_[emoji source](https://www.pngegg.com/en/png-eeofh)_
_______________________________________________________________________________________________________

## Spatial Data 


_If you've worked with spatial data and  made maps before, consider skipping this section. 
It offers a brief explanation of how any sort of table-format data interacts with spatial data (points, polygons) to make a map._

A common map you can make with spmap is a map of polygons colored based on the values of a variable of interest, e.g. mapping US states or countries by average income per capita 
or population density or some other numeric or categorical metric. It is called a _**[Cloropleth map](https://en.wikipedia.org/wiki/Choropleth_map)**_.

In this case, each state is a polygon (i.e. a shape consisting of lines and coordinate points in space), and income would be the variable you map.


<img src="https://user-images.githubusercontent.com/33915653/129184220-88f2c647-e4a9-4a82-8ca2-edf1556f029a.png" height="250"> [(source)](https://www.researchgate.net/figure/GIS-has-capability-to-integrate-different-types-of-spatial-data-areas-ie-parts-of-the_fig8_221929448)


### What is Spatial Data? 


In this tutorial, I will explain how to make a map coloring different areas (e.g. countries / provinces / counties) by the value of some variable related to them.

Basic explanation with an analogy:

> Think of making a map as arranging a dinner table. If your spatial units (e.g. states) are plates, and your variables of interest (e.g. income) are your dishes that you put on the plates. 
> In the `shp2dta`, the `dataset` includes the "dishes" and the `coordinates` include the info about the plates.


In order for the command to know what the shape of each region looks like on the map, we need a separate geo-data file that contains this information. Such data is commonly stored in shapefiles that can be imported into STATA to make sure that spmap know how to map the polygons relative to each other. 



### Types of Spatial Data

#### 1. Vector Data

* Points 
    - Coordinates (2 values of lat and long for each observation)
    - E.g. cities or houses 

* Lines
    - Each object (area) is a collection of coordinate points in a specific order where each pair is considered "connected" by a line
    - E.g. highways, rivers, transit networks 
  
* Polygons
    - Each object (area) is a collection of coordinate points in a specific order in a closed loop (the last connects with the first)
    - Each point is a pair of coordinates
    - Recorded in an almost unreadable format in STATA / shapefiles 
    - E.g. countries or US states (OR could also be cities if you're mapping there specific boundaries in a smaller region rather than point coordinates on a bigger map)
    - This data is very frequently displayed is basic maps and is the subject of **this tutorial** 


| Polygons on a Coordinate System             |  Polygons on a Base City Map |
:-------------------------:|:-------------------------:
![image](/maps/visuals/graph_polygons_on_coord_system.jpg)      | ![image](/maps/visuals/graph_polygons_on_basemap.png) |
[Source](https://achievethecore.org/coherence-map/6/26/266/266) | [Source](https://medium.com/modus-create-front-end-development/placing-markers-inside-google-maps-polygons-855552210e4b) | 


#### 2. Raster Data

* An image where each uniformly-sized pixel has a certain value (typically based on color) 
    - E.g. night lights, land cover, etc. 
    - Not easily imported into STATA, and hence beyond the scope of this tutorial


<details>
<summary>    Reflect on your experience with maps:  </summary>
<br>

	What are types of spatial data you have encountered recently? 
	
	Think of a map you came across in your daily life and the objects it had.
	
	
</details>


--------------------------------------------------

### Question - Test Yourself:

_Have a look at the drop-down question, answer is hidden below, try to answer before seeing the answer_ :smile:

<details>
<summary>   What are the types of data you see in these maps? </summary>
<br>

| Map 1             |  Map 2 |
:-------------------------:|:-------------------------:
**Vancouver Transit Map & Compass Card Purchase locations** | **Night lights around Delhi, India, <br> with subdistrict borders and cities over 1 million people**  
<img src="https://user-images.githubusercontent.com/33915653/129160452-aba74575-2a00-4b4e-9018-60798d31bd54.png"> | ![image](https://user-images.githubusercontent.com/33915653/129258323-f873e838-aacb-4d68-90ed-a9bd5036a8d6.png)
([Source](https://www.translink.ca/-/media/translink/documents/transit-fares/where-to-buy/london_drugs_compass_vending_machine_locations.pdf)) | Original map based on the [Google Earth](https://earth.google.com/web/@49.34894001,-123.047145,176.51533574a,523016.13350607d,35y,0h,0t,0r/data=CiQSIhIgMGY3ZTJkYzdlOGExMTFlNjk5MGQ2ZjgxOGQ2OWE2ZTc) night lights data, Indian subdistricts map and Geonames city coordinates  )

	
	
</details>


<details>
<summary>   Check yourself </summary>
<br>

| Map 1             |  Map 2 |
:-------------------------:|:-------------------------:
| A vector map with lines and points            |  A vector map of cities and subdistricts overlaid over the raster of night lights |
| The map doesn't really include any polygons, they could be neighborhood areas, for instance   |  The map includes city point locations with point size varying by population, subdistrict polygons, and night lights raster data in the background 
| | This map could be used to calculate the average night lights density in each subdistrict, for instance (outside of STATA, raster calculations are not supported in spmap) |

	
	
</details>

--------------------------------------------------



### Additional Resources 

Basic online guide with STATA introduction example based on US states [here](https://www.stata.com/support/faqs/graphics/spmap-and-maps/) 

Other short helpful videos to watch:

* A [5-min video](https://www.youtube.com/watch?v=3mn3op7EJ5M) on projections and spatial data types from Statistics Canada
* A [21-min video tutorial](https://www.youtube.com/watch?v=PG4s5acfJ5Y) specifically on GRMAP example of drawing a map of world countries using World Bank data in STATA 
(similar to this tutorial) with details on prep & cleaning, but not covering the options
* A [3-min video](https://www.youtube.com/watch?v=F7U-nJj9yUg) on point data in R with a link to a [full course on mapping in R](https://learn.datacamp.com/courses/visualizing-geospatial-data-in-r) _(not useful for STATA, but has useful info on spatial data more broadly)_


_______________________________________________________________________________________________________


## Working Example with US States

### Looking for Spatial Data (Shapefiles)

The assumption is that you have the table-form data with a variable of interest you want to map, this tutorial is based on the US states wellbeing rank taken based on the Gallup 2018 survey with the results shared [here](https://news.gallup.com/poll/247034/hawaii-tops-wellbeing-record-7th-time.aspx). Basic cleaning of renaming variables etc. is outside of the scope of this tutorial.

As for spatial data, when you want to make a map of something for the first time, you will need to find a file that (in jibberish to a beginner) stores the spatial information about the polygons you want to map - i.e. the location and size of the dishes on the dining table, before figuring out how to link dishes to plates.

For simple cases, such as US states or world countries, a simple Google search for `US states shapefile` would yield many relevant results, and you need to use your judgement to select the most approapriate source. In this case, `census.gov` apprears to be as reliable as it can get for the US, so I am selecting it as the [main source](https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html) for shapefiles we'll use for US states.

[US States shapefiles](https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html), selecting the largest file for higher resolution of the map:

* [cb_2018_us_state_500k.zip](https://www2.census.gov/geo/tiger/GENZ2018/shp/cb_2018_us_state_500k.zip) (3.2 MB)

After unzipping, the folder will look like this:

![image](https://user-images.githubusercontent.com/33915653/129244070-ddfd092d-8e9c-4f19-85d9-ff7bab9f11b2.png)


* Shapefile features:
    * Shapefiles often come as zip folders, unzip them in your desired directory preferably in a subfolder with a desired name and you'll get several files with different extensions that are a part of the spatial shapefile ingrastructure
    * the files we are interested in are:
        *  `.shp` extension (contains the geometries, i.e. coordinates of objects / areas of interest) 
        *  `.dbf` (contains the table-form data with names for every object in the .shp file with geometries


### Do-file Structure

_The following step-by-step guide was originally partially based on  [STATA's official intro guide](https://www.stata.com/support/faqs/graphics/spmap-and-maps/) to mapping with spmap_

Sample do-file script: `map_in_spmap_US_states.do`. It creates the maps shown below, highlighting just a couple of the many options of spmap. 

The file consists of the following main sections: 

0. Cleaning socio-economic data relevant to the map of interest
    * There are no comments here on this as it's beyond the scope of the mapping tutorial

1. Import the shapefile into STATA (with `shp2dta`), which creates two datasets (specified in suboptions):
    * one with the table list of regions with their unique id values (`database()`)
    * the other with the geographic information (`coordinates()`)
    * `genid()` - specifies a unique id which links the region unit id (e.g. state number) to their spatial info (coordinates of each vertix of the polygon) (make sure it's different from the actual state id)
    * An additional section to label each state on the map (based on a STATA forum discussion) - no need to get into the details, presented for convenience  

2. Merge the spatial dataset with the dataset with your variable of interest
    * make sure you rename the spatial-unit unique polygon identifier (e.g. state id)) with the same name you will have in your dataset with the variable of interest (e.g. income)
    * some options for the maps are taken out into the locals with three sample maps (blank, a map in shades of a single color with a detailed legend, a colorful map with adjusted line color and font sized)
    * the output is highlighting some of the different options for spmap 



**Note:**

* there are also options to produce a map with points of different sizes and bars, check the spmap help for more info
* a scalebar can be added
* as of now, spmap doesn't provide an option of having a baselayer map behind your data polygons (e.g. a topographic or any other type of map, that function is supported in ArcGIS, QGIS, etc.)
* If you want to explore additional spmap options with vivid examples, consult the [following page](https://zhuanlan.zhihu.com/p/86492495). The page is Mandarin, but a Google Chrome add-on will easily translate that for you. The code for each map **preceeds** the sample map in the page. 

* Check out some of the options for color themes [here](http://repec.sowi.unibe.ch/stata/palettes/colors.html) 

_______________________________________________________________________________________________________

## Map Samples 


**Blank map:** 

```
/* test blank map by state (the id needs to match the id listed in shp2dta command */
spmap using us_states_coord.dta, id(id)  osize(vvthin ..) title("Blank Map of US States", size(*0.8))		

```

![image](https://user-images.githubusercontent.com/33915653/129176675-0769cfac-a38e-45cb-a3b9-02394587a6b6.png)



**Map samples with different styles:**




#### Default:

Working code for the map specifically:

```

local state_labeling " label(data(maplabels) xcoord(x_c)  ycoord(y_c)    label(NAME)  size(*0.75 ..) pos(12 0) ) "

/* draw the wellbeing map with labels with defaults */
spmap wellbeing_rank using  state_coordinates_mercator.dta , id(id)  `state_labeling' 
	
```

![image](https://user-images.githubusercontent.com/33915653/129179622-647336cb-c191-400b-ad09-bd9f096486e2.png)


#### Small channges:

![image](https://user-images.githubusercontent.com/33915653/129178707-661b26a6-df11-4227-85e2-50db2edcbf8f.png)

#### Beautifying parameters:


```

local state_labeling " label(data(maplabels) xcoord(x_c)  ycoord(y_c)    label(NAME)  size(*0.75 ..) pos(12 0) ) "

/* draw the wellbeing map with labels, beautifying parameters */
spmap wellbeing_rank using  state_coordinates_mercator.dta , id(id) fcolor(BuYlRd)  ocolor(white ..)  clnumber(5)  legcount `state_labeling' 
	
```



![image](https://user-images.githubusercontent.com/33915653/129179470-3f4d92f1-6140-4026-8603-737304140390.png)


## Select options

| Option      	  | Purpose                                                               |
|-----------------|---------------------------------------------------------------------|
| clnumber()      | number of unique categories (colors) you want to display  			| 
| clmethod()      | type of categorization (e.g. quantile or custom where you can specify ranges of each category   |
| legcount    	  | a sub-option to display the count of regions in each category                                     |
| legstyle(#)     | the blue map has option 2 with detailed ranges, the green-red map has option 3 which only specifies the min and max  |
| position(#)     | the position of the legend with respect to the map (e.g. top = 1, bottom = 6, right  = 3) |
| col(#) / row(#) | specifying the max number of rows or columns on the legend                                |
| fcolor()        | polygon coloring color theme                                                  | 
| ocolor()        | polygon border (outline) color _(has to be specified separately for polygons with missing values using ndcolor, ndsize, etc.)_                                                               |


Full do file with cleaning and merging before making the map can be found here as `map_in_spmap_US_states.do`.



Working code for the map specifically:

```
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

```

_______________________________________________________________________________________________________


## Take-Home Task

* Create a new map of a region of interest to you showing a variable we haven't looked at 
    * Use a different shapefile (not US states)
    * You can choose any variable to show on the map 
 
* Change some settings 
    * select a different color scheme for output
    * explore 2 additional options from the [STATA help guilde](http://repec.org/bocode/s/spmap) and show them on the map
   
* Write 2 sentences (do stick to 2 non-run-on sentences practicing summarizing the main message): 
    1) 1 sentence explaining what the map shows - what is the main message / why you think this map is interesting
    2) 1 sentence explaining why you chose the visual representation you chose (why is this a good color theme and text size) and identify one point that could be improved



