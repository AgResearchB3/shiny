
# This function takes a vector of colors and creates plots with each such background color, prints them and stores them
# as *.png files in the current working directory and then creates a vector of characters with the html code to 
# incorporate the plots into the addLayersControl() function as labels.



fCreateColRectAndHtmlLabels <- function(vec_cols) {

	for (i in 1: length(vec_cols)){
		#png(paste0('0',i,'_','colrect.png'))	
		#	par(bg = vec_cols[i])
		#	plot(c(100,250), c(300,450), type= "n",axes= FALSE, xlab = "", ylab = "")
	#dev.off()
    
		if (!(exists('htmlLabelsRec'))){
			htmlLabelsRec <- character()
			htmlLabelsRec <- htmltools::HTML(paste0("<div style='float:left;width:10px;height:10px;background:",vec_cols[i],";border:1px solid #000;'></div>",' 0.',i))
				
		} else {
			htmlLabelsRec <- c(htmlLabelsRec, 
			htmltools::HTML(paste0("<div style='float:left;width:10px;height:10px;background:",vec_cols[i],";border:1px solid #000;'></div>",' 0.',i)))
		}
	
	}
return(htmlLabelsRec)	
}

