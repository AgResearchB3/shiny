# Mariona Roige Valiente. 2018.
# This script builds the shiny app to visualize the leaflet maps
# in a website environment. 


#setwd('C:/00_2018/02_Shiny/test2')

library(plyr)
library(dplyr)
library(rgdal)
library(leaflet)
library(leaflet.extras)
library(mapview)
library(rgeos)
library(shiny)

load('leafletmaps.RData') # Loads the leaflet objects 'mapDNZ' and 'mapNP'


# Code to try get the colored boxes on layerControl labels on
# source('fCreateColRectAndHtmlLabels.R')
# Use the new labs with the right working directory into leaflet map structure
#mapDNZ$x$calls[[13]]$args[[2]]<- c(labs, 'New Zealand Dairy Areas')
#mapNP$x$calls[[13]]$args[[2]] <- c(labsNP, 'NZ National Parks')

# Change the paths to the extra libraries that leaflet map objects have hardcoded
mapDNZ$dependencies[[1]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/lib/leaflet-providers"))
mapDNZ$dependencies[[2]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/leaflet-providers-plugin"))
mapDNZ$dependencies[[3]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/fuse_js"))
mapDNZ$dependencies[[4]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/lfx-search"))

mapNP$dependencies[[1]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/lib/leaflet-providers"))
mapNP$dependencies[[2]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/leaflet-providers-plugin"))
mapNP$dependencies[[3]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/fuse_js"))
mapNP$dependencies[[4]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/lfx-search"))


#----------------------------------------------
# Shiny stuff
#----------------------------------------------

ui <- fluidPage(
  titlePanel("CMI maps for MPI"), 	
  
  selectInput('maptoshow', 
              label = h3('Map to display'),
              choices = c('Dairy NZ map' = 'dnz' , 'National Parks Map' = 'NPnz'),									
              selected = 'dnz')	,								
  
  
  helpText('Choose the map you want to display. Thanks for being patient while map loads'),
  
  mymap <- leafletOutput('mymap', height = 900),
  p()
  
)

server <- function(input, output, session) {
  
  output$debug <- renderPrint({					# Debugging code 
    sessionInfo()
    input$maptoshow
  })
  
  
  whichmap <- reactive({
    
    if (input$maptoshow == 'dnz') {
      # Load a DairyNZ CMI map
      MAP <- mapDNZ
    }
    if (input$maptoshow == 'NPnz'){
      # Load a NZ National Parks CMI map	
      MAP <-	mapNP	
    }
    return(MAP)
  })
  
  
  output$mymap <- renderLeaflet({whichmap()})
  
}


shinyApp(ui, server)

