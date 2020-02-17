#'Turn a integrating sphere dataset into a nice graph with licor dataset
#'
#'A very narrow function because it is written specially for my own computer.
#'accepts a compiled dataset with specifically 4 columns, in order.
#'designed to be called from other functions in this file...
#'returns a ggplot object.
#'Requires reshape2 library.
#'displays a graph with the transmittance reflectance, absorbance and the licor LED spectra
#'and also adds annotations dictating the average absorbance over the half-bandwidths of the blue and red LEDs.
#'@name int_graph
#' @param dataset A dataset with Wavelength, Transmittance, Reflectance, and Absorbance data
#' @param licordat show or hide the li-6800 LED spectra
#' @export


int_graph <- function(dataset, licordat=TRUE,sharkeySpec=F){
  colnames(dataset) <- c("Wavelength","Transmittance","Reflectance","Absorptance")
  plotdata <- reshape2::melt(dataset,id.vars = "Wavelength")

  if(licordat){
    licordata <- integratingSphere::licorSpectra
  }
  if(sharkeySpec){
    ss_spec <- integratingSphere::sharkeySpectra
  }

  #absorbances
  if(sharkeySpec){
    #blue
    blue_abs <- mean(dataset[dataset$Wavelength<=479 & dataset$Wavelength>=455,]$Absorptance)
    #red
    red_abs <- mean(dataset[dataset$Wavelength<=661 & dataset$Wavelength>=649,]$Absorptance)
    ann_table <- data.frame(Wavelength = 450,value=50,text = paste0("Blue Avg ",round(blue_abs,2)),stringsAsFactors = F)
    ann_table <- rbind(ann_table, c(650,50,paste0("Red Avg ",round(red_abs,2))))
  }else{
    #blue
    blue_abs <- mean(dataset[dataset$Wavelength<=494 & dataset$Wavelength>=471,]$Absorptance)
    #red
    red_abs <- mean(dataset[dataset$Wavelength<=637 & dataset$Wavelength>=622,]$Absorptance)
    ann_table <- data.frame(Wavelength = 480,value=75,text = paste0("Blue Avg ",round(blue_abs,2)),stringsAsFactors = F)
    ann_table <- rbind(ann_table, c(630,75,paste0("Red Avg ",round(red_abs,2))))
  }
  
  ann_table <- dplyr::mutate_at(ann_table,.vars = c("Wavelength","value"), as.numeric)
  myplot <- ggplot2::ggplot(plotdata,mapping=ggplot2::aes(x=Wavelength,y=value))+
    ggplot2::scale_color_viridis_d()+
    ggplot2::geom_point(mapping=ggplot2::aes(col=variable))+
    ggplot2::ylim(0,100)+
    ggplot2::xlim(350,800)+
    ggplot2::theme_classic()+
    ggplot2::ylab("Percent")

  if(licordat){
    myplot <- myplot +
      ggplot2::geom_point(licordata,mapping=ggplot2::aes(x=Wavelength,y=Intensity/560),col="red",size=.4)+
      ggplot2::geom_label(data=ann_table,mapping = ggplot2::aes(x=Wavelength,y=value,label=text))
  }
  if(sharkeySpec){
    myplot <- myplot +
      ggplot2::geom_point(licordata,mapping=ggplot2::aes(x=Wavelength,y=Intensity/300),col="red",size=.4)+
      ggplot2::geom_label(data=ann_table,mapping = ggplot2::aes(x=Wavelength,y=value,label=text))
  }

  return(myplot)
}
