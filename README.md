# pastclim <img src="./man/figures/logo.png" align="right" alt="" width="150" />

<!-- badges: start -->
[![CircleCI](https://circleci.com/gh/EvolEcolGroup/pastclim/tree/master.svg?style=shield&circle-token=928bdbe8f065e17b22642f66a8b9c13f29f2e3fb)](https://circleci.com/gh/EvolEcolGroup/pastclim/tree/master)
[![codecov](https://codecov.io/gh/EvolEcolGroup/pastclim/branch/master/graph/badge.svg?token=NflUsWlnQR)](https://codecov.io/gh/EvolEcolGroup/pastclim)
<!-- badges: end -->

<!---
comment out the githubactions as they can't cope with downgrading terra
[![R-CMD-check](https://github.com/EvolEcolGroup/pastclim/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/EvolEcolGroup/pastclim/actions/workflows/R-CMD-check.yaml)
--->

This library is designed to provide an easy way to extract and manipulate paleoclimate
reconstructions for ecological and anthropological analyses. It currently includes
data from Beyer et al 2020, a reconstruction of climate based on the HadCM3 
model for the last 120k years, and Krapp et al 2021, which covers the last 800k years.
The reconstructions are bias-corrected and downscaled to 0.5 degree. A vignette, which
can be found on the website under Articles, illustrates how additional dataset
can be read with pastclim (if you format a new dataset, please consider a pull request
to make it available to others!).

A paper
describing the functionality of `pastclim` can be found on [bioRxiv](https://www.biorxiv.org/content/10.1101/2022.05.18.492456v1).

There is a [website](https://evolecolgroup.github.io/pastclim/) associated to the library displaying different vignettes ([pastclim overview](https://evolecolgroup.github.io/pastclim/dev/articles/a0_pastclim_overview.html), [custom dataset](https://evolecolgroup.github.io/pastclim/articles/a2_custom_datasets.html)) and a [cheatsheet](https://evolecolgroup.github.io/pastclim/pastclim_cheatsheet.pdf). A list of available palaeoclimatic datasets can be found [here](https://evolecolgroup.github.io/pastclim/articles/a1_available_datasets.html).

## Install the library

You will need to install the library from Github. For this step, you will need to
use `devtools` (if you haven't done so already, install it from CRAN with `install.packages("devtools")`.
Once you have `devtools`, simply use:
```
devtools::install_github("EvolEcolGroup/pastclim")
```
---

### IMPORTANT: terra version

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

## Overview of functionality

There is a vignette with detailed step by step examples on how to use the library, as
well as a cheatsheet covering the key functions. You can
find them in the article and cheatsheet sections of the `pastclim` website. There are
also additional articles providing details of datasets available within `pastclim`,
and instructions on how to format and use custom datasets.

You can also build the vignettes when installing 
`pastclim` (note that you will need to have the necessary tools to build vignettes already installed;
requirements depend on your OS):
```
devtools::install_github("EvolEcolGroup/pastclim", build_vignette = TRUE)
```
You can read the vignettes directly in R with:
```
vignette("pastclim_overview", package = "pastclim")
```

---

## Current issues

If something does not work, check the [issues on Github] (https://github.com/EvolEcolGroup/pastclim/issues) to see whether the problem
has already been reported. If not, feel free to create an new issue. Please make sure you provide
[a reproducible example] (https://stackoverflow.com/questions/5963269/how-to-make-a-great-r-reproducible-example) for the developers to investigate the issue.

NOTE: `pastclim` relies on `terra` to process rasters. There is a known bug in
`terra` that leads to the occasional message: 
```
"Error in x$.self$finalize() : attempt to apply non-function"
```
This is an error related to garbage collection, which does not 
affect the script being correctly executed, so it can be ignored. More discussion
of this issue can be found on [stack**overflow**](https://stackoverflow.com/questions/61598340/why-does-rastertopoints-generate-an-error-on-first-call-but-not-second)
