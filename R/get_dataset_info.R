#' Get the information about a dataset
#'
#' This function provides full information about a given dataset. A full
#' list of datasets available in pastclim can be obtained with
#' [list_available_datasets()]
#'
#' @param dataset A dataset in pastclim
#' @returns text describing the dataset
#' @keywords internal

get_dataset_info <- function(dataset) {
  #  if (!dataset %in% list_available_datasets()){
  #    stop("The dataset is not available in pastclim")
  #  }
  help_console(dataset)
}

#' Print help to console
#'
#' This function prints a help file to console. It is based on a function published on
#' R-bloggers:
#' from https://www.r-bloggers.com/2013/06/printing-r-help-files-in-the-console-or-in-knitr-documents/
#' @param topic The topic of the help
#' @param format how the output should be formatted
#' @param lines which lines should be printed
#' @param before string to be printed before the output
#' @param after string to be printed after the output
#' @returns text of the help file
#'
#' @keywords internal

help_console <- function(topic, format = c("text", "html", "latex"),
                         lines = NULL, before = NULL, after = NULL) {
  format <- match.arg(format)
  if (!is.character(topic)) topic <- deparse(substitute(topic))
  getHelpFile <- utils::getFromNamespace(".getHelpFile", "utils")
  helpfile <- getHelpFile(utils::help(topic))
  hs <- utils::capture.output(switch(format,
    text = tools::Rd2txt(helpfile,
      outputEncoding = "ASCII"
    ),
    html = tools::Rd2HTML(helpfile),
    latex = tools::Rd2latex(helpfile)
  ))
  # replace strange formatting of title
  hs[substr(hs, 1, 2) == "_\b"] <- gsub("_\b", "", hs[substr(hs, 1, 2) == "_\b"], fixed = TRUE)
  if (!is.null(lines)) hs <- hs[lines]
  hs <- c(before, hs, after)
  cat(hs, sep = "\n")
  invisible(hs)
}
