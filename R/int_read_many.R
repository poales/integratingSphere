#' Import and read all files of a certain type in a chosen folder
#'
#'This function accepts a folder location, reads in all files in that directory, and averages them.
#' @name int_read_many
#' @param location the FOLDER path containing multiple scans.
#' @param Averaging averages by X wavelengths.  Default 1.
#' @param checkTxt if your folder contains non-data files, you have to apply a check text to make sure you only read the ones you want.
#' @export
require(tidyverse)
require(magrittr)
int_read_many <- function(location,Averaging=1,checkTxt =""){
  setwd(location)
  file.names <- as.list(dir(location,pattern = checkTxt))
  data <- lapply(file.names,int_read_one)
  myfun <- function(x,y){
    merge(x,y,by="Wavelength")
  }
  data.red <- reduce(data,myfun)
  rm(list=c("data"))
  dataset <- data.frame(Wavelength=data.red[,1],Mean=rowMeans(data.red[,-1]))
  return(dataset)
}
