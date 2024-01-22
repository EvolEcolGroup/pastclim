#######################
#' Set vrt metadata
#'
#' This function sets the metadata information to a vrt file. It creates some dataset
#' wide metadata, as well as band specific descriptions and times.
#' @param vrt_path path to the XML file defining the vrt dataset
#' @param description a string with the description of the variable in this dataset
#' @param time_vector a vector of descriptions (same length as the number of bands)
#' @returns TRUE if the file was updated correctly
#'
#' @keywords internal
## Edit the vrt metadata
vrt_set_meta <- function (vrt_path, description, time_vector){
  # read vrt file
  x<- xml2::read_xml(vrt_path)
  # TODO ideally we should check that we don't already have metadata to avoid writing it twice
  # check that we don't alreayd have metadata information needed for pastclim
  has_time_node <- xml2::xml_find_first(x, "./Metadata/MDI[@key = 'pastclim_time_bp']")
  if (!inherits(has_time_node,"xml_missing")){
    stop ("metadata for pastclim is already present")
  }
  # add metadata to indicate that we have a time axis
  xml2::xml_add_child(x,"Description",description,.where=0)
  xml2::xml_add_child(x,"Metadata",.where=1)
  metadata_node <- xml2::xml_find_first(x, xpath="Metadata")
  xml2::xml_add_child(metadata_node,"MDI",key="pastclim_time_bp","true")
  # add band description and times
  band_nodes <- xml2::xml_find_all(x, xpath="VRTRasterBand")
  if (length(band_nodes)!=length(time_vector)){
    stop("the vrt has a different number of bands from the length of the time vector")
  }
  for (i_node in seq_len(length(band_nodes))){
    # add a unique description label for this band (variable_time combination)
    xml2::xml_add_child(band_nodes[i_node],"Description", 
                        paste(description,time_vector[i_node],sep="_"),
                        .where = 0)
    # add time for this band
    xml2::xml_add_child(band_nodes[i_node],"Metadata",.where = 1)
    metadata_node <- xml2::xml_find_first(band_nodes[i_node], xpath="Metadata")
    xml2::xml_add_child(metadata_node,"MDI",key="time",time_vector[i_node])
  }
  # overwrite vrt file with the new version
  xml2::write_xml(x, vrt_path)
  return(TRUE)
}


