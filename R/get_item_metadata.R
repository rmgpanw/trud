#' Retrieve metadata for a NHS TRUD item
#'
#' @description
#' Sends a request to the release list endpoint, returning a list of metadata
#' pertaining to the specified NHS TRUD item.
#'
#' ```{r child = "man/rmd/subscription-required.Rmd"}
#' ```
#'
#' @inheritParams download_item
#' @param latest_only If `TRUE`, only metadata pertaining to the latest item
#'   release will be retrieved. By default this is set to `FALSE`.
#'
#' @returns A list.
#' @export
#'
#' @examplesIf identical(Sys.getenv("IN_PKGDOWN"), "true")
#' # Get metadata for Community Services Data Set pre-deadline extract XML Schema
#' get_item_metadata(394) |>
#'   purrr::map_at("releases", \(release) purrr::map(release, names))
#'
#' # Include metadata for any previous releases using `latest_only = FALSE`
#' get_item_metadata(394, latest_only = FALSE) |>
#'   purrr::map_at("releases", \(release) purrr::map(release, names))
#'
#' @examples
#' # An informative error is raised if your API key is invalid or missing
#' try(withr::with_envvar(c("TRUD_API_KEY" = ""), get_item_metadata(394)))
get_item_metadata <- function(item, latest_only = FALSE) {
  # validate args
  TRUD_API_KEY <- get_trud_api_key()

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
  result <- request_item_metadata(url)

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

request_item_metadata <- function(url) {
  httr2::request(url) |>
    req_user_agent_trud() |>
    handle_trud_request() |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
