# Goal: Study covariance and perform a factore analysis

# Source: https://www.youtube.com/watch?v=Od8gfNOOS9o

library(sf)
library(dplyr)

# STEP 1: Read GeoJSON from saved GeoDa file ------------------------------

outlierData = st_read("DATA/studyData.geojson") %>% 
        filter(LowHigh == 1 | HighLow == 1) %>% 
        select(-POLY_ID) 


# STEP 2: Determining whether we can do a Principal Component Analysis ------------------------------------------------------

outlierCor = select(outlierData, -area_name, -fips, -state_abbreviation, -LowHigh, -HighLow, -pct_trm) %>% 
        st_drop_geometry() %>%
        select(-SBO515207) %>% 
        cor() 

outlierCor[, "pct_hll"] %>% sort() # We notice that certain variables are highly correlated or anticorrelated with election results

# Verifing formally using KMO
library(psych)
KMO(outlierCor) # Shows that KMO = 0.64 > 0.5 overall so it's significant to do PCA 

# STEP 3: Principal Component Analysis ------------------------------------

outlierPCA = princomp(outlierCor, scores = TRUE, cor = TRUE)

summary(outlierPCA) # Based on Kaiser Rule, the factors that have Eigen Values > 1 are significant. So, we have ~7 values to content with.

screeplot(outlierPCA, type = "line", main = "Scree Plot") # Shows that there's a big step between the 1st & 2nd/3rd components, suggesting that the first component shows most of the variation.

biplot(outlierPCA)

outlierPCA$scores["pct_hll",]
