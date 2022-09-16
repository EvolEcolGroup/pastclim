# pastclim <img src="./man/figures/logo.png" align="right" alt="" width="150" />

<!-- badges: start -->
[![CircleCI](https://circleci.com/gh/EvolEcolGroup/pastclim/tree/master.svg?style=shield&circle-token=928bdbe8f065e17b22642f66a8b9c13f29f2e3fb)](https://circleci.com/gh/EvolEcolGroup/pastclim/tree/master)
[![codecov](https://codecov.io/gh/EvolEcolGroup/pastclim/branch/master/graph/badge.svg?token=NflUsWlnQR)](https://codecov.io/gh/EvolEcolGroup/pastclim)
<!-- badges: end -->

This library is designed to provide an easy way to extract and manipulate paleoclimate
reconstructions for ecological and anthropological analyses. It currently focuses
on data from Beyer et al 2020, a reconstruction of climate based on the HadCM3 
model for the last 120k years, and Krapp et al 2021, which covers the last 800k years.
The reconstructions are bias-corrected and downscaled to 0.5 degree. A paper
describing the functionality of `pastclim` can be found on [bioRxiv](https://www.biorxiv.org/content/10.1101/2022.05.18.492456v1).

## Install the library

You will need to install the library from Github. For this step, you will need to
use `devtools` (if you haven't done so already, install it from CRAN with `install.packages("devtools")`.
Once you have `devtools`, simply use:
```
devtools::install_github("EvolEcolGroup/pastclim")
```
---

## IMPORTANT: terra version

The latest version of `terra` on CRAN (1.6.17) has a bug which prevents correct sampling of `spatRasters`. For
a fully functional `pastclim`, you need to downgrade your version to 1.6.7:

```
devtools::install_version("terra", version="1.6.7")
```

This fix will work for Linux and Windows, but it turns out that for OSX, `terra` version 1.6.7 on CRAN is built
without support for reading netcdf files. So, if you are on OSX, you need to further downgrade `terra` to version
1.6.3:

```
devtools::install_version("terra", version="1.6.3")
```

The issue has been fixed in the development version of `terra`.

---

There is a vignette with detailed step by step examples on how to use the library. You can
find it in the [article section of the `pastclim` website](https://evolecolgroup.github.io/pastclim/articles/pastclim_overview.html). Or, you can build it when installing
`pastclim` :
```
devtools::install_github("EvolEcolGroup/pastclim", build_vignette = TRUE)
```
And read it directly in R with:
```
vignette("pastclim_overview",package="pastclim")
```
The vignette also provides instructions on how to install the optional
companion package `pastclimData`, which simplifies the task of downloading and 
storing the climate simulations.

---

NOTE: `pastclim` relies on `terra` to process rasters. There is a known bug in
`terra` that leads to the occasional message: 
```
"Error in x$.self$finalize() : attempt to apply non-function"
```
This is an error related to garbage collection, which does not 
affect the script being correctly executed, so it can be ignored. More discussion
of this issue can be found on [stack**overflow**](https://stackoverflow.com/questions/61598340/why-does-rastertopoints-generate-an-error-on-first-call-but-not-second)
