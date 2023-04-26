# pastclim <img src="./man/figures/logo.png" align="right" alt="" width="150" />

<!-- badges: start -->
[![R-CMD-check master](https://img.shields.io/github/checks-status/EvolEcolGroup/pastclim/master?label=master&logo=GitHub)](https://github.com/EvolEcolGroup/pastclim/actions/workflows/R-CMD-check.yaml)
[![R-CMD-check dev](https://img.shields.io/github/checks-status/EvolEcolGroup/pastclim/dev?label=dev&logo=GitHub)](https://github.com/EvolEcolGroup/pastclim/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/EvolEcolGroup/pastclim/branch/master/graph/badge.svg?token=NflUsWlnQR)](https://app.codecov.io/gh/EvolEcolGroup/pastclim)
<!-- badges: end -->

<!-- old badges, kept for future reference
[![CircleCI](https://circleci.com/gh/EvolEcolGroup/pastclim/tree/master.svg?style=shield&circle-token=928bdbe8f065e17b22642f66a8b9c13f29f2e3fb)](https://app.circleci.com/pipelines/github/EvolEcolGroup/pastclim?branch=master)
[![R-CMD-check dev](https://github.com/EvolEcolGroup/pastclim/actions/workflows/R-CMD-check.yaml/badge.svg?branch=dev)](https://github.com/EvolEcolGroup/pastclim/actions/workflows/R-CMD-check.yaml)
-->

This `R` library is designed to provide an easy way to extract and manipulate palaeoclimate
reconstructions for ecological and anthropological analyses. 

The functionalities of `pastclim` are described in 
[Leonardi et al. (2023)](https://doi.org/10.1111/ecog.06481). Please cite it if you
use `pastclim` in your research.

## Install the library

`pastclim` is on CRAN, and the easiest way to install it is with:

```{r install_cran, eval=FALSE}
install.packages("pastclim")
```

If you want the latest development version, you can get it from GitHub.
To install from GitHub, you will need to use `devtools`; if you haven't
done so already, install it from CRAN with
`install.packages("devtools")`. Also, note that the `dev` version of
`pastclim` tracks changes in the `dev` version of `terra`, so you will
need to upgrade to both:

```{r install_dev, eval=FALSE}
install.packages('terra', repos='https://rspatial.r-universe.dev')
devtools::install_github("EvolEcolGroup/pastclim", ref="dev")
```

## Overview of functionality

On its dedicated [website](https://evolecolgroup.github.io/pastclim/), you can find
Articles giving you a step-by-step [overview of the package](https://evolecolgroup.github.io/pastclim/articles/a0_pastclim_overview.html),
and a [cheatsheet](https://evolecolgroup.github.io/pastclim/pastclim_cheatsheet.pdf).
There is also a
[version](https://evolecolgroup.github.io/pastclim/dev/) of the site
updated for the `dev` version (on the top left, the version number is in
red, and will be in the format x.x.x.9xxx, indicating it is a
development version).

Pastclim currently includes data from Beyer et al 2020, a reconstruction of climate 
based on the HadCM3 
model for the last 120k years, and Krapp et al 2021, which covers the last 800k years.
The reconstructions are bias-corrected and downscaled to 0.5 degree. More details on these datasets
can be found [here](https://evolecolgroup.github.io/pastclim/articles/a1_available_datasets.html).
There are also instructions on how to build and use [custom datasets](https://evolecolgroup.github.io/pastclim/articles/a2_custom_datasets.html).

You can also build the vignettes when installing 
`pastclim` (note that you will need to have the necessary tools to build vignettes already installed;
requirements depend on your OS):
```
devtools::install_github("EvolEcolGroup/pastclim", build_vignette = TRUE)
```
If you built the vignettes, you can read them directly in R. For example, the overview can be
obtained with:
```
vignette("pastclim_overview", package = "pastclim")
```

---

## Current issues

If something does not work, check the [issues on GitHub](https://github.com/EvolEcolGroup/pastclim/issues) to see whether the problem
has already been reported. If not, feel free to create an new issue. Please make sure you provide
[a reproducible example](https://stackoverflow.com/questions/5963269/how-to-make-a-great-r-reproducible-example) for the developers to investigate the problem.

---

### Error in x\$.self\$finalize()

`pastclim` relies on `terra` to process rasters. There is a known bug in
`terra` that leads to the occasional message: 
```
"Error in x$.self$finalize() : attempt to apply non-function"
```
This is an error related to garbage collection, which does not 
affect the script being correctly executed, so it can be ignored. More discussion
of this issue can be found on [stack**overflow**](https://stackoverflow.com/questions/61598340/why-does-rastertopoints-generate-an-error-on-first-call-but-not-second)

---

### `terra` without NETCDF driver for macOS

A number of versions of `terra` available as binaries for macOS X86-64 on CRAN (including the latest one) have
been compiled without a NETCDF driver (the latest ARM library is OK). This prevents `pastclim`, which relies on `terra`, from 
correctly reading files. Other packages that rely on `terra` are similarly 
affected (e.g. `stars`; see this [bug](https://github.com/r-spatial/stars/issues/566))

When loaded, `pastclim` checks if the driver is available; in case of
a missing driver, you will get the error:

```
Error: The installed version of terra lacks support for reading netcdf files.
pastclim needs netcdf support: you will need to reinstall terra,
possibly from source, if there isn't a version with netcdf support
on CRAN. Alternatively, try the latest development version from R-universe:
install.packages('terra', repos='https://rspatial.r-universe.dev')
```

The easiest solution is probably to install the `dev` version of `terra` from
[R-universe](https://r-universe.dev/organizations/) with:
```
install.packages('terra', repos='https://rspatial.r-universe.dev')
```

However, note that the `dev` version of `terra` is incompatible with the version
of `pastclim` on CRAN. Therefore, you need to also upgrade `pastclim` to `dev`:
```
devtools::install_github("EvolEcolGroup/pastclim", ref="dev")
```

Alternatively, if you want to install a specific version of 
 `terra` from source, see instructions [here](https://github.com/rspatial/terra).

---

### no slot of name "ptr" with `dev` version of `terra`

the `dev` version of `terra` is incompatible with the version
of `pastclim` on CRAN, leading to the following error.

```
Error in time_bp(climate_nc) : no slot of name "ptr" for this object of class "SpatRaster"
```

To solve this, you need to also upgrade `pastclim` to `dev`:
```
devtools::install_github("EvolEcolGroup/pastclim", ref="dev")
```
