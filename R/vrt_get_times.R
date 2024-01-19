#' Get time axis from vrt
#'
#' This function extract time information for the bands in a vrt. It first checks 
#' that the vrt dataset has a metadata element with key "has_time" set to TRUE. If that
#' is the case, for each band, it extract the metadata with key "time" and returns
#' them as numeric (i.e. converting them from character).
#' Note that an error is returned if there are duplicated time elements for any of the
#' bands (whilst duplicated elements are valid in the XML schema for VRT, they do
#' not make sense for the time axis).
#' @param vrt_path path to the XML file defining the vrt dataset
#' @returns a vector of times, one per band
#'
#' @keywords internal
vrt_get_times <- function(vrt_path) {
  x<- xml2::read_xml(vrt_path)
  has_time_node <- xml2::xml_find_first(x, "./Metadata/MDI[@key = 'has_time']")
  if (inherits(has_time_node,"xml_missing")){
    stop ("metadata element 'has_time' missing; time information not available for this raster")
  } else if (!as.logical(xml2::xml_text(has_time_node))){
    stop ("time metadata element 'has_time' not equal to TRUE; time information not available for this raster")
  }
  time_band <- as.numeric(xml2::xml_text(xml2::xml_find_all(x, "./VRTRasterBand/Metadata/MDI[@key = 'time']")))
  if (length(time_band)==length(xml2::xml_find_all(x, "./VRTRasterBand"))){
    return(time_band)
  } else {
    stop("duplicated time elements in at least one band")
  }
}



