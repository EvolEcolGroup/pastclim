region_extent <- list(
  Africa = c(-19, 61, -36, 38),
  America = c(-180, -15, -70, 90),
  Asia = c(60, 180, 5, 85),
  Europe = c(-15, 70, 33, 75),
  Eurasia = c(-15, 180, 33, 85),
  N_America = c(-180, -15, 15, 90),
  Oceania = c(110, 180, -50, 10),
  S_America = c(-125, -31, 58, 35)
)
usethis::use_data(region_extent, overwrite = TRUE)
