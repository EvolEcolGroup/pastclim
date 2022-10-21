testthat::test_that("get biome classes", {
  # check that we have 29 classes as expected
  expect_true(nrow(get_biome_classes("Example")) == 29)
})
