#' Downscale an ice mask
#'
#' Downscaling the ice mask presents some issues. The mask is a binary raster,
#' so any standard downscaling approach will still look very blocky. We can
#' smooth the contour by applying a Gaussian filter. How strong that filter
#' should be is very much a matter of personal opinion, as we do not have any
#' data to compare to. This function attempts to use as sensible default value,
#' but it is worth exploring alternative values to find a good solution.
#'
#' @param ice_mask_low_res a [`terra::SpatRaster`] of the low resolution ice mask
#' to downscale (e.g. as obtained with [get_ice_mask()])
#' @param land_mask_high_res a [`terra::SpatRaster`] of the land masks at different
#' times (e.g. as obtained from [make_land_mask()]). The ice mask will be cropped
#' and matched for the resolution of this land mask.
#' @returns a [`terra::SpatRaster`] of the ice mask (1's), with the rest of the
#' world (sea and land) as NA's
#'
#' @keywords internal

make_ice_mask <- function(ice_mask_low_res, land_mask_high_res, d=c(0.5,3)) {
  ice_mask_low_res_bin <- make_binary_mask(ice_mask_low_res)
  ice_mask_high_res <- resample(ice_mask_low_res_bin, land_mask_high_res, method="bilinear")
  gauss_filt <- focalMat(ice_mask_high_res, d, "Gauss")
  ice_mask_gf <- focal(ice_mask_high_res, w = gauss_filt)
  ice_mask_gf[ice_mask_gf<0.5]<-NA
  ice_mask_gf[!is.na(ice_mask_gf)]<-1
  return(ice_mask_gf)
}  
