#' Downscale an ice mask
#'
#' Downscaling the ice mask presents some issues. The mask is a binary raster,
#' so any standard downscaling approach will still look very blocky. We can
#' smooth the contour by applying a Gaussian filter. How strong that filter
#' should be is very much a matter of personal opinion, as we do not have any
#' data to compare to. This function attempts to use a sensible default value,
#' but it is worth exploring alternative values to find a good solution.
#'
#' The Guassian filter can lead to edge effects. To minimise such effects, this
#' function initially crops the ice mask to an extent that is larger than
#' `land_mask_high_res`, as defined by `expand_xy`. After applying the Gaussian
#' filter, the resulting raster is then cropped to the exact size of
#' `land_mask_high_res`.
#'
#' @param ice_mask_low_res a [`terra::SpatRaster`] of the low resolution ice
#'   mask to downscale (e.g. as obtained with [get_ice_mask()])
#' @param land_mask_high_res a [`terra::SpatRaster`] of the land masks at
#'   different times (e.g. as obtained from [make_land_mask()]). The ice mask
#'   will be cropped and matched for the resolution of this land mask.
#' @param d a numeric vector of length 2, specifying the parameters for the
#'   Gaussian filter. The first value is the standard deviation of the Gaussian
#'   filter (sigma), and the second value is the size of the matrix to return.
#'   The default is c(0.5, 3).
#' @param expand_xy a numeric vector of length 2, specifying the number of units
#'   to expand the extent of the ice mask in the x and y directions when
#'   applying the Gaussian filter. This is to avoid edge effects. The default is
#'   c(5,5).
#' @returns a [`terra::SpatRaster`] of the ice mask (1's), with the rest of the
#'   world (sea and land) as NA's
#'
#' @export

downscale_ice_mask <- function(ice_mask_low_res, land_mask_high_res,
                               d = c(0.5, 3),
                               expand_xy = c(5, 5)) {
  ice_mask_low_res_bin <- make_binary_mask(ice_mask_low_res)
  # create a margin around the land mask to avoid edge effects when using the
  # Gaussian filter
  ice_mask_high_res <- resample(ice_mask_low_res_bin,
    extend(
      land_mask_high_res,
      terra::ext(as.vector(terra::ext(land_mask_high_res)) +
        c(-expand_xy[1], +expand_xy[1], -expand_xy[2], +expand_xy[2]))
    ),
    method = "bilinear"
  )
  gauss_filt <- focalMat(ice_mask_high_res, d, "Gauss")
  ice_mask_gf <- focal(ice_mask_high_res, w = gauss_filt)
  ice_mask_gf[ice_mask_gf < 0.5] <- NA
  ice_mask_gf[!is.na(ice_mask_gf)] <- 1
  ice_mask_gf <- terra::crop(ice_mask_gf, land_mask_high_res)
  return(ice_mask_gf)
}
