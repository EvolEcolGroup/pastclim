#' Get metadata from vrt
#'
#' This function extract metadata information from a vrt. It returns the description
#' for the whole dataset (needed to set the varname in the raster) and time 
#' information for each band. It first checks 
#' that the vrt dataset has a metadata element with key "pastclim_time_bp" set to TRUE. If that
#' is the case, for each band, it extract the metadata with key "time" and returns
#' them as numeric (i.e. converting them from character).
#' Note that an error is returned if there are duplicated time elements for any of the
#' bands (whilst duplicated elements are valid in the XML schema for VRT, they do
#' not make sense for the time axis).
#' @param vrt_path path to the XML file defining the vrt dataset
#' @returns list of three elements: vector `description` and `time_bp` defining 
#' each band, and a boolean `time_bp` show determining whether times should be given
#' as time_bp when labelling bands by terra
#'
#' @keywords internal
vrt_get_meta <- function(vrt_path) {
  x<- xml2::read_xml(vrt_path)
  # check that we have metadata information needed for pastclim
  has_time_node <- xml2::xml_find_first(x, "./Metadata/MDI[@key = 'pastclim_time_bp']")
  if (inherits(has_time_node,"xml_missing")){
    stop ("metadata element 'pastclim_time_bp' missing; time information not available for this raster")
  } 
  # new determine whether time is in bp (with the pastclim conventions) or CE
  time_bp <- as.logical(xml2::xml_text(has_time_node))

  # get the varname for this dataset
  description<- xml2::xml_text((xml2::xml_find_first(x, "./Description")))
  # get the time infor for each band
  time_band <- as.numeric(xml2::xml_text(xml2::xml_find_all(x, "./VRTRasterBand/Metadata/MDI[@key = 'time']")))
  # make sure that time metadata was unique (i.e. not duplicated)
  if (length(time_band)!=length(xml2::xml_find_all(x, "./VRTRasterBand"))){
    stop("duplicated time elements in at least one band")
  }
  if (!time_bp){
    time_band <- time_band-1950
  }
  return(list(description=description, time_bp=time_band, time_bp_display = time_bp))
}



