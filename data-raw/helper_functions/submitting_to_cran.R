# run the spell checking
usethis::use_spell_check(lang="en-GB")

# check the links
urlchecker::url_check()

# enhanced local checks
devtools::check(remote = TRUE, manual = TRUE)

source("")

# first check with rhub
pastclim_checks <- rhub::check_for_cran()

# check on macos and windows via devtools
devtools::check_mac_release()
devtools::check_win_devel()

# TO DO MANUALLY: update cran-comments.md accordingly
# upadte version number

# if everything passes, edit the cran-comments.md to explain any notes
devtools::release()
