# Goal: To combine Isaac's Voting Data with the Demographic and Social Data

library(sf)
library(dplyr)

# STEP 1: Import Isaac’s Data ---------------------------------------------

elctnVotes16 = st_read("DATA/county_level_election_results_2016.shp") %>% 
        select(FIPS, pct_hll, pct_trm)


# STEP 2: Right Join to Demographic data -----------------------------------

studyData = st_drop_geometry(elctnData16) %>% 
        inner_join(as.data.frame(elctnVotes16), by = c("fips" = "FIPS"))

# STEP 3: Export Study Data as GeoJSON for GeoDa ESDA ---------------------

st_write(studyData, "DATA/studyData.geojson", driver = "GeoJSON")
