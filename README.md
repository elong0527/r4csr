# R for Clinical Study Reports and Submission

The book is available at <https://r4csr.org>.

This project is a work in progress, enriched by the community's collective efforts.
As you read this book, consider joining us as a contributor.
The quality of this resource relies heavily on your input and expertise.
We value your participation and contribution.

- Authors: contributed the majority of content to at least one chapter.
- Contributors: contributed at least one commit to the source code.
- [List of authors and contributors](https://r4csr.org/preface.html#authors-and-contributors)

## Installing dependencies

To build the book, first install Quarto.

Then, install the R packages used by the book with:

```r
# install.packages("remotes")
remotes::install_deps()
```

## Build the book

In RStudio IDE, press Cmd/Ctrl + Shift + B. Or run:

```r
quarto::quarto_render()
```
