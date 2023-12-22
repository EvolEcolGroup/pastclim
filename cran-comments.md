## This is a re-submission
DOI incorrectly started with doi.org/; they have all now been fixed and raised
no issues with any check.

## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)
- devtools::check_mac_release

No NOTES on any environment.

## Checks on CRAN for previous version of pastclim
As detailed in:
https://cloud.r-project.org/web/checks/check_results_pastclim.html

there are failures with r-oldrel-macos-arm64 and r-oldrel-macos-x86-64. Old
versions on mac of `terra`, on which `pastclim` relies, were problematic. This
affected other packages as well: https://github.com/r-spatial/stars/issues/566
Pastclim works on r-oldrel-windows-x86-64, as well as on all other release and
devel versions.

There were notes on a r-devel, which picked up a man page where a parameter
was named incorrectly. That has been fixed in the current version.