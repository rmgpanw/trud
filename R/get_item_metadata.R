#' Retrieve metadata for a NHS TRUD item
#'
#' Sends a request to the release list endpoint, returning a list of metadata
#' pertaining to the specified NHS TRUD item.
#'
#' @inheritParams download_item
#' @param latest_only If `TRUE`, only metadata pertaining to the latest item
#'   release will be retrieved. By default this is set to `FALSE`.
#'
#' @return A list.
#' @export
#'
#' @examples
#' \dontrun{
#'  get_item_metadata(1799, latest_only = TRUE)
#' }
get_item_metadata <- function(item,
                              TRUD_API_KEY = NULL,
                              latest_only = FALSE) {
  # validate args
  TRUD_API_KEY <- get_trud_api_key(TRUD_API_KEY)

  validate_arg_item(item = item)

  if (!rlang::is_logical(latest_only)) {
    cli::cli_abort(c("Argument {.code latest_only} must be either {.code TRUE} or {.code FALSE}."))
  }

  # Construct the URL with the API key and the item number
  url <-
    paste0(
      "https://isd.digital.nhs.uk/trud/api/v1/keys/",
      TRUD_API_KEY,
      "/items/",
      item,
      "/releases"
    )

  if (latest_only) {
    url <- paste0(url, "?latest")
  }

  # Make a GET request and parse the JSON response
  result <- httr2::request(url) %>%
    httr2::req_error(body = trud_error_message) %>%
    req_user_agent_trud() %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()

  # name list of releases, using release ids
  names(result$releases) <- purrr::map_chr(result$releases, \(x) x$id)

  return(result)
}
