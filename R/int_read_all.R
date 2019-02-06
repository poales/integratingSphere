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

int_read_all <- function(location,Averaging=1,tpattern= "Transmission", rpattern="Reflection"){
  setwd(location)
  file.names <- as.list(dir(location,pattern=tpattern))
  file.names.ref <- as.list(dir(location,pattern=rpattern))
  data.t <- int_read_many(location,checkTxt=tpattern)
  data.r <- int_read_many(location,checkTxt=rpattern)
  colnames(data.t) <- c("Wavelength","MeanT")
  colnames(data.r) <- c("Wavelength","MeanR")
  dataset <- merge(data.t,data.r,by="Wavelength")
  dataset <- tibble::add_column(dataset,Absorbance = 100 - dataset$MeanR - dataset$MeanT)
  return(dataset)
}
