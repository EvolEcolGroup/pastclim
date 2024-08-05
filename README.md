# pastclim <img src="./man/figures/logo.png" align="right" width="150"/>

<!-- badges: start -->

[![R-CMD-check master](https://img.shields.io/github/checks-status/EvolEcolGroup/pastclim/master?label=master&logo=GitHub)](https://github.com/EvolEcolGroup/pastclim/actions/workflows/R-CMD-check.yaml)
[![R-CMD-check dev](https://img.shields.io/github/checks-status/EvolEcolGroup/pastclim/dev?label=dev&logo=GitHub)](https://github.com/EvolEcolGroup/pastclim/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/EvolEcolGroup/pastclim/branch/master/graph/badge.svg?token=NflUsWlnQR)](https://app.codecov.io/gh/EvolEcolGroup/pastclim)
[![CRAN status](https://www.r-pkg.org/badges/version/pastclim)](https://CRAN.R-project.org/package=pastclim)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/grand-total/pastclim)](https://github.com/r-hub/cranlogs.app)

<!-- badges: end -->

This `R` library is designed to provide an easy way to extract and
manipulate palaeoclimate reconstructions for ecological and
anthropological analyses. It is also able to handle time series of future
reconstructions.

The functionalities of `pastclim` are described in [Leonardi et al.
(2023)](https://doi.org/10.1111/ecog.06481). Please cite it if you use
`pastclim` in your research.

## Install the library

`pastclim` is on CRAN, and the easiest way to install it is with:

```         
install.packages("pastclim")
```

The version on CRAN is recommended for every day use. New features and
bug fixes appear first on the `dev` branch on GitHub, before they make
their way to CRAN. If you need to have early access to these new
features, you can install the development version of `pastclim` directly 
from GitHub, using `devtools`, or more simply get a compiled version
from r-universe. Also,
note that the `dev` version of `pastclim` tracks changes in the `dev`
version of `terra`, so you will need to upgrade both libraries with:

```         
install.packages('terra', repos='https://rspatial.r-universe.dev')
install.packages("pastclim", repos = c("https://evolecolgroup.r-universe.dev")
```

## Overview of functionality

On its dedicated [website](https://evolecolgroup.github.io/pastclim/),
you can find Articles giving you a step-by-step [overview of the
package](https://evolecolgroup.github.io/pastclim/articles/a0_pastclim_overview.html),
and a
[cheatsheet](https://evolecolgroup.github.io/pastclim/pastclim_cheatsheet.pdf).
There is also a [dev
version](https://evolecolgroup.github.io/pastclim/dev/) of the site
updated for the `dev` branch of `pastclim` (on the top left of the dev
website, the version number is in red and in the format x.x.x.9xxx,
indicating it is a development version).

`pastclim` currently includes data from Beyer et al 2020 (a reconstruction
of climate based on the HadCM3 model for the last 120k years), Krapp
et al 2021 (which covers the last 800k years with a statistical emulator of HadCM3),
Barreto et al 2023 (covering the last 5M years using the PALEO-PGEM emulator), PaleoClim 
(providing a few time steps from different palaeoclimate models downscaled to higher 
resolution), CHELSA-Trace21K (a transient
reconstruction of the last 21k years, downscaled to 1km resolution), the HYDE3.3 
database of land use reconstructions for the last 10k years,
and the WorldClim and CHELSA data (present, and future projections with a number of models and 
emission scenarios). More details on each of these
datasets can be found
[here](https://evolecolgroup.github.io/pastclim/articles/a1_available_datasets.html).
There are also instructions on how to build and use [custom
datasets](https://evolecolgroup.github.io/pastclim/articles/a2_custom_datasets.html).

------------------------------------------------------------------------

## When something does not work

If something does not work, check the [issues on
GitHub](https://github.com/EvolEcolGroup/pastclim/issues) to see whether
the problem has already been reported. If not, feel free to create an
new issue. Please make sure you have updated to the latest development version of
`pastclim` (as the bug might have already been fixed), as well as updating all other packages on your
system, and provide [a reproducible
example](https://reprex.tidyverse.org/)
for the developers to investigate the problem.

