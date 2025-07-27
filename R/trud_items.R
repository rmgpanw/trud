#' Get available NHS TRUD items
#'
#' @description
#' Scrapes [this
#' page](https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/1)
#' from the NHS TRUD website for all available items. The `item_number` column
#' in the result contains the identifiers you need for [get_item_metadata()]
#' and [download_item()].
#'
#' ```{r child = "man/rmd/subscription-required.Rmd"}
#' ```
#'
#' @returns A tibble, with columns `item_number` and `item_name`. Use the
#'   `item_number` values as arguments to [get_item_metadata()] and [download_item()].
#' @export
#' @seealso
#' * [get_subscribed_metadata()] to see only items you're subscribed to
#' * [get_item_metadata()] to get detailed information about a specific item
#' * [download_item()] to download files for a specific item
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
  result <- df |>
    dplyr::filter(stringr::str_detect(
      .data[["item_link"]],
      "trud/users/guest/filters/0/categories/1/items"
    )) |>
    dplyr::filter(
      !.data[["item_name"]] %in% c("Releases", "Licences", "Future releases")
    ) |>
    dplyr::select(dplyr::all_of(c("item_number", "item_name")))

  # Validate scraper is working
  if (nrow(result) == 0) {
    cli::cli_warn(c(
      "!" = "No TRUD items found - page structure may have changed.",
      "i" = "This may indicate changes to the NHS TRUD website that require package updates.",
      "i" = "Please report this issue at: {.url https://github.com/rmgpanw/trud/issues}"
    ))
  } else if (nrow(result) < 10) {
    cli::cli_warn(c(
      "!" = "Unusually few TRUD items found ({nrow(result)} items) - page structure may have partially changed.",
      "i" = "Expected to find many more items on the NHS TRUD website.",
      "i" = "This may indicate parsing issues that require package updates.",
      "i" = "Please report this issue at: {.url https://github.com/rmgpanw/trud/issues}"
    ))
  }

  result
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
