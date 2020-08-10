#Load required libraries
library(raster)
library(rgdal)
library(gdalUtils)
library(rgeos)

library(foreach)
library(doMC)


###########################################
## Load functions 
source(file='/usr3/graduate/mkmoon/GitHub/ImageProcess/ImageProcess_Functions.r')



###########################################
## Inputs

# Point Coordinate
Lon <- -72.1715
Lat <- 42.5378

# year
year <- 2018

# MODIS tile
tile <- getMODIStileFromLonLat(Lon,Lat)

#Define output directory
outFolder <- '/projectnb/modislc/users/mkmoon/ImageProcess/data'


#################
SaveImageStackAsMatrix(tile, year, outFolder)  

theTable <- LSTpointTimeseries(tile, year, Lon, Lat, outFolder)

      
      

