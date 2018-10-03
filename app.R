# Mariona Roige Valiente. 2018.
# This script builds the shiny app to visualize the leaflet maps
# in a website environment. 

rm(list=ls())

#setwd('H:/MarionaAndCraig/shiny_leaflet_maps_app/shiny/app_folder')
#setwd('/media/mariona/HD710 PRO/00_2018/wfh')
#setwd('E:/00_2018/wfh')

library(plyr)
library(dplyr)
library(rgdal)
library(leaflet)
library(leaflet.extras)
library(mapview)
library(rgeos)
library(shiny)

# load('FourLeafletCmiMaps_12Sep2018.RData') # Loads the leaflet objects 'mapDNZ' and 'mapNP'
load('five_leaflet_maps_1_Oct_2018.RData')

# Change the paths to the extra libraries that leaflet map objects have hardcoded

ak_nd_ll_map$dependencies[[1]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/lib/leaflet-providers"))
ak_nd_ll_map$dependencies[[2]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/leaflet-providers-plugin"))
ak_nd_ll_map$dependencies[[3]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/fuse_js"))
ak_nd_ll_map$dependencies[[4]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/lfx-search"))
ak_nd_ll_map$dependencies[[5]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/Leaflet.EasyButton"))
ak_nd_ll_map$dependencies[[6]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/Leaflet.awesome-markers"))


all_nz_ll_map$dependencies[[1]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/lib/leaflet-providers"))
all_nz_ll_map$dependencies[[2]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/leaflet-providers-plugin"))
all_nz_ll_map$dependencies[[3]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/fuse_js"))
all_nz_ll_map$dependencies[[4]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/lfx-search"))
all_nz_ll_map$dependencies[[5]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/Leaflet.EasyButton"))
all_nz_ll_map$dependencies[[6]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/Leaflet.awesome-markers"))

dairy_ll_map$dependencies[[1]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/lib/leaflet-providers"))
dairy_ll_map$dependencies[[2]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/leaflet-providers-plugin"))
dairy_ll_map$dependencies[[3]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/fuse_js"))
dairy_ll_map$dependencies[[4]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/lfx-search"))
dairy_ll_map$dependencies[[5]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/Leaflet.EasyButton"))
dairy_ll_map$dependencies[[6]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/Leaflet.awesome-markers"))


nat_park_ll_map$dependencies[[1]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/lib/leaflet-providers"))
nat_park_ll_map$dependencies[[2]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/leaflet-providers-plugin"))
nat_park_ll_map$dependencies[[3]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/fuse_js"))
nat_park_ll_map$dependencies[[4]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/lfx-search"))
nat_park_ll_map$dependencies[[5]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/Leaflet.EasyButton"))
nat_park_ll_map$dependencies[[6]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/Leaflet.awesome-markers"))


port_of_tauranga_ll_map$dependencies[[1]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/lib/leaflet-providers"))
port_of_tauranga_ll_map$dependencies[[2]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/leaflet-providers-plugin"))
port_of_tauranga_ll_map$dependencies[[3]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/fuse_js"))
port_of_tauranga_ll_map$dependencies[[4]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet.extras/htmlwidgets/build/lfx-search"))
port_of_tauranga_ll_map$dependencies[[5]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/Leaflet.EasyButton"))
port_of_tauranga_ll_map$dependencies[[6]]$src$file <- normalizePath(paste0(.libPaths()[1], "/leaflet/htmlwidgets/plugins/Leaflet.awesome-markers"))



#----------------------------------------------
# Shiny stuff
#----------------------------------------------

ui <- fluidPage(
  titlePanel("Maps showing climatic similarity between subsets of NZ and the rest of the world"), 	
  
  sidebarLayout(
    sidebarPanel( 
      helpText('Choose the map you want to display. Thanks for being patient while map loads'),  
      helpText('For more information about these maps please contact Craig Phillips (craig.phillips@agresearch.co.nz) or Mariona Roigé (mariona.roige@agresearch.co.nz). 
When documenting use of these maps, please cite:'),
      helpText('Phillips CB, Kean JM, Vink C, Berry J 2018. Utility of the CLIMEX match climates regional algorithm for pest risk analysis: An evaluation with non-native ants in New Zealand. Biological Invasions 20, 777–791. https://doi.org/10.1007/s10530-017-1574-2
'),
      selectInput('maptoshow', 
                               label = h3('Map to display'),
                               choices = c('NZ dairy pasture' = 'dnz' , 'NZ national parks' = 'NPnz', 'Auckland and Northland Crosby areas' = 'Akl', 'All New Zealand' = 'NZ', 'Port of Tauranga'='PoT'),									
                               selected = 'NZ')),
    
    mainPanel ( mymap <- leafletOutput('mymap', height = 900),
               p())

  )
)

server <- function(input, output, session) {
  
  output$debug <- renderPrint({					# Debugging code 
    sessionInfo()
    input$maptoshow
  })
  
  
  whichmap <- reactive({
    
    if (input$maptoshow == 'dnz') {
      # Load a DairyNZ CMI map
      MAP <- dairy_ll_map
    }
    if (input$maptoshow == 'NPnz'){
      # Load a NZ National Parks CMI map	
      MAP <- nat_park_ll_map	
    }
    if (input$maptoshow == 'Akl'){
      # Load a Auckland and Northland Crosby CMI map	
      MAP <- ak_nd_ll_map	
    }
	if (input$maptoshow == 'NZ'){
      # Load a whole NZ territory CMI map	
      MAP <- all_nz_ll_map	
	}	
    if (input$maptoshow == 'PoT'){
      # Load a Port of Taurange CMI map	
      MAP <- port_of_tauranga_ll_map	
    }	
    return(MAP)
  })
  
  
  output$mymap <- renderLeaflet({whichmap()})
  
}


shinyApp(ui, server)

