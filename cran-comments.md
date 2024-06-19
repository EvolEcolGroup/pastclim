## This is a resubmission
The previous submission raised:
Check: Rd cross-references, Result: NOTE
   Found the following Rd file(s) with Rd \link{} targets missing package
   anchors:
     location_slice_from_region_series.Rd: SpatRasterDataset
     slice_region_series.Rd: SpatRaster
   Please provide package anchors for all Rd \link{} targets not in the
   package itself and the base packages.
   
Those links have now been fixed ith teh appropriate package anchor

## Test environments
- R-hub linux (r-devel)
- R-hub macos (r-devel)
- R-hub macos-arm64 (r-devel)
- devtools::check_mac_release
- devtools::check_win_devel

No NOTES on any environment.

## Checks on CRAN for previous version of pastclim
As detailed in:
https://cloud.r-project.org/web/checks/check_results_pastclim.html

there are no failures on the previous version (2.0.0)