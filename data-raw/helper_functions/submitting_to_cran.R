# first check with rhub
pastclim_checks_aspell <- rhub::check_for_cran()
# there is currently a problem with aspell on Windows, so you need to run the
# following to make it work
pastclim_checks <- rhub::check_for_cran(env_vars = c('_R_CHECK_CRAN_INCOMING_USE_ASPELL_'= "false"))

# check on macos and windows via devtools
devtools::check_mac_release()
devtools::check_win_devel()

# if everything passes, edit the cran-comments.md to explain any notes
devtools::release()