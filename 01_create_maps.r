# Mariona Roige Valiente. 2018.
# This script builds the leaflet maps and saves the environment so that
# they can be imported by the shiny app as R objects.
#
# Requires PANDOC installation in windows machine
# https://github.com/jgm/pandoc/releases/tag/2.2.1


rm(list=ls())

setwd('C:/00_2018/02_Shiny')

library(plyr)
library(dplyr)
library(rgdal)
library(leaflet)
library(leaflet.extras)
library(mapview)
library(rgeos)
library(shiny)

# Constants
r_func_dir <- './r_functions'
crs_geo <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")  # geographical, datum WGS84

# Retrieve some functions
source(paste(r_func_dir, 'fGetColorsToPlotAClimexMcrProjection.r', sep = '/'))
source(paste(r_func_dir, 'fDissolveSpatialPolys.r', sep = '/'))
source(paste(r_func_dir, 'fCreateColRectAndHtmlLabels.r', sep = '/'))

##				##
## NZ DAIRY MAP ##
##				##
 
# Load RData world CMI shapefile. The .5*.5dd polygons will be dissolved by CMI.
load('./world_proj_agbase_jan18_dai_dry_16May2018.RData') # wld_proj_agb
cmi <- wld_proj_agb
rm(wld_proj_agb)

# Dissolve the shapefile
cmi_diss <- fDissolveSpatialPolys(cmi, cmi$cmiRnd)

# Reclaim cmiRnd as a variable
cmi_diss$cmiRnd <- as.numeric(as.character(cmi_diss$ID))

# Copy the dissolved polygon for each CMI to a separate shapefile so the CMI polygons can be plotted as separate layers with leaflet
# Create a name for each layer
cmi_sub_nm <- cmi_diss$cmiRnd * 10
cmi_sub_nm <- paste0('cmi_', cmi_sub_nm)

# Assign relevant CMI data to each name
for (i in 1: length(cmi_sub_nm)) {
	assign(cmi_sub_nm[i], subset(cmi_diss, cmi_diss$cmiRnd == unique(cmi_diss$cmiRnd)[i]))
}

# Load RData NZ dairy area shapefile to dissolve all the .05*.05dd polygons into one polygon.
load('./Agbase_Jan2018_dai_dry_05dd_grid_wgs84.RData') # shp
nz_dai <- shp
rm(shp)

if (!(exists('nz_dai_diss'))){
nz_dai_diss <- fDissolveSpatialPolys(nz_dai, nz_dai$dummy)
}

# Get colors for each CMI to be used in map

cols <- fGetColorsToPlotAClimexMcrProjection(unique(cmi$cmiRnd))

# Create the html labels to draw colored boxes and add them to addLayersControl()
 
labs <- fCreateColRectAndHtmlLabels(cols)

# Build the map using Leaflet

	mapDNZ <- leaflet() %>%
			addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
			addSearchOSM(searchOptions(zoom = 5)) %>% # enable user to search for names within tiles
			addControl("Climate match with NZ dairy areas", position = "topright") %>%
				setView(median(cmi$Loc1Lon), median(cmi$Loc1Lat), zoom = 3) %>% # initialise view extent
			addPolygons(data = cmi_1, color = cols[1], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.1"), group = '0.1') %>%
			addPolygons(data = cmi_2, color = cols[2], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.2"), group = '0.2') %>%
			addPolygons(data = cmi_3, color = cols[3], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.3"), group = '0.3') %>%
			addPolygons(data = cmi_4, color = cols[4], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.4"), group = '0.4') %>%
			addPolygons(data = cmi_5, color = cols[5], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.5"), group = '0.5') %>%
			addPolygons(data = cmi_6, color = cols[6], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.6"), group = '0.6') %>%
			addPolygons(data = cmi_7, color = cols[7], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.7"), group = '0.7') %>%
			addPolygons(data = cmi_8, color = cols[8], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.8"), group = '0.8') %>%
			addPolygons(data = nz_dai_diss, color = 'green', weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("NZ dairy"), group = 'NZ dairy') %>%
			addLayersControl(	
				overlayGroups = c('0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8', 'NZ dairy'),
			    #overlayGroups = c(labs,"NZ dairy"), when we have managed to find the right HTML labels, we can use this line instead and draw the colored boxes.
				options = layersControlOptions(collapsed = FALSE)
					) 

##						##
## NATIONAL PARKS MAP   ##
##						##
# Since this code is basically copy paste of the code to build the previous map
# the variable names have been added 'NP' at the end of their names. 

# Load RData world CMI shapefile. The .5*.5dd polygons will be dissolved by CMI.

load('./world_cmis_for_nz_national_parks_sf.RData') # Cmi
cmiNP <- Cmi
rm(Cmi)

cmi_dissNP <- fDissolveSpatialPolys(cmiNP, cmiNP$cmiRnd)

# Reclaim cmiRnd as a variable
cmi_dissNP$cmiRnd <- as.numeric(as.character(cmi_dissNP$ID))

# Copy the dissolved polygon for each CMI to a separate shapefile so the CMI polygons can be plotted as separate layers with leaflet
# Create a name for each layer
cmi_sub_nmNP <- cmi_dissNP$cmiRnd * 10
cmi_sub_nmNP <- head(cmi_sub_nmNP, -1)
cmi_sub_nmNP <- paste0('cmiNP_', cmi_sub_nmNP)

# Assign relevant CMI data to each name
for (i in 1: length(cmi_sub_nmNP)) {
	assign(cmi_sub_nmNP[i], subset(cmi_dissNP, cmi_dissNP$cmiRnd == unique(cmi_dissNP$cmiRnd)[i]))
}

# Load RData NZ area shapefile to dissolve all the polygons into one.

load( 'nz_national_parks_sf.RData') # parks
nz_sf <- parks
rm(parks)
head(nz_sf@data)
unique(nz_sf$type)

if (!exists('nz_sf_diss')){
nz_sf_diss <- fDissolveSpatialPolys(nz_sf, nz_sf$type) # Long to run!It's inside an if() clause so that debugging this script 
}													   # is faster. 

# Get colors for each CMI to be used in map
# but first delete the cmiRnd = 1
 
togetcols <- cmiNP$cmiRnd[-(which(cmiNP$cmiRnd ==1))] 
colsNP <- fGetColorsToPlotAClimexMcrProjection(unique(togetcols))

# Draw rectangles (boxes) with each one of the colors to place them in addLayersControl()
labsNP <- fCreateColRectAndHtmlLabels(colsNP)

sort(unique(togetcols))
ls(pattern = 'cmiNP_')
names(cmiNP)

# Build mapNP using leaflet

		mapNP <- leaflet() %>%
			addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
			addSearchOSM(searchOptions(zoom = 5)) %>% # enable user to search for names within tiles
			addControl("Climate match with NZ national parks", position = "topright") %>%
				setView(median(cmi$Loc1Lon, na.rm = T), median(cmi$Loc1Lat, na.rm = T), zoom = 3) %>% # initialise view extent
			addPolygons(data = cmiNP_1, color = colsNP[1], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.1"), group = '0.1') %>%
			addPolygons(data = cmiNP_2, color = colsNP[2], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.2"), group = '0.2') %>%
			addPolygons(data = cmiNP_3, color = colsNP[3], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.3"), group = '0.3') %>%
			addPolygons(data = cmiNP_4, color = colsNP[4], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.4"), group = '0.4') %>%
			addPolygons(data = cmiNP_5, color = colsNP[5], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.5"), group = '0.5') %>%
			addPolygons(data = cmiNP_6, color = colsNP[6], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.6"), group = '0.6') %>%
			addPolygons(data = cmiNP_7, color = colsNP[7], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.7"), group = '0.7') %>%
			addPolygons(data = cmiNP_8, color = colsNP[8], weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("0.8"), group = '0.8') %>%
			addPolygons(data = nz_sf_diss, color = 'green', weight = 1, smoothFactor = 0.5,
				opacity = 1.0, fillOpacity = 0.5, label = htmltools::HTML("New Zealand National Parks"), group = 'NZ national parks') %>%
			addLayersControl(	
				# overlayGroups =  c(labsNP,"NZ dairy"), 		   
				overlayGroups = c('0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8', 'NZ National Parks'),
				options = layersControlOptions(collapsed = FALSE)
					) 
			

# Keep the two maps and delete everything else in the working space

keep <- c('mapDNZ', 'mapNP')
rm(list=ls()[! ls() %in% keep])

setwd('./app_folder')
save.image('leafletmaps.RData')


		