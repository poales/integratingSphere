#'Fully work up a complete data set of integrating sphere data
#'
#'A fully-featured function that accepts a series of folders to automatically work up.
#'Pass in the FOLDER location of your baseline (no plant) reflectance, plant reflectance
#'and plant transmittance.
#' @name int_baseline_all
#' @param Averaging a variable that reflects how many wavelengths will be averaged together. Default: 1, so 1 point per wavelength
#' @param writeLoc If provided, will write out the collected data to the chosen directory. Provides csvs for reflectance, transmittance, baseline, and compiled.
#' @param writePrefix Standard text added to the front of filenames for written out files.
#' @export

int_baseline_all <- function(locationBaseline, locationReflectance, locationTransmittance, Averaging=1, writeLoc = NULL, writePrefix = "") {
  #read data
  baseline_data <- int_read_many(locationBaseline,Averaging = Averaging,checkTxt = "Reflection")
  colnames(baseline_data) <- c("Wavelength","Reflectance")
  reflectance_data <- int_read_many(location = locationReflectance, Averaging = Averaging,checkTxt = "Reflection")
  colnames(reflectance_data) <- c("Wavelength","Reflectance")
  transmittance_data <- int_read_many(location = locationTransmittance, Averaging=Averaging,checkTxt = "Transmission")
  colnames(transmittance_data) <- c("Wavelength","Transmittance")

  #Calculate baseline adjustment
  #calculates the light that is transmitted through the leaf, is reflected by the bottom sphere, gets transmitted back
  #through the plant, and then gets detected by the top sphere.
  #necessary for correcting for A<0% in NIR.
  suppressWarnings(adjustment_matrix <- merge(transmittance_data, baseline_data, by="Wavelength"))
  adjvec <- (adjustment_matrix$Transmittance/100)^2
  adjustment_matrix <- tibble::add_column(adjustment_matrix,TransTrans = adjvec)
  adj2 <- adjvec * baseline_data$Reflectance/100
  adjustment_matrix <- tibble::add_column(adjustment_matrix,TTR = adj2)

  #Apply the baseline adjustment
  suppressWarnings(plant_data_adj <- merge(transmittance_data,reflectance_data,by="Wavelength"))
  plant_data_adj <- tibble::add_column(plant_data_adj,TTR=adjustment_matrix$TTR)
  plant_data_adj <- tibble::add_column(plant_data_adj,RefAdj=plant_data_adj$Reflectance-(plant_data_adj$TTR)*100)
  plant_data_adj <- tibble::add_column(plant_data_adj,Absorbance=100-plant_data_adj$RefAdj-plant_data_adj$Transmittance)

  #generate a graph
  adj_data_plot <- int_graph(dplyr::select(plant_data_adj,"Wavelength","Transmittance","RefAdj","Absorbance"))

  #optionally write data
  if(!is.null(writeLoc)){
    setwd(writeLoc)
    readr::write_csv(baseline_data,paste0(writePrefix,"Baseline reflectance.csv"))
    readr::write_csv(reflectance_data,paste0(writePrefix,"Plant reflectance.csv"))
    readr::write_csv(transmittance_data,paste0(writePrefix,"Plant transmittance.csv"))
    readr::write_csv(plant_data_adj, paste0(writePrefix,"Compiled plantdata.csv"))
  }

  #return everything you want
  return(list(plant_data_adj,adj_data_plot))
}
