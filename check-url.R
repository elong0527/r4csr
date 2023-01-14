#' Check URLs in a bookdown project
#'
#' @param input Path to the bookdown project directory.
#'
#' @return URL checking results from `urlchecker::url_check()`
#'
#' @details This assumes there are no `.Rmd` and `.md` files with
#' duplicated names in the bookdown project.
#'
#' @note The `tools::pkgVignettes()$docs` call in urlchecker
#' requires two things (VignetteBuilder and VignetteEngine)
#' to recognize `.Rmd` files as package vignettes.
check_url <- function(input = ".") {
  pkg_path <- tempfile()
  dir.create(pkg_path)

  # Create a DESCRIPTION file
  write("VignetteBuilder: knitr", file = file.path(pkg_path, "DESCRIPTION"))

  # Copy all .Rmd and .md files
  rmd_path <- file.path(pkg_path, "vignettes")
  dir.create(rmd_path)
  file.copy(
    list.files(path = input, pattern = "\\.Rmd$|\\.md$", recursive = TRUE),
    to = rmd_path,
    overwrite = TRUE
  )
  # Rename .md to .Rmd
  md <- list.files(rmd_path, pattern = "\\.md$", full.names = TRUE)
  if (length(md)) file.rename(md, to = paste0(tools::file_path_sans_ext(md), ".Rmd"))

  # Make them look like vignettes
  lapply(
    list.files(rmd_path, full.names = TRUE),
    function(x) {
      write(
        "---\nvignette: >\n  %\\VignetteEngine{knitr::rmarkdown}\n---",
        file = x,
        append = TRUE
      )
    }
  )

  urlchecker::url_check(pkg_path)
}

check_url()
