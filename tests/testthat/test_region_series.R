# set up data path for this test
data_path <- file.path(tempdir(), "pastclim_data")
# it should not exist, but remove it just in case
unlink(data_path, recursive = TRUE)
# set data path
set_data_path(
  path_to_nc = data_path,
  ask = FALSE,
  write_config = FALSE,
  copy_example = TRUE
)
################################################################################

test_that("region series", {
  # using standard dataset
  climate_region <- region_series(
    time_bp = c(-20000, -10000), bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  expect_true(inherits(climate_region, "SpatRasterDataset"))
  expect_true(all(names(climate_region) == c("bio01", "bio12")))
  expect_true(all(terra::nlyr(climate_region) == c(2, 2)))

  # do the same for a custom dataset
  example_filename <- getOption("pastclim.dataset_list")$file_name[
    getOption("pastclim.dataset_list")$dataset == "Example"
  ][1] # nolint
  path_to_example_nc <- system.file("/extdata/", example_filename,
    package = "pastclim"
  )
  climate_region <- region_series(
    time_bp = c(-20000, -10000),
    bio_variables = c("BIO1", "BIO10"),
    dataset = "custom",
    path_to_nc = path_to_example_nc
  )
  expect_true(inherits(climate_region, "SpatRasterDataset"))
  expect_true(all(names(climate_region) == c("BIO1", "BIO10")))

  # now test biome for a custom dataset
  biome_region <- region_series(
    time_bp = c(-20000, -10000),
    bio_variables = c("biome"),
    dataset = "custom",
    path_to_nc = path_to_example_nc
  )
  # check that the biome is a categorical variable
  expect_true(inherits(biome_region, "SpatRasterDataset"))
  expect_true(!is.null(cats(biome_region$biome[[1]])[[1]]))

  # if we try to use a variable that does not exist
  expect_error(
    region_series(
      time_bp = c(-20000, -10000),
      bio_variables = c("bio01", "bio19"),
      dataset = "Example"
    ),
    "bio19 not available"
  )
  expect_error(
    region_series(
      time_bp = c(-20000, -10000),
      bio_variables = c("BIO1", "bio19"),
      dataset = "custom",
      path_to_nc = path_to_example_nc
    ),
    "variable \\(bio19\\) not"
  )

  # if we try to use a variable that we have not downloaded yet
  expect_error(
    region_series(
      time_bp = c(-20000, -10000),
      bio_variables = c("bio01", "bio19"),
      dataset = "Krapp2021"
    ),
    "^variable \\(bio01, bio19\\) not yet downloaded"
  )

  # if we try to use a file that does not exist
  expect_error(region_series(
    time_bp = c(-20000, -10000),
    bio_variables = c("BIO1", "BIO12"),
    dataset = "custom",
    path_to_nc = "./foo"
  ), "path_to_nc does not point to a file")

  # if we use time steps that do not exist
  expect_error(
    region_series(
      time_bp = c(-19000, -10000),
      bio_variables = c("bio01", "bio12"),
      dataset = "Example"
    ),
    "time_bp should only include time steps available in the dataset"
  )

  # get all values
  climate_region <- region_series(
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  expect_true(all(terra::nlyr(climate_region) == c(5, 5)))

  # get all values
  climate_region <- region_series(
    time_bp = list(min = -13000, max = 0),
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  expect_true(all(terra::nlyr(climate_region) == c(3, 3)))
})

test_that("ext on region series", {
  # this should work
  expect_error(region_series(
    time_bp = -20000,
    bio_variables = c("bio01", "bio10", "bio12"),
    dataset = "Example",
    ext = terra::ext(region_extent$Europe)
  ), NA)

  # this should raise an error
  expect_error(region_series(
    time_bp = -20000,
    bio_variables = c("bio01", "bio10", "bio12"),
    dataset = "Example",
    ext = "foo"
  ), "ext should be a ")

  # not enough elements
  ext <- c(-15, 70, 33)
  expect_error(region_series(
    time_bp = -20000,
    bio_variables = c("bio01", "bio10", "bio12"),
    dataset = "Example",
    ext = ext
  ), "ext should be a ")

  # but this works as it is long enough
  ext <- c(-15, 70, 33, 75)
  expect_error(region_series(
    time_bp = -20000,
    bio_variables = c("bio01", "bio10", "bio12"),
    dataset = "Example",
    ext = ext
  ), NA)
})
test_that("crop on region series", {
  # this should work
  expect_error(region_series(
    time_bp = -20000,
    bio_variables = c("bio01", "bio10", "bio12"),
    dataset = "Example",
    crop = terra::vect(region_outline$Eurasia)
  ), NA)

  # this should raise an error
  expect_error(region_series(
    time_bp = -20000,
    bio_variables = c("bio01", "bio10", "bio12"),
    dataset = "Example",
    crop = "foo"
  ), "crop should be a ")

  # this should work
  expect_error(region_series(
    time_bp = -20000,
    bio_variables = c("bio01", "bio10", "bio12"),
    dataset = "Example",
    crop = region_outline$Eurasia
  ), NA)
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
