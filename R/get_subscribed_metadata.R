#' Get metadata for subscribed NHS TRUD items
#'
#' @description
#' A convenience wrapper around [trud_items()] and [get_item_metadata()],
#' retrieving metadata for only items that the user is subscribed to. This is 
#' particularly useful for seeing what data you can download with [download_item()].
#' If you need access to additional items, browse available options with
#' [trud_items()], then subscribe through the NHS TRUD website.
#'
#' @inheritParams get_item_metadata
#'
#' @returns A tibble, with item metadata stored in the list column `metadata`.
#'   Use the `item_number` column values with [download_item()].
#' @export
#' @seealso 
#' * [trud_items()] to browse all available items
#' * [get_item_metadata()] for detailed metadata on specific items
#' * [download_item()] to download items you're subscribed to
#'
#' @examplesIf identical(Sys.getenv("IN_PKGDOWN"), "true")
#'   get_subscribed_metadata()
get_subscribed_metadata <- function(latest_only = FALSE) {
  # validate args
  get_trud_api_key()

  validate_arg_latest_only(latest_only)

  # get metadata for subscribed items
  all_items <- trud_items()

  all_items |>
    dplyr::mutate(
      "metadata" = purrr::map(
        .data[["item_number"]],
        \(item_number)
          tryCatch(
            get_item_metadata(
              item = item_number,
              latest_only = latest_only
            ),
            httr2_http_404 = function(cnd) {
              NA
            }
          ),
        .progress = TRUE
      )
    ) |>
    dplyr::filter(!is.na(.data[["metadata"]]))
}
