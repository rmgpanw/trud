#' Get metadata for subscribed NHS TRUD items
#'
#' A convenience wrapper around [trud_items()] and [get_item_metadata()],
#' retrieving metadata for only items that the user is subscribed to.
#'
#' @inheritParams get_item_metadata
#'
#' @return A tibble, with item metadata stored in the list column `metadata`.
#' @export
#' @seealso  [trud_items()], [get_item_metadata()]
#'
#' @examples
#' \dontrun{
#' get_subscribed_metadata()
#' }
get_subscribed_metadata <- function(TRUD_API_KEY = NULL,
                                    latest_only = FALSE) {
  # validate args
  get_trud_api_key(TRUD_API_KEY)

  validate_arg_latest_only(latest_only)

  # get metadata for subscribed items
  all_items <- trud_items()

  all_items %>%
    dplyr::mutate("metadata" = purrr::map(.data[["item_number"]], \(item_number) tryCatch(
      get_item_metadata(
        item = item_number,
        TRUD_API_KEY = TRUD_API_KEY,
        latest_only = latest_only
      ),
      httr2_http_404 = function(cnd) {
        NA
      }
    ), .progress = TRUE)) |>
    dplyr::filter(!is.na(.data[["metadata"]]))
}
