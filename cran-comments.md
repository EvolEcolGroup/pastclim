This is a resubmission

# Feedback on previous submission (with details of fixes)

You missed to add \value in some of your .Rd-files. Please also add it
there.
Missing Rd-tags:
      get_ice_mask.Rd: \value
      get_land_mask.Rd: \value
      get_mis_time_steps.Rd: \value
      get_time_steps.Rd: \value
      get_vars_for_dataset.Rd: \value
      
> All functions should now have a \value

Please do not modify the user's global environment or the user's home
filespace in your examples or vignettes by deleting objects with rm(list
= ls())
e.g.:  inst/rawdata_scripts/update_meta_data_of_vars_in_nc.R


> Those scripts were internal ones to generate the raw data for the package.
They have been moved outside inst, so that they are not exposed to the user.


## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)
- devtools::check_mac_release

On all testing environment (see below), I only get a note because of the
package being a new submission (expected), and a false positive for mispelling 
(palaeoclimate is an existing word and IS spelled correctly; the rest are parts
of the author list of the paper describing the package).

## R CMD check results
On all systems:

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Andrea Manica <am315@cam.ac.uk>’

New submission

Possibly misspelled words in DESCRIPTION:
  al (16:18)
  et (16:15)
  Leonardi (16:6)
  palaeoclimate (14:55)
  Palaeoclimate (3:34)

0 errors ✔ | 0 warnings ✔ | 1 notes ✖
