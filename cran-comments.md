## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)
- devtools::check_mac_release

On all testing environment (see below), I only get a note because a DOI from
a Wiley publication which is flagged as possibly invalid. The DOI is valid,
but the Wiley server turns down automatic requests (as discussed here https://hypatia.math.ethz.ch/pipermail/r-package-devel/2022q2/008043.html)

## R CMD check results
On all systems:

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Andrea Manica <am315@cam.ac.uk>’

  Found the following (possibly) invalid URLs:
    URL: https://doi.org/10.1111/ecog.06481
      From: man/pastclim.Rd
            README.md
      Status: 403
      Message: Forbidden

0 errors ✔ | 0 warnings ✔ | 1 notes ✖
