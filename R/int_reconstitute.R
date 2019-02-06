
#'Restore data written by int_baseline_all
#'
#'
#'This function uses the written data from int_baseline_all to restore the analysis but
#'without requiring that all the files be read in again.
#'@name int_reconstitute
#'@export

int_reconstitute <- function(location){
  data <- readr::read_csv(location)
  data_plot <- int_graph(dplyr::select(data,"Wavelength","Transmittance","RefAdj","Absorbance"))
  return(list(data,data_plot))
}
