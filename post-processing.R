fs::dir_copy("tlf/", "_book/tlf", overwrite = TRUE)
fs::dir_copy("slides/", "_book/slides", overwrite = TRUE)
file.copy("static/CNAME", "_book", overwrite = TRUE)
