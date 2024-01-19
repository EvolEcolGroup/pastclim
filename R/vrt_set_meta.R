#######################
#' Set vrt metadata
#'
#' This function sets the metadata information to a vrt file. For each band, it
#' adds a Description field (used to name the band), and a time.
#' @param vrt_path path to the XML file defining the vrt dataset
#' @param description_vector a vector of descriptions (same length as the number of bands)
#' @param time_vector a vector of descriptions (same length as the number of bands)
#' @returns TRUE if the file was updated correctly
#'
#' @keywords internal
## Edit the vrt metadata
vrt_set_meta <- function (vrt_path, description_vector, time_vector){
  # read vrt file
  x<- xml2::read_xml(vrt_path)
  # add metadata to indicate that we have a time axis
  xml2::xml_add_child(x,"Metadata",.where=0)
  metadata_node <- xml2::xml_find_first(x, xpath="Metadata")
  xml2::xml_add_child(metadata_node,"MDI",key="has_time","true")
  # add band description and times
  band_nodes <- xml2::xml_find_all(x, xpath="VRTRasterBand")
  for (i_node in seq_len(length(band_nodes))){
    xml2::xml_add_child(band_nodes[i_node],"Description", description_vector[i_node],
                        .where = 0)
    xml2::xml_add_child(band_nodes[i_node],"Metadata",.where = 1)
    metadata_node <- xml2::xml_find_first(band_nodes[i_node], xpath="Metadata")
    xml2::xml_add_child(metadata_node,"MDI",key="time",time_vector[i_node])
  }
  # overwrite vrt file with the new version
  xml2::write_xml(x, vrt_path) 
  return(TRUE)
}


