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

# from https://www.r-bloggers.com/2013/06/printing-r-help-files-in-the-console-or-in-knitr-documents/
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