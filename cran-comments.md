This is a resubmission

# Feedback on previous submission (with details of fixes)

Please do not start the description with "This package", package name,
title or similar.

> Description changed as requested.

If there are references describing the methods in your package, please
add these in the description field of your DESCRIPTION file in the form
authors (year) <doi:...>
authors (year) <arXiv:...>
authors (year, ISBN:...)
or if those are not available: <https:...>
with no space after 'doi:', 'arXiv:', 'https:' and angle brackets for
auto-linking. (If you want to add a title as well please put it in
quotes: "Title")

> Reference added as suggested.

Please add \value to .Rd files regarding exported methods and explain
the functions results in the documentation. Please write about the
structure of the output (class) and also what the output means. (If a
function does not return a value, please document that too, e.g.
\value{No return value, called for side effects} or similar)
Missing Rd-tags in up to 26 .Rd files, e.g.:
      check_dataset_path.Rd: \value
      climate_for_locations.Rd: \value
      climate_for_time_slice.Rd: \value
      df_from_region_series.Rd: \value
      df_from_region_slice.Rd: \value
      download_dataset.Rd: \value
      ...

> My apologies, I relied on devtools::check() to test the documentation, 
I see now that it fails to check returns. All functions now should have a
return value in their documentation.

Please ensure that your functions do not write by default or in your
examples/vignettes/tests in the user's home filespace (including the
package directory and getwd()). This is not allowed by CRAN policies.
Please omit any default path in writing functions. In your
examples/vignettes/tests you can write to tempdir(). ->
R/set_data_path.R and corresponding tests

> Functions changed to ensure that no files are written to the user's home
filespace (sorry, I had misread the note about R_user_dir on CRAN).


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
