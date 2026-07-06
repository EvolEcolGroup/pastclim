# Print help to console

This function prints a help file to console. It is based on a function
published on R-bloggers: from
https://www.r-bloggers.com/2013/06/printing-r-help-files-in-the-console-or-in-knitr-documents/

## Usage

``` r
help_console(
  topic,
  format = c("text", "html", "latex"),
  lines = NULL,
  before = NULL,
  after = NULL
)
```

## Arguments

- topic:

  The topic of the help

- format:

  how the output should be formatted

- lines:

  which lines should be printed

- before:

  string to be printed before the output

- after:

  string to be printed after the output

## Value

text of the help file
