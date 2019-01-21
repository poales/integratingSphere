#'Create an absorbance measurement from one file of transmittance and one file of reflectance
#'

#'this function accepts a single transmission dataset, a single reflection dataset,
#'and returns the absorbance calculated as a=1-t-r
#'@name int_abs
#'@param trans_loc location of a file with transmittance data
#'@param ref_loc location of a file with reflectance data
#'@export

require(magrittr)
require(tidyverse)
int_abs <- function(trans_loc,ref_loc, averaging=1){
  transmission <- read_delim(trans_loc,delim="\t",col_names = c("Wavelength","Transmission"),col_types = "dd") %>%
    filter(Wavelength>0) %>%
    aggregate(Transmission~Wavelength %/% averaging, ., mean) %>%
    set_colnames(c("Wavelength","Transmittance"))
  reflection <- read_delim(ref_loc,delim="\t",col_names = c("Wavelength","Reflection"),col_types = "dd") %>%
    filter(Wavelength>0) %>%
    aggregate(Reflection~Wavelength %/% averaging, ., mean) %>%
    set_colnames(c("Wavelength","Reflectance"))
  abs_data <- merge(transmission,reflection) %>%
    bind_cols(Absorbance = 100-(.$Reflectance+.$Transmittance)) %>%
    return()
}
