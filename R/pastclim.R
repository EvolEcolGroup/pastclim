#' pastclim
#'
#' This `R` library is designed to provide an easy way to extract and manipulate palaeoclimate
#' reconstructions for ecological and anthropological analyses.
#' 
#' The functionalities of `pastclim` are described in 
#'  Leonardi et al. (2023) \doi{10.1111/ecog.06481}. Please cite it if you
#' use `pastclim` in your research.
#' 
#' On its dedicated [website](https://evolecolgroup.github.io/pastclim/), you can find
#' Articles giving you a step-by-step [overview of the package](https://evolecolgroup.github.io/pastclim/articles/a0_pastclim_overview.html),
#' and a [cheatsheet](https://evolecolgroup.github.io/pastclim/pastclim_cheatsheet.pdf).
#' There is also a
#' [version](https://evolecolgroup.github.io/pastclim/dev/) of the site
#' updated for the `dev` version (on the top left, the version number is in
#'                                red, and will be in the format x.x.x.9xxx, indicating it is a
#'                                development version).
#' 
#' `pastclim` currently includes data from Beyer et al 2020, a reconstruction of climate 
#' based on the HadCM3 
#' model for the last 120k years, and Krapp et al 2021, which covers the last 800k years.
#' The reconstructions are bias-corrected and downscaled to 0.5 degree. More details on these datasets
#' can be found [here](https://evolecolgroup.github.io/pastclim/articles/a1_available_datasets.html).
#' There are also instructions on how to build and use [custom datasets](https://evolecolgroup.github.io/pastclim/articles/a2_custom_datasets.html).
#'
#' @docType package
#' @name pastclim
#' @import methods
#' @import terra
NULL
