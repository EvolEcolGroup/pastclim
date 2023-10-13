#' Convert years BP from pastclim to lubridate date, or vice versa
#'
#' These functions convert between years BP as used by pastclim (negative
#' numbers going into
#' the past, positive into the future) and standard
#' `POSIXct` date objects.
#' @param x a time in years BP using the `pastclim` convention of
#'  negative numbers indicating years into the past, or a `POSIXct` date object
#' @returns a `POSIXct` date object, or a vector
#' @examples
#' ybp2date(-10000)
#' ybp2date(0)
#' # back and forth
#' date2ybp(ybp2date(-10000))
#'
#' @export

ybp2date <- function(x) {
  if (!is.numeric(x)) {
    stop("x should be numeric")
  }
  lubridate::date_decimal(x + 1950)
}

#' @rdname ybp2date
#' @export
date2ybp <- function(x) {
  if (!inherits(x, "POSIXct")) {
    stop("x should be a POSIXct object")
  }
  lubridate::year(x) - 1950
}
