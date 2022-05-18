testthat::test_that("get biome classes", {
  path_to_example_nc <- system.file("/extdata/", package = "pastclim")
  # check that we have 29 classes as expected
  expect_true(nrow(get_biome_classes("Example",
    path_to_nc = path_to_example_nc
  )) == 29)
  # give error if we do the same but give the wrong path
  expect_error(
    get_biome_classes("Example",
      path_to_nc = "/foo"
    ), "^variable"
  )
})
