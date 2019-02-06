#'Reads one file and formats it for use with other functions
#'
#'simple function that interprets the raw data file
#'"Averaging" means you get one data point per # wavelengths
#'so, with default, you get one data point per wavelength, usually the average of 2-3
#'data points
#'@name int_read_one
#'@param location location of an integrating sphere data file
#'@export

int_read_one <- function(location,Averaging=1,label = "X"){
  int_data <- suppressWarnings(readr::read_delim(location,delim="\t",col_names=c("Wavelength",label),col_types="dd"))
  int_data <- dplyr::filter(int_data,Wavelength>0)
  int_data <- aggregate(X~Wavelength%/% Averaging,int_data,mean)
  colnames(int_data) <- c("Wavelength", label)
  return(int_data)
}
