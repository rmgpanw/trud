#' Get available NHS TRUD items
#'
#' Scrapes [this
#' page](https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/1)
#' from the NHS TRUD website for all available items.
#'
#' @returns A tibble, with columns `item_number` and `item_name`.
#' @export
#'
#' @examplesIf identical(Sys.getenv("IN_PKGDOWN"), "true")
#' trud_items()
trud_items <- function() {
  # Read web page
  page <- get_trud_items_html()

  # Find all hyperlinks
  items <- page |>
    rvest::html_elements(css = ".content , a")

  # Extract text from each element
  items_text <- items |> rvest::html_text()

  # Extract the hyperlinks from each element using html_attr()
  items_link <- items |> rvest::html_attr("href")

  # Extract item numbers from hyperlinks
  items_number <- items_link |>
    stringr::str_extract("/items/\\d+") |>
    stringr::str_remove("/items/")

  # Create a dataframe with the item names and their links/numbers
  df <- tibble::tibble(
    item_name = items_text,
    item_link = items_link,
    item_number = as.integer(items_number)
  )

  # Filter for items
  df |>
    dplyr::filter(stringr::str_detect(
      .data[["item_link"]],
      "trud/users/guest/filters/0/categories/1/items"
    )) |>
    dplyr::filter(
      !.data[["item_name"]] %in% c("Releases", "Licences", "Future releases")
    ) |>
    dplyr::select(dplyr::all_of(c("item_number", "item_name")))
}

#' To facilitate mocking in unit testing for [trud_items()]
#'
#' @return Parsed html.
#' @noRd
get_trud_items_html <- function() {
  rvest::read_html(
    "https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/1"
  )
}
