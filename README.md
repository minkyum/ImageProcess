# ImageProcess

Functions for general MODIS and HLS image process

- Extract time sereis for point location

  - Point_Locations_MODIS.r
  
    With a point coordinate (i.e., longitude and latitude) and a target year, the code give a time sereis of LST
    
  - Point_Locations_MODIS.r
  
    Based on a provided shpefhile, the code returns a data list including time series of VIs, phenometircs, etc.    

- Defiend functions in the code "ImageProcess_Functions.r"

  - SaveImageStackMatrix
  
    - Input: tile, year, output folder
    - Output: MODIS LST images will be stacked as a large matrix
    - Raw LST images should be downloaded first under the folder "/projectnb/modislc/data/LST"
    
  - LSTpointTimeseries
  
    - Input: tile, year, Lon, Lat, output folder
    - Output: A data frame having dates and LST values
    - Before running this code, "SaveImageStackMatrix" should be run first
    
  - getMODIStileFromLonLat
    - It returns a MODIS tile ID from a coordinate
  - getHLStileFromLonLat
    - It returns a HLS tile ID from a coordinate   
  - getMODIStilesFromHLStile
    - It returns MODIS tile ID(s) from a HLS tile ID
