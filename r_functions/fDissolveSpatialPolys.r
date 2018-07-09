fDissolveSpatialPolys <- function(sp_polygon_df, dissolve_var){
	# From https://rpubs.com/MScGeocomputation/233673

	library(rgeos)
	library(sp)

	# Assign polygon IDs to the rownames of sp_polygon_df@data
   rownames(sp_polygon_df@data) <- sapply(slot(sp_polygon_df, "polygons"), function(x) slot(x, "ID"))   

	# Join dissolve dissolve_var to sp_polygon_df in a temporary list of polygon objects
   temp <- gUnaryUnion(sp_polygon_df, dissolve_var) # use slotNames(Temp)

	# Copy polygon IDs to a DF
   id_list <- data.frame(ID=sapply(slot(temp, "polygons"), function(x) slot(x, "ID")))

   rownames(id_list)  <- id_list$ID

# Create SpatialPolygonsDataFrame from list of polygons & a DF
   SpatialPolygonsDataFrame(temp, id_list)

}

