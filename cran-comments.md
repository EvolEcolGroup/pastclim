## Test environments
- Github Actions R-CMD-check (ubuntu-20.04): r-devel, r-release, r-oldrel
- Github Actions R-CMD-check (windows): r-release
- Github Actions R-CMD-check (macOS): r-release
- R-hub r-devel: linux, m1-san, macos, macos-arm64, windows
- devtools::check_win_devel

No NOTES on any environment.

## Checks on CRAN for previous version of pastclim
As detailed in:
https://cloud.r-project.org/web/checks/check_results_pastclim.html

recently the Windows builds started failing due to a time-out. This issues
was the result of changes in `terra::distance()`, which is now more accurate
but much slower, impacting the performance of our function `distance_from_sea()`. That
function was rewritten and the issue is now fixed.

## False positive in URL checks
urlcheck::url_check() gives a false positive for 

Error: README.md:19:9 403: Forbidden
(2023)](https://doi.org/10.1111/ecog.06481).

That link is the official DOI link for the paper describing our package. It redirects
to the publisher's website, giving the false positive.

## revdep_check
We have run `revdep_check()` and all reverse dependencies pass.