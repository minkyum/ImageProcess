#Load required libraries
library(raster)
library(rgdal)
library(gdalUtils)
library(rgeos)

library(foreach)
library(doMC)

###########################################
## Define functions

SaveImageStackAsMatrix <- function(tile, year, outFolder){
  
  # Call image list and stack as a matrix
  imgPath <- '/projectnb/modislc/data/LST'
  sstr    <- paste0('*',tile,'*hdf')
  imgs    <- list.files(path = imgPath, pattern = glob2rx(sstr), full.names = T, recursive = T)
  imgs    <- imgs[which(substr(imgs,66,69)==year)] # Only target year
  
  imgBase <- raster(get_subdatasets(imgs[1])[[1]])
  
  # Stack images as matrix
  registerDoMC()
  
  imgStack <- foreach(i=1:length(imgs),.combine=cbind) %dopar% {
    values(raster(get_subdatasets(imgs[i])[[1]]))
  }
  
  
  setwd(outFolder)
  save(imgStack,file=paste0('imageStackMatrix_',tile,'_',year,'.rda'),overwrite=T)
  
}

LSTpointTimeseries <- function(tile, year, Lon, Lat, outFolder){
  
  # Load image stack matrix
  load(paste0(outFolder,'/imageStackMatrix_',tile,'_',year,'.rda'))
  
  
  # Call image list and stack as a matrix
  imgPath <- '/projectnb/modislc/data/LST'
  sstr    <- paste0('*',tile,'*hdf')
  imgs    <- list.files(path = imgPath, pattern = glob2rx(sstr), full.names = T, recursive = T)
  imgBase <- raster(get_subdatasets(imgs[1])[[1]])
  
  
  # Dates
  yy <- substr(imgs,68,69)
  mm <- substr(imgs,71,72)
  dd <- substr(imgs,74,75)
  dates <- as.Date(paste0(yy,'/',mm,'/',dd),'%y/%m/%d')
  
  # Creae point shapefile
  pCoor   <- data.frame(1,Lon,Lat)
  lonlat  <- pCoor[,c(2,3)]
  pShp    <- SpatialPointsDataFrame(coords = lonlat,
                                    data = pCoor,
                                    proj4string = CRS("+proj=longlat +datum=WGS84"))
  pShp    <- spTransform(pShp,crs(imgBase))
  
  
  # Get pixel number 
  pixNum <- setValues(imgBase,1:length(imgBase))
  pixNum <- extract(pixNum,pShp)
  
  datMat <- matrix(NA,length(imgs),2)
  datMat[,1] <- dates
  datMat[,2] <- imgStack[pixNum,]
  
  colnames(datMat) <- c('Date','LST')
  
  return(datMat)
}

getMODIStileFromLonLat <- function(Lon,Lat){
  
  # MODIS tiles shapefile
  MODIStiles <- readOGR('/projectnb/modislc/users/mkmoon/ImageProcess/shps/modis_sinusoidal_grid_world.shp')
  
  # Creae point shapefile
  pCoor   <- data.frame(1,Lon,Lat)
  lonlat  <- pCoor[,c(2,3)]
  pShp    <- SpatialPointsDataFrame(coords = lonlat,
                                    data = pCoor,
                                    proj4string = CRS("+proj=longlat +datum=WGS84"))
  pShp    <- spTransform(pShp,crs(MODIStiles))
  
  MODIStile <- intersect(pShp,MODIStiles)
  h <- sprintf('%02d',as.numeric(as.character(MODIStile$h)))
  v <- sprintf('%02d',as.numeric(as.character(MODIStile$v)))
  tile <- paste0('h',h,'v',v)
  
  return(tile)
}

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

      
      

