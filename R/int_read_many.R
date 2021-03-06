#' Import and read all files of a certain type in a chosen folder
#'
#'This function accepts a folder location, reads in all files in that directory, and averages them.
#' @name int_read_many
#' @param location the FOLDER path containing multiple scans.
#' @param Averaging averages by X wavelengths.  Default 1.
#' @param checkTxt if your folder contains non-data files, you have to apply a check text to make sure you only read the ones you want.
#' @param label The name of the "business" column, which accompanies your Wavelength.
#' @export

int_read_many <- function(location,Averaging=1,checkTxt ="",label="Mean"){
  setwd(location)
  file.names <- as.list(dir(location,pattern = checkTxt))
  data <- lapply(file.names,function(x)int_read_one(x,Averaging=Averaging,label=label))
  myfun <- function(x,y){
    merge(x,y,by="Wavelength")
  }
  suppressMessages(data.red <- purrr::reduce(data,myfun))
  dataset <- data.frame(Wavelength=data.red[,1],Mean=rowMeans(data.red[,-1]))
  colnames(dataset) <- c("Wavelength",label)
  return(dataset)
}
