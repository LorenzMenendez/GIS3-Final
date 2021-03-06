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

elctnAllData16 = inner_join(countyQuickfacts16, countyBoundaries16, by = c("fips" = "GEOID")) %>%
        select(-c(STATEFP, COUNTYFP, COUNTYNS, AFFGEOID, NAME, LSAD, ALAND, AWATER)) %>%
        st_sf() %>%
        st_zm(drop = TRUE)

remove(countyBoundaries16, countyQuickfacts16)


# STEP 3: Removing Non-Standard Data --------------------------------------

        # Reading in the Full Column Names
        dataDictionary = read.csv("./DATA/county_facts_dictionary.csv")
        View(dataDictionary)
        
        # Removing non-percent variables
        delVars = c("PST045214", # List of Variable Names to Remove
                 "PST040210", 
                 "POP010210", 
                 "LFE305213", 
                 "HSG495213", 
                 "HSD310213", 
                 "INC910213", 
                 "INC110213", 
                 "BZA010213", 
                 "BZA110213", 
                 "NES010213", 
                 "SBO001207", 
                 "MAN450207", 
                 "WTN220207", 
                 "RTN130207", 
                 "RTN131207", 
                 "AFN120207", 
                 "BPS030214", 
                 "LND110210", 
                 "POP060210",
                 "SBO515207") # This Variable is Removed because it has value 0 for all counties
        
        elctnData16 = select(elctnAllData16, -vars) # Returns 35 variables
        
        # Removing old data
        remove(elctnAllData16)

# STEP 4: Sanity Checking by Plotting Data --------------------------------
library(tmap)
tmap_mode("view")
tm_shape(elctnData16) + 
        tm_borders("black", lwd = .5)


# STEP 5: Exporting to GeoJSON ------------------------------------------
st_write(elctnData16, "DATA/electnData16.geojson", driver = "GeoJSON", delete_dsn = TRUE)

