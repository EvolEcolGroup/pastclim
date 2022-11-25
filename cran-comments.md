This is a new package not present on CRAN yet.

On all testing environment (see below), we only get a note because of the
package being a new submission, and a false positive for mispelling 
(paleoclimate is an existing word and is spelled correctly).

## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)
- devtools::check_mac_release

## R CMD check results
On all systems:

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Andrea Manica <am315@cam.ac.uk>’

New submission

Possibly misspelled words in DESCRIPTION:
  palaeoclimate (14:90)
  Palaeoclimate (3:34)

0 errors ✔ | 0 warnings ✔ | 1 notes ✖
