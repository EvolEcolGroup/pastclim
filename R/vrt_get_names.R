#' Get band names from vrt
#'
#' This function extract band names (Descriptions) in a vrt. 
#' Note that an error is returned if there are duplicated time elements for any of the
#' bands (whilst duplicated elements are valid in the XML schema for VRT, they do
#' not make sense for the time axis).
#' @param vrt_path path to the XML file defining the vrt dataset
#' @returns a vector of times, one per band
#'
#' @keywords internal
vrt_get_names <- function(vrt_path) {
  x<- xml2::read_xml(vrt_path)

  name_band <- xml2::xml_text(xml2::xml_find_all(x, "./VRTRasterBand/Description"))
  if (length(name_band)==length(xml2::xml_find_all(x, "./VRTRasterBand"))){
    return(name_band)
  } else {
    stop("duplicated descriptions in at least one band")
  }
}



