## code to prepare `snapshot_trud_items_html` dataset goes here
snapshot_trud_items_html <- rvest::read_html("https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/1") |>
  as.character()
usethis::use_data(snapshot_trud_items_html,
                  overwrite = TRUE,
                  internal = TRUE)
