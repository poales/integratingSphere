#'Turn a integrating sphere dataset into a nice graph with licor dataset
#'
#'A very narrow function because it is written specially for my own computer.
#'accepts a compiled dataset with specifically 4 columns, in order.
#'designed to be called from other functions in this file...
#'returns a ggplot object.
#'displays a graph with the transmittance reflectance, absorbance and the licor LED spectra
#'and also adds annotations dictating the average absorbance over the half-bandwidths of the blue and red LEDs.
#'@name int_graph
#' @param licordat show or hide the li-6800 LED spectra
#' @export
require(magrittr)
require(tidyverse)
int_graph <- function(dataset, licordat=TRUE){
  require(reshape2)
  colnames(dataset) <- c("Wavelength","Transmittance","Reflectance","Absorbance")
  plotdata <- melt(dataset,id.vars = "Wavelength")

  if(licordat){
    licordata <- integratingSphere::licorSpectra
    #licordata <- read_csv(file = "C:/Users/owner/Dropbox/Alan/2018_03_27 Greenhouse vs cart benthy/licorSpectra.csv")
  }

  #absorbances
  blue_abs <- mean(dataset[dataset$Wavelength<=494 & dataset$Wavelength>=471,]$Absorbance)

  #red
  red_abs <- mean(dataset[dataset$Wavelength<=637 & dataset$Wavelength>=622,]$Absorbance)

  ann_table <- data.frame(Wavelength = 480,value=50,text = paste0("Avg ",round(blue_abs,2)),stringsAsFactors = F) %>%
    rbind(c(630,50,paste0("Avg ",round(red_abs,2))))%>%
    mutate_at(.vars = c("Wavelength","value"), as.numeric)

  if(licordat){
    myplot <- ggplot(plotdata,mapping=aes(x=Wavelength,y=value))+
      scale_color_manual(values=c("darkviolet","forestgreen","cornflowerblue"))+
      geom_point(mapping=aes(col=variable))+
      ylim(0,100)+
      xlim(350,800)+
      geom_point(licordata,mapping=aes(x=Wavelength,y=Intensity/560),col="red",size=.4)+
      geom_label(data=ann_table,mapping = aes(x=Wavelength,y=value,label=text))+
      theme_minimal()+
      theme(panel.grid.major = element_line(color = "black"),
            panel.grid.minor = element_blank())+
      ylab("Percent")
  } else {
    myplot <- ggplot(plotdata,mapping=aes(x=Wavelength,y=value))+
      scale_color_manual(values=c("darkviolet","forestgreen","cornflowerblue"))+
      geom_point(mapping=aes(col=variable))+
      ylim(0,100)+
      xlim(350,800)+
      theme_minimal()+
      theme(panel.grid.major = element_line(color = "black"),
            panel.grid.minor = element_blank())+
      ylab("Percent")
  }


  return(myplot)
}
