#'Reads one file and formats it for use with other functions
#'
#'simple function that interprets the raw data file
#'"Averaging" means you get one data point per # wavelengths
#'so, with default, you get one data point per wavelength, usually the average of 2-3
#'data points
#'@name int_read_one
#'@param location location of an integrating sphere data file
#'@param label The value you're reading in - ie if you're reading in a Reflectance file, set this to "Reflectance" to return a dataframe with colnames(df) c("Wavelength", "Reflectance")
#'@export

int_read_one <- function(location,Averaging=1,label = "X"){
  int_data <- readr::read_lines(location)
  flag <- T
  counter <- 0
  while(flag){
    if(!grepl("\t",int_data[counter+1]))
      counter <- counter+1
    else
      flag <- F
  }
  int_data <- tibble::tibble(int_data[-(1:counter)])
  int_data <- tidyr::separate(int_data,col = 1,sep="\t",into=c("Wavelength","X"),convert = T)

  int_data <- dplyr::filter(int_data,Wavelength>0)

  int_data <- aggregate(X~Wavelength%/% Averaging,int_data,mean)

  colnames(int_data) <- c("Wavelength", label)
  return(int_data)
}
