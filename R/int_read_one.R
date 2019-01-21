#'Reads one file and formats it for use with other functions
#'
#'simple function that interprets the raw data file
#'"Averaging" means you get one data point per # wavelengths
#'so, with default, you get one data point per wavelength, usually the average of 2-3
#'data points
#'@name int_read_one
#'@param location location of an integrating sphere data file
#'@export
require(magrittr)
require(tidyverse)
int_read_one <- function(location,Averaging=1){
  int_data <- suppressWarnings(read_delim(location,delim="\t",col_names=c("Wavelength","X"),col_types="dd"))
  int_data <- filter(int_data,Wavelength>0) %>%
    aggregate(X~Wavelength%/% Averaging,.,mean) %>%
    set_colnames(c("Wavelength","X"))
}
