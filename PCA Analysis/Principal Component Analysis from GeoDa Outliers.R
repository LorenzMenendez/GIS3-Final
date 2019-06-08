# Goal: Study covariance and perform a Principal Component Analysis

# Source: https://www.youtube.com/watch?v=Od8gfNOOS9o & https://stats.stackexchange.com/questions/4093/interpreting-pca-scores

library(sf)
library(dplyr)

# STEP 1: Read GeoJSON from saved GeoDa file ------------------------------

outlierData = st_read("DATA/studyData.geojson") %>% 
        filter(LowHigh == 1 | HighLow == 1) %>% 
        select(-POLY_ID) 


# STEP 2: Determining whether we can do a Principal Component Analysis ------------------------------------------------------

outlierCor = select(outlierData, -area_name, -fips, -state_abbreviation, -LowHigh, -HighLow, -pct_trm) %>% 
        st_drop_geometry() %>%
        cor() 

View(outlierCor) # Some vairables are highly correlated with each other

outlierCor[, "pct_hll"] %>% View() # We notice that certain variables are correlated or anticorrelated with election results

# Verifing formally using KMO
library(psych)
KMO(outlierCor) # Shows that KMO = 0.57 > 0.5 overall so it's significant to do PCA 

# STEP 3: Principal Component Analysis ------------------------------------

        # Removing the dependent variable pct_hll (col and row #51) and run PCA
        library(FactoMineR)
        outlierPCA = outlierCor[-ncol(outlierCor),-nrow(outlierCor)] %>%
                PCA()

        # Interpreting the calculated PCA components
        View(outlierPCA$var$coord)
        View(outlierPCA$eig)
