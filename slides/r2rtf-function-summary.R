# Generate an RTF table --------------------------------------------------------
# Example from <https://merck.github.io/r2rtf/articles/example-sublineby-pageby-groupby.html>

library(r2rtf)
library(dplyr)
library(pdftools)
library(magick)

data(r2rtf_adae)

ae_t1 <- r2rtf_adae[200:260, ] %>%
  mutate(
    SUBLINEBY = paste0(
      "Trial Number: ", STUDYID,
      ", Site Number: ", SITEID
    ),
    SUBJLINE = paste0(
      "Subject ID = ", USUBJID,
      ", Gender = ", SEX,
      ", Race = ", RACE,
      ", AGE = ", AGE, " Years",
      ", TRT = ", TRTA
    ),
    # create a subject line with participant's demographic information.
    # this is for page_by argument in rtf_body function
    AEDECD1 = tools::toTitleCase(AEDECOD), # propcase the AEDECOD
    DUR = paste(ADURN, ADURU, sep = " ")
  ) %>% # AE duration with unit
  select(USUBJID, ASTDY, AEDECD1, DUR, AESEV, AESER, AEREL, AEACN, AEOUT, TRTA, SUBJLINE, SUBLINEBY) # display variable using this order

ae_tbl <- ae_t1 %>%
  # It is important to order variable properly.
  arrange(SUBLINEBY, TRTA, SUBJLINE, USUBJID, ASTDY) %>%
  rtf_page(orientation = "landscape", col_width = 9) %>%
  rtf_page_header() %>%
  rtf_page_footer(text = "CONFIDENTIAL") %>%
  rtf_title(
    "Listing of Subjects With Serious Adverse Events",
    "ASaT"
  ) %>%
  rtf_colheader(
    "Subject| Rel Day | Adverse | | | | |Action| |",
    col_rel_width = c(2.5, 2, 4, 2, 3, 2, 3, 2, 5)
  ) %>%
  rtf_colheader(
    "ID| of Onset | Event | Duration | Intensity | Serious | Related | Taken| Outcome",
    border_top = "",
    col_rel_width = c(2.5, 2, 4, 2, 3, 2, 3, 2, 5)
  ) %>%
  rtf_body(
    col_rel_width = c(2.5, 2, 4, 2, 3, 2, 3, 2, 5, 1, 1, 1),
    text_justification = c("l", rep("c", 8), "l", "l", "l"),
    text_format = c(rep("", 9), "b", "", "b"),
    border_top = c(rep("", 9), "single", "single", "single"),
    border_bottom = c(rep("", 9), "single", "single", "single"),
    subline_by = "SUBLINEBY",
    page_by = c("TRTA", "SUBJLINE"),
    group_by = c("USUBJID", "ASTDY")
  ) %>%
  rtf_footnote(c("This is a footnote. This is footnote 1.")) %>%
  rtf_source("Source:  [Study MK9999P001: adam-adae]")

path_rtf <- "slides/function-summary.rtf"

ae_tbl %>%
  rtf_encode() %>%
  write_rtf(path_rtf)

# Convert RTF to PDF -----------------------------------------------------------

path_pdf <- "slides/function-summary.pdf"

r2rtf:::rtf_convert_format(
  path_rtf,
  output_file = basename(path_pdf),
  output_dir = dirname(path_pdf),
  format = "pdf",
  overwrite = TRUE
)

# Convert PDF to PNG -----------------------------------------------------------

path_png <- "slides/function-summary.png"

image_read_pdf(path_pdf, pages = 9, density = 300) %>%
  image_write(path = path_png)

# Annotate PNG -----------------------------------------------------------------

img <- image_read(path_png) %>% image_border(color = "#FFFFFF", geometry = "300x1")

img1 <- img %>%
  image_annotate(
    text = "rtf_page_header()",
    gravity = "northeast", location = "+970+375",
    color = "#FFFFFF", boxcolor = "#00857C", size = 50, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = sprintf("\u2192"),
    gravity = "northeast", location = "+840+295",
    color = "#00857C", size = 200, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = "rtf_title()",
    gravity = "northeast", location = "+980+660",
    color = "#FFFFFF", boxcolor = "#00857C", size = 50, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = sprintf("\u2190"),
    gravity = "northeast", location = "+1320+580",
    color = "#00857C", size = 200, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = "rtf_subline()",
    gravity = "northwest", location = "+1560+780",
    color = "#FFFFFF", boxcolor = "#00857C", size = 50, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = sprintf("\u2190"),
    gravity = "northwest", location = "+1430+700",
    color = "#00857C", size = 200, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = "rtf_colheader()",
    gravity = "northwest", location = "+10+865",
    color = "#FFFFFF", boxcolor = "#00857C", size = 50, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = sprintf("\u2192"),
    gravity = "northwest", location = "+470+785",
    color = "#00857C", size = 200, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = "rtf_body()",
    gravity = "northwest", location = "+160+945",
    color = "#FFFFFF", boxcolor = "#00857C", size = 50, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = sprintf("\u2192"),
    gravity = "northwest", location = "+470+860",
    color = "#00857C", size = 200, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = "arg: page_by",
    gravity = "northwest", location = "+1150+945",
    color = "#FFFFFF", boxcolor = "#00857C", size = 50, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = sprintf("\u2190"),
    gravity = "northwest", location = "+1015+860",
    color = "#00857C", size = 200, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = "arg: group_by",
    gravity = "northwest", location = "+890+1115",
    color = "#FFFFFF", boxcolor = "#00857C", size = 50, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = sprintf("\u2190"),
    gravity = "northwest", location = "+760+1030",
    color = "#00857C", size = 200, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = "rtf_footnote()",
    gravity = "northwest", location = "+40+1620",
    color = "#FFFFFF", boxcolor = "#00857C", size = 50, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = sprintf("\u2192"),
    gravity = "northwest", location = "+470+1540",
    color = "#00857C", size = 200, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = "rtf_source()",
    gravity = "northwest", location = "+2420+1690",
    color = "#FFFFFF", boxcolor = "#00857C", size = 50, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = sprintf("\u2190"),
    gravity = "northwest", location = "+2290+1610",
    color = "#00857C", size = 200, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = "rtf_page_footer()",
    gravity = "northwest", location = "+1120+2110",
    color = "#FFFFFF", boxcolor = "#00857C", size = 50, font = "Liberation Mono"
  ) %>%
  image_annotate(
    text = sprintf("\u2192"),
    gravity = "northwest", location = "+1640+2030",
    color = "#00857C", size = 200, font = "Liberation Mono"
  )

# Trim and save PNG ------------------------------------------------------------

img1 %>%
  image_trim() %>%
  image_border(color = "#FFFFFF", geometry = "50x50") %>%
  image_write(path_png)

# Remove intermediate files ----------------------------------------------------

unlink(c(path_rtf, path_pdf))
