# Code review of pastclim, October 2026

This report lists the fixes made during a full review of the R code in
pastclim, with one commit per fix on the
[`codereview`](https://github.com/EvolEcolGroup/pastclim/tree/codereview)
branch, rebased on `dev` (`bdf8eb0`, "Barreto zenodo (#90)").

**How to use this checklist:** tick a box (`[ ]` → `[x]`) once you have
reviewed that fix and are happy with it. If you paste this file into a PR
description or an issue, GitHub makes the boxes clickable. The commit hashes
are those on `codereview` when this report was written; if the branch is
rebased again, look for the commit subject instead.

## How each change was verified

- Every fix comes with a test that **fails on the parent commit and passes
  with the fix**. This check was run on each commit after the rebase on `dev`.
- The full test suite passes on the branch with terra 1.9-50 (the current
  release) and with terra 1.8-93 (the new minimum). The only skipped tests are
  the 8 that need the network or `PASTCLIM_TEST`, which are also skipped on
  `dev`.
- `lintr::lint_package()` (lintr 3.4.0) reports no lints, the same as `dev`.
- Environment: R 4.3.3 on Ubuntu 24.04, GDAL 3.8.4. terra, Rcpp and lintr
  were built from their GitHub release tags.
- The download tests do not use the network: they replace
  `curl::curl_download()` / `curl::multi_download()` with local fakes
  (`testthat::local_mocked_bindings()`) that write small rasters or zip files.

## Fixes

### Locations (`location_slice()`, `location_series()`, `location_slice_from_region_series()`)

- [ ] **F1. NAs in unrelated columns of `x` trigger interpolation**
  ([`991261b`](https://github.com/EvolEcolGroup/pastclim/commit/991261b))
  - **Problem:** with `nn_interpol` or `buffer`, the locations to interpolate
    were chosen with `complete.cases()` on the whole data.frame, so an NA in
    any user column (e.g. a notes column) replaced valid values at those
    locations with the mean of the neighbouring cells.
  - **Fix:** only check the climate variables.
  - **File:** `R/location_slice_from_region_series_fast.R`
  - **Test:** "NAs in other columns do not trigger nn_interpol"

- [ ] **F2. Vectors of cell numbers fail**
  ([`61c8d9d`](https://github.com/EvolEcolGroup/pastclim/commit/61c8d9d))
  - **Problem:** the docs allow `x` to be a vector of cell numbers, but
    extraction used `locations_data[coords]`. `coords` is NULL in that case,
    so `terra::extract()` failed. Integer vectors were not accepted at all.
  - **Fix:** terra cannot extract by cell number when `layer` is used, so the
    cell numbers are converted to coordinates once and used both for
    extraction and for finding neighbours. Integer vectors are accepted, and
    any other type of `x` now gives a clear error.
  - **File:** `R/location_slice_from_region_series_fast.R`
  - **Test:** "location_slice_from_region_series works with cell numbers"
    (results must match those obtained with coordinates)

### Region series and classifications

- [ ] **F3. `sample_region_series()` fails with a single time step**
  ([`8da509c`](https://github.com/EvolEcolGroup/pastclim/commit/8da509c))
  - **Problem:** with one time step and a fixed `size`, subsetting the
    `spatSample()` output dropped to a vector and `colnames<-` failed.
  - **Fix:** subset with `drop = FALSE`.
  - **File:** `R/sample_region_series.R`
  - **Test:** "sample_region_series works with a single time step"

- [ ] **F4. `koeppen_geiger()` fails when only one row (or raster cell) has data**
  ([`25e556f`](https://github.com/EvolEcolGroup/pastclim/commit/25e556f))
  - **Problem:** the matrix method stopped with "only one valid row of data".
    The SpatRaster method processes rasters in blocks, so any block with
    exactly one land cell (a small island, a tiny raster) made the whole
    call fail.
  - **Fix:** subset with `drop = FALSE`, so one row (or none) is handled like
    any other input.
  - **File:** `R/koeppen_geiger.R`
  - **Test:** "koeppen geiger works with a single valid row": each single row
    must give the same class as the full matrix, plus a 2x2 raster with one
    valid cell. **Note:** this removes the existing expectation of the "only
    one valid row" error from "koeppen geiger for numeric and matrix".

- [ ] **F5. Invalid region series are not rejected by `bioclim_vars()` / `koeppen_geiger()`**
  ([`245ee64`](https://github.com/EvolEcolGroup/pastclim/commit/245ee64))
  - **Problem:** the SpatRasterDataset methods built the error message but
    never called `stop()`, so the check did nothing and users got a less
    helpful error later.
  - **Fix:** call `stop()`.
  - **Files:** `R/bioclim_vars.R`, `R/koeppen_geiger.R`
  - **Tests:** new file `test_bioclim_vars.R`, the first tests for
    `bioclim_vars()` (numeric, matrix, SpatRaster, SpatRasterDataset, and
    invalid series).

- [ ] **F6. `koeppen_geiger()` on region series ignores `broad` and `class_names`**
  ([`a9924f4`](https://github.com/EvolEcolGroup/pastclim/commit/a9924f4))
  - **Problem:** the SpatRasterDataset method called the SpatRaster method
    without them, so it always returned the detailed classification with
    class codes.
  - **Fix:** pass both arguments through.
  - **File:** `R/koeppen_geiger.R`
  - **Test:** "koeppen geiger for SpatRasterDataset uses broad and
    class_names": each combination must match the SpatRaster method.

- [ ] **F7. `delta_downscale()` fails without a high resolution landmask**
  ([`a0026ff`](https://github.com/EvolEcolGroup/pastclim/commit/a0026ff))
  - **Problem:** `x_landmask_high` defaults to NULL but was always passed to
    `terra::resample()`, which fails on NULL.
  - **Fix:** only resample it when it is given.
  - **File:** `R/delta_downscale.R`
  - **Test:** "delta_downscale works without a high resolution landmask"
    (also checks `range_limits`)

- [ ] **F8. `delta_downscale()` only fills gaps in the first time step**
  ([`e916a5e`](https://github.com/EvolEcolGroup/pastclim/commit/e916a5e))
  - **Problem:** the gap-filling loop used `seq_along(nlyr(x_high))`, i.e.
    `1`, so the other time steps kept NA cells wherever the high resolution
    landmask extends beyond the original one.
  - **Fix:** `seq_len(nlyr(x_high))`.
  - **File:** `R/delta_downscale.R`
  - **Test:** "delta_downscale fills gaps in every layer" (new file
    `test_delta_downscale.R`; there were no tests for `delta_downscale()`)

- [ ] **F9. `region_series()` rejects integer extents**
  ([`f3bb578`](https://github.com/EvolEcolGroup/pastclim/commit/f3bb578))
  - **Problem:** `inherits(ext, "numeric")` is FALSE for integer vectors, so
    e.g. `ext = c(-10L, 15L, 45L, 60L)` was rejected.
  - **Fix:** `is.numeric()`.
  - **File:** `R/region_series.R`
  - **Test:** added to "ext on region series"

- [ ] **F10. Misleading error for ambiguous coordinate columns**
  ([`dc48db9`](https://github.com/EvolEcolGroup/pastclim/commit/dc48db9))
  - **Problem:** a data.frame with both `x`/`y` and `longitude`/`latitude`
    gave "There are no recognised coordinate columns".
  - **Fix:** name the competing pairs and ask the user to choose with
    `coords`.
  - **File:** `R/check_coords_names.R`
  - **Tests:** new file `test_check_coords_names.R`

### Datasets and downloads

- [ ] **F11. `update_dataset_list()` never installs or uses a newer list**
  ([`faa2980`](https://github.com/EvolEcolGroup/pastclim/commit/faa2980))
  - **Problem:** when a newer list was found, a data.frame (not a file path)
    was passed to `file.copy()`, which failed. The reloaded list was then
    discarded, so the session kept the old one.
  - **Fix:** copy the downloaded file into the config directory (creating it
    if needed) and update `options(pastclim.dataset_list)`. The download goes
    to a unique temp file, so with `on_cran = TRUE` the source and
    destination are not the same file.
  - **File:** `R/update_dataset_list.R`
  - **Test:** "update_dataset_list installs a newer list" (fake download of a
    list with version 99.0.0)

- [ ] **F12. `get_time_bp_steps()` / `get_resolution()` ignore an updated dataset list**
  ([`0406d5d`](https://github.com/EvolEcolGroup/pastclim/commit/0406d5d))
  - **Problem:** both looked up file names in the list bundled with the
    package rather than in `getOption("pastclim.dataset_list")`, which every
    other function uses. Datasets added by an updated list could be
    downloaded but not queried.
  - **Fix:** use the option.
  - **Files:** `R/get_time_steps.R`, `R/get_res.R`
  - **Test:** "get_time_bp_steps and get_resolution use the current dataset
    list"

- [ ] **F13. Wrong file names for monthly WorldClim future variables**
  ([`52bb4c4`](https://github.com/EvolEcolGroup/pastclim/commit/52bb4c4))
  - **Problem:** the band names were built from the last two characters of
    the variable (the month) instead of its prefix, so `precipitation_06`
    produced `..._0601_...` to `..._0612_...`, and the expected vrt files
    never appeared. The final check looked at the last vrt written rather
    than the requested file, so this failed silently.
  - **Fix:** use the same prefix logic as `download_worldclim_present()`, and
    check for `filename`.
  - **File:** `R/download_worldclim_future.R`
  - **Test:** "download_worldclim_future creates correctly named vrt files"
    (new file; checks that the vrts can be read with the right band and
    times)

- [ ] **F14. The check for missing files in WorldClim present archives never fails**
  ([`fd6af52`](https://github.com/EvolEcolGroup/pastclim/commit/fd6af52))
  - **Problem:** a misplaced bracket made it
    `all(seq_len(length(band_vector) %in% ids))`, which is always TRUE. An
    incomplete archive then failed inside GDAL after some vrts had been
    written.
  - **Fix:** `all(seq_along(band_vector) %in% ids)`.
  - **File:** `R/download_worldclim_present.R`
  - **Tests:** new file `test_download_worldclim_present.R` (complete and
    incomplete fake archives)

- [ ] **F15. PaleoClim download failures are ignored**
  ([`702b928`](https://github.com/EvolEcolGroup/pastclim/commit/702b928))
  - **Problem:** the result of `curl::multi_download()` was never checked, so
    a failed download surfaced later as an obscure GDAL error.
  - **Fix:** stop with a clear message, as the other download functions do.
  - **File:** `R/download_paleoclim.R`
  - **Test:** "download_paleoclim stops if the download fails"

- [ ] **F16. `download_dataset()` names the wrong variables in its error**
  ([`2c1855b`](https://github.com/EvolEcolGroup/pastclim/commit/2c1855b))
  - **Problem:** requested variables were compared against the list of
    *datasets*, so the error named every requested variable (valid ones too),
    repeated once per variable.
  - **Fix:** compare against the available variables and report them once.
  - **File:** `R/download_dataset.R`
  - **Test:** added to "download_dataset"

- [ ] **F17. `download_etopo_subset()` resolution check crashes**
  ([`befaf67`](https://github.com/EvolEcolGroup/pastclim/commit/befaf67))
  - **Problem:** `!all.equal(a, b)` errors with "invalid argument type" when
    the values differ, because `all.equal()` returns a string.
  - **Fix:** `isTRUE(all.equal())`. The template is now checked before
    looking for marmap, so bad input is reported either way.
  - **File:** `R/download_etopo_subset.R`
  - **Test:** new file `test_download_etopo_subset.R`

- [ ] **F18. `get_vars_for_dataset(details = TRUE)` leaves the nc file open**
  ([`28f52b3`](https://github.com/EvolEcolGroup/pastclim/commit/28f52b3))
  - **Problem:** for custom datasets, the `details` branch never called
    `nc_close()`, leaking a file handle on every call (and keeping the file
    locked on Windows).
  - **Fix:** close it with `on.exit()`.
  - **File:** `R/get_vars_for_dataset.R`
  - **Test:** "get_vars_for_dataset closes the nc file for custom datasets"
    (checks `/proc/self/fd`, so it is skipped on systems without it)

## Regression tests for bugs already fixed on `dev`

These bugs were found on `main` and are already fixed by the rewrite of
`location_slice_from_region_series()` on `dev`. The commits only add tests.

- [ ] **T1. `buffer = TRUE` keeps names, coordinates and times**
  ([`4ac41ec`](https://github.com/EvolEcolGroup/pastclim/commit/4ac41ec))
  - On `main`, whole rows were reset to NA before the buffer means were
    computed.
  - **Test:** "buffer keeps coordinates, names and times" (`time_bp` and
    `time_ce` input)

- [ ] **T2. `biome` stays categorical, and the numeric variables stay numeric, with `nn_interpol` / `buffer`**
  ([`aecaba3`](https://github.com/EvolEcolGroup/pastclim/commit/aecaba3))
  - On `main`, interpolating with `biome` turned all the climate variables
    into character columns.
  - **Test:** "nn_interpol with biome keeps numeric variables numeric": biome
    is a factor, and the numeric values must not depend on whether biome is
    extracted.

## Package requirements

- [ ] **R1. terra >= 1.8-93**
  ([`95a718f`](https://github.com/EvolEcolGroup/pastclim/commit/95a718f))
  - `DESCRIPTION` said `terra (>= 1.7.18)`, but the location functions on
    `dev` rely on `terra::extract()` with `layer` on a SpatRasterDataset,
    including for categorical layers. Results of the `location_*` tests
    with terra releases (built from the cran/terra mirror, bisecting between
    1.7-65 and 1.9-50):

    | terra | `location_*` tests |
    |---|---|
    | 1.7-65 (Ubuntu 24.04) | wrong values and errors |
    | 1.8-42, 1.8-60, 1.8-80, 1.8-86 | `biome` is NA after `nn_interpol` |
    | 1.8-54 | error "layer should be between 1 and nlyr(x)" |
    | 1.8-93, 1.9-1, 1.9-50 | pass |

    `dev` itself (without this branch) fails its location tests with 1.8-86
    and passes them with 1.8-93. The full test suite was run with 1.8-93 and
    1.9-50.

- [ ] **R2. testthat >= 3.1.7 in Suggests**
  ([`f869bc6`](https://github.com/EvolEcolGroup/pastclim/commit/f869bc6))
  - The download tests use `testthat::local_mocked_bindings()`, which first
    appeared in testthat 3.1.7. The same commit adds the NEWS entries for the
    fixes above.

## Issues found but not changed (decisions for the maintainers)

- [ ] **Q1. `buffer` excludes the focal cell.** `terra::adjacent()` is
  called with its default `include = FALSE`, so the buffer mean covers only
  the neighbours. The docs ("the mean of a buffer around the focal cell")
  could be read either way, and the existing tests are written around the
  current behaviour.
- [ ] **Q2. Ties in the modal biome are broken arbitrarily.** When the
  neighbours are split evenly between biomes, `mode()` returns the first one
  in cell order.
- [ ] **Q3. `bathy_to_spatraster()` is shifted by half a cell.** The extent
  is built from cell centres (`min(lon)`, `max(lon)`, ...).
  `download_etopo_subset()` resamples to the template afterwards, which hides
  this.
- [ ] **Q4. `get_biome_classes()` only handles Beyer2020, Example and
  Krapp2021**, and fails with an unhelpful error for other datasets.
- [ ] **Q5. `get_ice_mask()` has no `time_ce` argument**, unlike
  `get_land_mask()`.
- [ ] **Q6. The resolution-matching (`disagg`) step in `delta_downscale()`
  never runs**, because `x` has already been resampled to the grid of
  `delta_rast`.
