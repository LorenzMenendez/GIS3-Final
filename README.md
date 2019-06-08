# Better Understanding the Role of Outliers in 2016 Election Data
Final Project for GIS III — Geocomputation with R

## Introduction:
The goal for this project is to understand why there exists counties that vote for a different candidate than surrounding counties. Using an exploratory spatial data analysis technique, we found that there are 72 counties whose voting patterns are significantly different than their surround neighbor counties. To explain this phenomenon, we are going to identify the socioeconomic and demographic characteristics of outlying counties and compare them to their neighboring counties.

We assume that a percentage vote for one specific candidate is a dependent variable to social, economic, and demographic indicators. Therefore, we are going to apply an exploratory data analysis technique called Principal Component Analysis (PCA) to distill our fifty varibles down into principal (uncorrelated) components that can help us categorize the types of outliers. 

## Major Steps
### Data Wrangling 
- [x] County Boundary Shapefile with Election Data and Census QuickFact socioeconomic data
- [ ] Standardizing data to % of population data (Very Important for an accurate PCA)
- [ ] Removing redundant variables that are super similar to each other.

### Finding Outlying Counties
- [x] Exporting Data to GeoDa to run a Local Moran's I analysis based on the percentage of the vote that went to Hillary Clinton in 2016. 
- [ ] Reimporting the data to R with a column determing which counties are outliers and which are significant clusters of voting patterns.
- [ ] Calculating the LISA in R instead for reproducibility (very challenging!)

### Running PCA Analysis
- [x] Calculate correlation matrix to verify that a PCA would be statistically significant
- [ ] Run the PCA analysis on all variables except for the voting data, since its the dependent variable
- [ ] Interpret the components, determine which variables are in which components

### Regression and Prediction
- [ ] Use the components from PCA to determine which outliers fit into which counties

### Optimization
- [ ] Create helper functions to automate calculations and make code more readable and scalable

## Citations
* Running Correlations and PCA in R (https://www.youtube.com/watch?v=Od8gfNOOS9o)
* Interpreting the output from PCA (https://stats.stackexchange.com/questions/4093/interpreting-pca-scores)
* Applying PCA to Election Data (https://www.linkedin.com/pulse/understanding-pca-example-subhasree-chatterjee/)
