# Goal: Take cleaned and processed Election Data ('studyData') and run a Moran's I analysis to output a LISA map and save the outliers.

# Methodology: Adapted from Marynia's Lab 2 — GEOG 28602

library(sf)
library(sp)
library(rgdal)
library(rgeos)



# STEP 1 — Running the Moran's I ------------------------------------------
library(spdep)

        # Calculate Queen Contiguity Weight Matrix, then define as listw object
        queenData = poly2nb(studyData) %>% 
                nb2listw(zero.policy = TRUE)

        # Compute Moran's I for Hillary Clinton's percent of vote
        hllMoran = moran.test(studyData$pct_hll, queenData, zero.policy = TRUE, na.action = na.omit)


# STEP 2 — Creating the LISA Map ----------------------------------------------

hllLisa = localmoran(x = studyData$pct_hll, listw = queenData, zero.policy = TRUE, na.action = na.exclude)
        
hllLisaMap = cbind(studyData, hllLisa)

### to create LISA cluster map ### 
quadrant <- vector(mode="numeric",length=nrow(hllLisa))

# centers the variable of interest around its mean
hllMean <- studyData$pct_hll - mean(studyData$pct_hll)     

# centers the hllLisa Moran's around the mean
m.hllLisa <- hllLisa[,1] - mean(hllLisa[,1])    

# significance threshold
signif <- 0.1 

# builds a data quadrant
quadrant[hllMean >0 & m.hllLisa>0] <- 4  
quadrant[hllMean <0 & m.hllLisa<0] <- 1      
quadrant[hllMean <0 & m.hllLisa>0] <- 2
quadrant[hllMean >0 & m.hllLisa<0] <- 3
quadrant[hllLisa[,5]>signif] <- 0   

# plot in r
brks <- c(0,1,2,3,4)
colors <- c("white","blue",rgb(0,0,1,alpha=0.4),rgb(1,0,0,alpha=0.4),"red")
plot(studyData,border="lightgray",col=colors[findInterval(quadrant,brks,all.inside=FALSE)], max.plot = 1)
box()
legend("bottomleft",legend=c("insignificant","low-low","low-high","high-low","high-high"),
       fill=colors,bty="n")
        