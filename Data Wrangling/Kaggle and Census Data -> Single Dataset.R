# Goal: Automatically download Kaggle Election Data from static URLs

library(sf)
library(dplyr)


# STEP 1: Importing Data --------------------------------------------------


# County Boundaries from Census Shapefile
download.file("https://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_county_500k.zip", "./DATA/countyBoundaries.zip")
unzip("./DATA/countyBoundaries.zip", exdir = "./DATA")

countyBoundaries16 = st_read("./DATA/cb_2014_us_county_500k.shp")

countyBoundaries16$GEOID = as.numeric(levels(countyBoundaries16$GEOID))[countyBoundaries16$GEOID] # Required for join to work

# County Quick Facts from Kaggle 
# download.file("https://www.kaggle.com/benhamner/2016-us-election/downloads/county_facts.csv", "./DATA/countyQuickfacts.csv") # Broken and not working for some reason! 

countyQuickfacts16 = read.csv("./DATA/countyQuickfacts.csv", sep = ",")


# STEP 2: Wrangling into a single dataset ---------------------------------

elctnData16 = inner_join(countyQuickfacts16, countyBoundaries16, by = c("fips" = "GEOID")) %>%
        select(-c(STATEFP, COUNTYFP, COUNTYNS, AFFGEOID, NAME, LSAD, ALAND, AWATER)) %>%
        st_sf() %>%
        st_zm(drop = TRUE)

remove(countyBoundaries16, countyQuickfacts16)


# STEP 3: Sanity Checking by Plotting Data --------------------------------
library(tmap)
tmap_mode("view")
tm_shape(elctnData16) + 
        tm_borders("black", lwd = .5)


# STEP 4: Exporting to GeoJSON ------------------------------------------
st_write(elctnData16, "DATA/electnData16.geojson", driver = "GeoJSON")

