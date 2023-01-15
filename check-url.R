#' Flatten copy
#'
#' @param from Source directory path
#' @param to Destination directory path
#'
#' @details Copy all `.Rmd` and `.md` files from source to destination,
#' rename the `.md` files with an additional `.Rmd` extension, and get a
#' flat destination directory structure with path-preserving file names.
flatten_copy <- function(from, to) {
  rmd <- list.files(from, pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
  md <- list.files(from, pattern = "\\.md", recursive = TRUE, full.names = TRUE)

  src <- c(rmd, md)
  dst <- c(rmd, paste0(md, ".Rmd"))

  # Remove starting `./` (if any)
  dst <- gsub("^\\./", replacement = "", x = dst)
  # Replace the forward slash in path with Unicode big solidus
  dst <- gsub("/", replacement = "\u29F8", x = dst)

  file.copy(src, to = file.path(to, dst))

  invisible(to)
}

#' Check URLs in a bookdown project
#'
#' @param input Path to the bookdown project directory.
#'
#' @return URL checking results from `urlchecker::url_check()`
#' for all `.Rmd` and `.md` files in the project.
#'
#' @note The `tools::pkgVignettes()$docs` call in urlchecker
#' requires two things (`VignetteBuilder` and `VignetteEngine`)
#' to recognize `.Rmd` files as package vignettes.
check_url <- function(input = ".") {
  # Create a source package directory
  pkg <- tempfile()
  dir.create(pkg)

  # Create a minimal DESCRIPTION file
  write("VignetteBuilder: knitr", file = file.path(pkg, "DESCRIPTION"))

  # Flatten copy all .Rmd and .md files
  vig <- file.path(pkg, "vignettes")
  dir.create(vig)
  flatten_copy(input, vig)

  # Make the .Rmd files look like vignettes
  lapply(
    list.files(vig, full.names = TRUE),
    function(x) {
      write(
        "---\nvignette: >\n  %\\VignetteEngine{knitr::rmarkdown}\n---",
        file = x, append = TRUE
      )
    }
  )

  urlchecker::url_check(pkg)
}

check_url()
