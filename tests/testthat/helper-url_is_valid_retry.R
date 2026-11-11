# Check a url with url_is_valid(), retrying before giving up.
#
# The servers of the datasets (HYDE, PaleoClim, CHELSA, WorldClim) sometimes
# fail to answer a request, either with a status that is not valid or with an
# error such as a connection timeout. To avoid failing the tests of the file
# names for a server hiccup, each url is tried up to `tries` times, `wait`
# seconds apart; an error counts as a failed attempt.
url_is_valid_retry <- function(url, tries = 3, wait = 5) {
  for (i in seq_len(tries)) {
    # an error (e.g. a timeout) is treated as an invalid answer
    valid <- tryCatch(url_is_valid(url), error = function(e) FALSE)
    if (isTRUE(valid)) {
      return(TRUE)
    }
    # wait before the next attempt (but not after the last one)
    if (i < tries) {
      Sys.sleep(wait)
    }
  }
  FALSE
}
