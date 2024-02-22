knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  message = FALSE
)

options(dplyr.summarise.inform = FALSE)

rtf2pdf <- function(input) {
  input <- normalizePath(input)
  x <- "export LD_LIBRARY_PATH=:/usr/lib/libreoffice/program:/usr/lib/x86_64-linux-gnu/"
  y <- paste0("libreoffice --invisible --headless --nologo --convert-to pdf --outdir tlf/ ", input)
  z <- paste(x, y, sep = " && ")
  if (Sys.getenv("GITHUB_ACTIONS") != "") system(z) else invisible(NULL)
}

# Customize data frame and tibble printing methods.
# See <https://github.com/elong0527/r4csr/issues/115> for details.
knit_print.data.frame <- function(x, ...) {
  paste(capture.output(base::print.data.frame(head(x, 4))), collapse = "\n")
}

registerS3method(
  "knit_print", "data.frame", knit_print.data.frame,
  envir = asNamespace("knitr")
)

options(pillar.advice = FALSE)

knit_print.tbl_df <- function(x, ...) {
  paste(capture.output(print(x, n = 4)), collapse = "\n")
}

registerS3method(
  "knit_print", "tbl_df", knit_print.tbl_df,
  envir = asNamespace("knitr")
)
