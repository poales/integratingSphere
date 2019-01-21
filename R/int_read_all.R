#'Read all data in the folder, parse it based on type, and average them
#'
#'Given a FOLDER location, returns the average of all the transmissions and reflectances
#'in that folder.  This is used to average a significant number of scans of the same
#'sample
#'could easily be rewritten to not average them...
#'
#'@name int_read_all
#'@param tpattern text check for transmission data
#'@param rpattern text check for reflection data
#'@export
require(magrittr)
require(tidyverse)
int_read_all <- function(location,Averaging=1,tpattern= "Transmission", rpattern="Reflection"){
  setwd(location)
  file.names <- as.list(dir(location,pattern=tpattern))
  file.names.ref <- as.list(dir(location,pattern=rpattern))
  data.t <- lapply(file.names,int_read_one)
  data.r <- lapply(file.names.ref,int_read_one)
  myfun <- function(x,y){
    merge(x,y,by="Wavelength")
  }
  data.t.red <- suppressWarnings(reduce(data.t,myfun))
  data.r.red <- suppressWarnings(reduce(data.r,myfun))
  rm(list=c("data.r","data.t"))
  data.t.m <- data.frame(Wavelength=data.t.red[,1],MeanT=rowMeans(data.t.red[,-1]))
  data.r.m <- data.frame(Wavelength=data.r.red[,1],MeanR=rowMeans(data.r.red[,-1]))
  dataset <- merge(data.t.m,data.r.m,by="Wavelength")
  dataset <- add_column(dataset,Absorbance = 100 - dataset$MeanR - dataset$MeanT)
  return(dataset)
}
