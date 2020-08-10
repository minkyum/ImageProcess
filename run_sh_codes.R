#################
# Run code "get_MYD11A1.R" to get MODIS LST
setwd('/projectnb/modislc/data/LST/')

tile <- 'h12v04'
year <- 2018

system(paste('qsub -V -l h_rt=06:00:00 /usr3/graduate/mkmoon/GitHub/ImageProcess/run_get_MYD11A1.sh ',tile,year,sep=''))        


