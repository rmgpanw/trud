#' Retrieve metadata for a NHS TRUD item
#'
#' @description
#' Sends a request to the release list endpoint, returning a list of metadata
#' pertaining to the specified NHS TRUD item. Use the `item` numbers from
#' [trud_items()] or [get_subscribed_metadata()].
#'
#' ```{r child = "man/rmd/subscription-required.Rmd"}
#' ```
#'
#' @inheritParams download_item
#' @param release_scope Which releases to retrieve metadata for. Use `"all"` to
#'   get all releases, or `"latest"` to get only the most recent release.
#'
#' @returns A list containing item metadata, including release information that
#'   can be used with [download_item()]. Release IDs for specific downloads are
#'   in the `id` field of each release.
#' @export
#' @seealso
#' * [trud_items()] to find item numbers
#' * [get_subscribed_metadata()] to see items you can access
#' * [download_item()] to download files using this metadata
#'
#' @examplesIf identical(Sys.getenv("IN_PKGDOWN"), "true")
#' # Get metadata for Community Services Data Set pre-deadline extract XML Schema
#' get_item_metadata(394) |>
#'   # Display structure without showing sensitive API keys in URLs
#'   purrr::map_at("releases", \(release) purrr::map(release, names))
#'
#' # Include metadata for any previous releases using `release_scope = "all"`
#' get_item_metadata(394, release_scope = "all") |>
#'   # Display structure without showing sensitive API keys in URLs
#'   purrr::map_at("releases", \(release) purrr::map(release, names))
#'
#' @examples
#' # An informative error is raised if your API key is invalid or missing
#' try(withr::with_envvar(c("TRUD_API_KEY" = ""), get_item_metadata(394)))
get_item_metadata <- function(item, release_scope = c("all", "latest")) {
  # validate args
  TRUD_API_KEY <- get_trud_api_key()

  validate_arg_item(item = item)

  release_scope <- validate_arg_release_scope(release_scope)

  # Construct the URL with the API key and the item number
  url <-
    paste0(
      "https://isd.digital.nhs.uk/trud/api/v1/keys/",
      TRUD_API_KEY,
      "/items/",
      item,
      "/releases"
    )

  if (release_scope == "latest") {
    url <- paste0(url, "?latest")
  }

  # Make a GET request and parse the JSON response
  result <- request_item_metadata(url)

  # name list of releases, using release ids
  names(result$releases) <- purrr::map_chr(result$releases, \(x) x$id)

  return(result)
}

request_item_metadata <- function(url) {
  httr2::request(url) |>
    req_user_agent_trud() |>
    handle_trud_request() |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
