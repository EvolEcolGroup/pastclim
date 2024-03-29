## code to prepare `mis_boundaries` dataset
## source this script in RStudio
mis_boundaries <- data.frame(
  mis = c(20:6, "5e", "5d", "5c", "5b", "5a", 4:1),
  start = -1 * c(
    814, 790, 761, 712, 676, 621, 563, 533, 478, 424, 374, 337,
    300, 243, 191, 133, 116, 104, 94, 85, 71, 57, 29, 14
  ),
  end = -1 * c(
    790, 761, 712, 676, 621, 563, 533, 478, 424, 374, 337, 300,
    243, 191, 133, 116, 104, 94, 85, 71, 57, 29, 14, 0
  )
)
usethis::use_data(mis_boundaries, overwrite = TRUE)
