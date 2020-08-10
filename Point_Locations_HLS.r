#Load required libraries
library(raster)
library(rgdal)
library(gdalUtils)
library(rgeos)

library(foreach)
library(doMC)

library(rjson)


###########################################
##Inputs

#Tile 
tile <- '18TYN'
year <- 2017:2018

# Point Coordinate
Lon <- -72.1715
Lat <- 42.5378


#What data folder
imgBase <-   '/projectnb/modislc/projects/landsat_sentinel/v1_4/HLS30/'
chunkBase <- '/projectnb/modislc/projects/landsat_sentinel/MSLSP_HLS30/'

#Define and create output directory
outFolder <- '/projectnb/modislc/users/mkmoon/ImageProcess/plots/'

#Where is the data?
imgDir <- paste0(imgBase,tile,'/images/')
chunkDir <- paste0(chunkBase,tile,'/imageChunks/')

# Get default parameters. Json file where phenology parameters are defined. Will just use the phenology paramaters from this 
jsonFile <- "/usr3/graduate/mkmoon/GitHub/MSLSP/MSLSP_Parameters.json"
params <- fromJSON(file=jsonFile)

showObservations <- T
showSpline <- T
showPhenDates <- F
showFilledData <- F
showDespiked <- F
showSnow <- F
yrsToPlot <- year
imgYrs <- year
phenYrs <- year

numCores <- 8
registerDoMC(numCores)


#Name of shapefile. Must be in same projection as the tile. Must have "id" column
shpName <- paste0('/projectnb/modislc/projects/landsat_sentinel/MSLSP_assessment/shps/',tile,'_pts.shp')


###########################################
## Load functions 
source(file='/usr3/graduate/mkmoon/GitHub/MSLSP/MSLSP_Functions.r')
source(file='/usr3/graduate/mkmoon/GitHub/MSLSP/Development/MSLSP_Diagnostic_Functions_V1_0.r')


###########################################

theTable <- Extract_Timeseries(tile, imgDir, chunkDir, imgYrs, phenYrs, numCores, params, shpName=shpName,codeVersion='V1') 







      
      
      

