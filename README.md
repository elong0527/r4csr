# R for Clinical Study Reports and Submission

The project is still under development.

The book is available at <https://r4csr.org>.

The document is maintained by a community.
While reading the document, you can be a contributor as well.
The quality of this document relies on you.

- Authors: contributed the majority of content to at least one chapter.
- Contributors: contributed at least one commit to the source code.
- [List of authors and contributors](https://r4csr.org/preface.html#authors-and-contributors)

## Installing dependencies

Install the R packages used by the book with:

```r
# install.packages("remotes")
remotes::install_deps()
```

## Build the book

In RStudio, press Cmd/Ctrl + Shift + B. Or run:

```R
bookdown::render_book("index.Rmd")
```
