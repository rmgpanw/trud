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
#'  # Get metadata for Community Services Data Set pre-deadline extract XML Schema
#'  get_item_metadata(394) |>
#'    purrr::map_at("releases", \(release) purrr::map(release, names))
#'
#' # Include metadata for any previous releases using `latest_only = FALSE`
#' get_item_metadata(394, latest_only = FALSE) |>
#'    purrr::map_at("releases", \(release) purrr::map(release, names))
#' }
#'
#' # An informative error is raised if your API key is invalid or missing
#' try(download_item(394, TRUD_API_KEY = "INVALID_API_KEY"))
get_item_metadata <- function(item,
                              TRUD_API_KEY = NULL,
                              latest_only = FALSE) {
  # validate args
  TRUD_API_KEY <- get_trud_api_key(TRUD_API_KEY)

  validate_arg_item(item = item)

  validate_arg_latest_only(latest_only)

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

validate_arg_latest_only <- function(latest_only) {
  if (!rlang::is_logical(latest_only)) {
    cli::cli_abort(c(
      "Argument {.code latest_only} must be either {.code TRUE} or {.code FALSE}."
    ))
  }
}
