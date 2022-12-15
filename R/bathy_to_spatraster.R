#' Cast bathy to SpatRaster
#'
#' This function converts a \code{marmap::bathy} object to 
#' a \code{terra::SpatRaster}.
#'
#' @param bathy a \code{marmap::bathy} to convert
#' @returns a \code{terra::SpatRaster} with the relief for the chosen region
#'
#' @keywords internal


bathy_to_spatraster <- function(bathy) {
  if(!requireNamespace("marmap", quietly=TRUE)){
    message("This function requires the 'marmap' package; install it with:\n",
            "install.packages('marmap')")
    return(invisible())
  }
  
  if (!inherits(bathy,"bathy")) stop("Object is not of class bathy")
  
  lat <- as.numeric(colnames(bathy))
  lon <- as.numeric(rownames(bathy))
  
  r <- terra::rast(ncol = nrow(bathy), nrow = ncol(bathy),
                   xmin = min(lon), xmax = max(lon),
                   ymin = min(lat), ymax = max(lat))
  terra::values(r) <- as.vector(bathy[,rev(1:ncol(bathy))])
  
  return(r)
  
}

