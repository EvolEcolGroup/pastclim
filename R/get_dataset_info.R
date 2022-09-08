#' Get the information about a dataset
#'
#' This function provides full information about a given dataset. A full
#' list of datasets available in pastclim can be obtained with
#' \code{get_available_datasets}
#'
#' @param dataset A dataset in pastclim
#' @export

get_dataset_info <- function(dataset) {
  if (!dataset %in% get_available_datasets()){
    stop("The dataset is not available in pastclim")
  }
  help_console(dataset)
}

#' Print help to console
#'
#' This function prints a help file to console. It is based on a function published on
#' R-bloggers:
#' from https://www.r-bloggers.com/2013/06/printing-r-help-files-in-the-console-or-in-knitr-documents/
#' @param topic The topic of the help
#' @param format how the output shoudl be formmated
#' @param which lines should be printed
#' @param before string to be printed before the output
#' @param after string to be printed after the output
#'
#' @keywords internal

help_console <- function(topic, format=c("text", "html", "latex", "Rd"),
                         lines=NULL, before=NULL, after=NULL) {  
  format=match.arg(format)
  if (!is.character(topic)) topic <- deparse(substitute(topic))
  helpfile = utils:::.getHelpFile(help(topic))
  hs <- capture.output(switch(format, 
                              text=tools:::Rd2txt(helpfile),
                              html=tools:::Rd2HTML(helpfile),
                              latex=tools:::Rd2latex(helpfile),
                              Rd=tools:::prepare_Rd(helpfile)
  )
  )
  if(!is.null(lines)) hs <- hs[lines]
  hs <- c(before, hs, after)
  cat(hs, sep="\n")
  invisible(hs)
}