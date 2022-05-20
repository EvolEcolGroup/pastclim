#' Documentation for the Beyer2020 dataset
#'
#' This dataset covers the last 120k years, at intervals of 1/2 k years.
#'
#' This dataset can be downloaded with \code{\link{download_dataset}}. The
#' files can be found at
#'
#' Manica, Andrea (2022): pastclim_beyer2020_v1.0.0. figshare. Dataset.
#' \url{https://doi.org/10.6084/m9.figshare.19723405.v1}
#'
#' based on
#'
#' Beyer, R.M.,
#' Krapp, M. & Manica, A. High-resolution terrestrial climate, bioclimate and
#' vegetation for the last 120,000 years. Sci Data 7, 236 (2020).
#' \url{https://doi.org/10.1038/s41597-020-0552-1}
#'
#' The version included in `pastclim` has the icesheets masked, as well as
#' internal seas (Black and Caspian Sea) removed. The latter are based on:
#'
#' \url{https://www.marineregions.org/gazetteer.php?p=details&id=4278}
#'
#' \url{https://www.marineregions.org/gazetteer.php?p=details&id=4282}
#'
#' As there is no reconstruction of their depth throught time, modern outlines
#' were used for all time steps.
#'
#' Also, for bio15, the coefficient of variation was computed after adding one
#' to monthly estimates, and it was multiplied by 100 following
#' \url{https://pubs.usgs.gov/ds/691/ds691.pdf}
#'
#' @name Beyer2020
NULL
#> NULL


#' Documentation for the Krapp2021 dataset
#'
#' This dataset covers the last 800k years, at intervals of 1k years.
#'
#' This dataset can be downloaded with \code{\link{download_dataset}}. The
#' files can be found at
#'
#' Manica, Andrea (2022): pastclim_krapp2021_v1.0.0. figshare. Dataset.
#' \url{https://doi.org/10.6084/m9.figshare.19733680.v1}
#'
#' based on
#'
#' Krapp, M., Beyer, R.M., Edmundson, S.L. et al. A statistics-based
#' reconstruction of high-resolution global terrestrial climate for the last
#' 800,000 years. Sci Data 8, 228 (2021).
#' \url{https://doi.org/10.1038/s41597-021-01009-3}
#'
#' The version included in `pastclim` has the icesheets masked.
#'
#' Note that, for bio15, we use the corrected version, which follows
#' \url{https://pubs.usgs.gov/ds/691/ds691.pdf}
#'
#' @name Krapp2021
NULL
#> NULL