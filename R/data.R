#' Time boundaries of marine isotope stages (MIS).
#'
#' A dataset containing the beginning and end of MIS.
#'
#' @format A data frame with 24 rows and 2 variables:
#' \describe{
#'   \item{mis}{the stage, a string}
#'   \item{start}{the start of a given MIS, in kya}
#'   \item{end}{the start of a given MIS, in kya}
#' }
"mis_boundaries"

#' Region extents.
#'
#' A list of extents for major regions.
#'
#' @format A list of vectors giving the extents.
"region_extent"

#' Region outlines.
#'
#' An \code{sf} object containing outlines for major regions. Outlines that
#' span the antimeridian have been split into multiple polygons.
#'
#' @format \code{sf} of outlines.
#' \describe{
#'   \item{name}{names of regions}
#' }
"region_outline"

#' Region outlines unioned.
#'
#' An \code{sf} object containing outlines for major regions. Each outline is
#' represented as a single polygon. If you want multiple polygons, use
#' \link{region_outline}.
#'
#' @format \code{sf} of outlines.
#' \describe{
#'   \item{name}{names of regions}
#' }
"region_outline_union"
