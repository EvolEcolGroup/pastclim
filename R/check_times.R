#' Check multiple time variables
#'
#' Check that we only have one set of times 
#'
#' @param time_bp times in bp
#' @param time_ce times in ce
#' @param allow_null boolean whether both can be NULL
#' @returns times in bp
#' @keywords internal

check_time_vars <- function(time_bp, time_ce, allow_null=TRUE) {
  if (all(!is.null(time_bp), !is.null(time_ce))){
    stop("both time_bp and time_ce were provide, the function can only accept one of the two")
  }
  if (all(is.null(time_bp), is.null(time_ce))){
    if (allow_null){
      return(NULL)
    } else {
      stop("either time_bp or time_ce should be provided")
    }
    
  }
  if (is.null(time_ce)){
    return(time_bp)
  } else {
    # convert it to bp
    if (inherits(time_ce, "list")){
      return(lapply(time_ce,function(x){x-1950}))
    } else {
      return(time_ce-1950)
    }
    
    
  }
}
