test_that("check_time_vars", {
  time_bp<-c(-1000,-20000,250)
  time_ce<-c(1950,0,-10000)
  expect_error(check_time_vars(time_bp=time_bp, time_ce=time_ce),
               "both time_bp and time_ce")
  expect_identical(check_time_vars(time_bp=time_bp, time_ce=NULL),
                   time_bp)
  expect_identical(check_time_vars(time_bp=NULL, time_ce=time_ce),
                   time_ce-1950)
  expect_identical(check_time_vars(time_bp=NULL, 
                                   time_ce = list(min=-11050,max=1950)),
                                   list(min=-13000,max=0))
  
  
  # deal with both null
  expect_null(check_time_vars(time_bp=NULL, time_ce=NULL))
  expect_error(check_time_vars(time_bp=NULL, time_ce=NULL, 
                               allow_null = FALSE), "either time_bp or time_ce should be provided")
}
)
