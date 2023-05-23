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
