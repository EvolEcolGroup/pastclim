## This is a minor release
It provides access to more paleoclimatic datasets, without major changes in
functionality.

## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub linux (r-devel)
- R-hub macos (r-devel)
- R-hub macos-arm64 (r-devel)
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