


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

## Spatial Data 

_If you've worked with spatial data and  made maps before, consider skipping this section. 
It offers a brief explanation of how any sort of table-format data interacts with spatial data (points, polygons) to make a map._

A common map you can make with spmap is a map of polygons colored based on the values of a variable of interest, e.g. mapping US states or countries by average income per capita 
or population density or some other numeric or categorical metric. It is called a _**[Cloropleth map](https://en.wikipedia.org/wiki/Choropleth_map)**_.

In this case, each state is a polygon (i.e. a shape consisting of lines and coordinate points in space), and income would be the variable you map.


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


#### 2. Raster Data

* An image where each uniformly-sized pixel has a certain value (typically based on color) 
    - E.g. night lights, land cover, etc. 
    - Not easily imported into STATA, and hence beyond the scope of this tutorial


#### Question:


* **What are the types of data you see in this map?**

<img src="https://user-images.githubusercontent.com/33915653/129160452-aba74575-2a00-4b4e-9018-60798d31bd54.png" height="600">


([Source](https://www.translink.ca/-/media/translink/documents/transit-fares/where-to-buy/london_drugs_compass_vending_machine_locations.pdf))


* **What are the types of data you see in this map?**

<img src="https://user-images.githubusercontent.com/33915653/129158702-79bf2b28-b8e4-4d91-b1db-ab8ad63bd23e.png" height="600">

(Screenshot from [Google Earth](https://earth.google.com/web/@49.34894001,-123.047145,176.51533574a,523016.13350607d,35y,0h,0t,0r/data=CiQSIhIgMGY3ZTJkYzdlOGExMTFlNjk5MGQ2ZjgxOGQ2OWE2ZTc))



### Additional Resources 

Basic online guide with STATA introduction example based on US states [here](https://www.stata.com/support/faqs/graphics/spmap-and-maps/) 

Other short helpful videos to watch:

* A [5-min video](https://www.youtube.com/watch?v=3mn3op7EJ5M) on projections and spatial data types from Statistics Canada
* A [21-min video tutorial](https://www.youtube.com/watch?v=PG4s5acfJ5Y) specifically on GRMAP example of drawing a map of world countries using World Bank data in STATA 
(similar to this tutorial) with details on prep & cleaning, but not covering the options
* A [3-min video](https://www.youtube.com/watch?v=F7U-nJj9yUg) on point data in R with a link to a [full course on mapping in R](https://learn.datacamp.com/courses/visualizing-geospatial-data-in-r) _(not useful for STATA, but has useful info on spatial data more broadly)_


_______________________________________________________________________________________________________


## Do-file Structure

_The following step-by-step guide was originally partially based on  [STATA's official intro guide](https://www.stata.com/support/faqs/graphics/spmap-and-maps/) to mapping with spmap_

Sample do-file script: `map_in_spmap.do`. It creates the maps shown below, and the following section highlights just some of the many options of spmap. 

The file consists of two main parts: 

1. Import the shapefile into STATA (with `shp2dta`), which creates two datasets (specified in suboptions):
* one with the table list of regions with their unique id values (`database()`)
* the other with the geographic information (`coordinates()`)
* `genid()` - specifies a unique id which links the region unit id (e.g. state number) to their spatial info (coordinates of each vertix of the polygon) (make sure it's different from the actual state id)

2. Merge the spatial dataset with the dataset with your variable of interest
* make sure you rename the spatial-unit unique polygon identifier (e.g. state id)) with the same name you will have in your dataset with the variable of interest (e.g. income)
* some options for the maps are taken out into the locals with three sample maps (blank, a map in shades of a single color with a detailed legend, a map in colors from green to red with a less detailed legend)
* the output is highlighting some of the different options for spmap 



**Note:**

* there are also options to produce a map with points of different sizes and bars, check the spmap help for more info
* a scalebar can be an added tool
* as of now, spmap doesn't provide an option of having a baselayer map behind your data polygons (e.g. a topographic or any other type of map, that function is supported in ArcGIS, QGIS, etc.)
* If you want to explore additional spmap options with vivid examples, consult the [following page](https://zhuanlan.zhihu.com/p/86492495). The page is Mandarin, but a Google Chrome add-on will easily translate that for you. The code for each map **preceeds** the sample map in the page. 



_______________________________________________________________________________________________________

## Map Samples 


**Blank map:** 

[[/files/map_blank_small.png]]


**Map samples with different styles:**

[[/files/map_samples.png]]


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


Working code:

```
(see separate do files)

```


