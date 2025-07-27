#' Download NHS TRUD item
#'
#' @description
#' Downloads files for a specified NHS TRUD item. By default this downloads
#' the latest release. Use the `item` numbers from [trud_items()] or
#' [get_subscribed_metadata()].
#'
#' ```{r child = "man/rmd/subscription-required.Rmd"}
#' ```
#'
#' @section Working with specific releases:
#' To download a specific (non-latest) release:
#'
#' 1. Use [get_item_metadata()] with `release_scope = "all"` to retrieve metadata for all releases
#' 2. The release IDs are stored under the `id` item for each release
#' 3. Pass the desired release ID to the `release` parameter of [download_item()]
#'
#' @param item An integer, the item to be downloaded. Get these from [trud_items()]
#'   or [get_subscribed_metadata()].
#' @param directory Path to the directory to which this item will be downloaded
#'   to. This is set to the current working directory by default.
#' @param file_type The type of file to download. Options are `"archive"` (the
#'   main release file), `"checksum"`, `"signature"`, or `"publicKey"`. Defaults
#'   to `"archive"`.
#' @param release The release ID to be downloaded. Release IDs are found in the
#'   `id` field of each release from [get_item_metadata()]. If `NULL` (default),
#'   the latest item release will be downloaded.
#'
#' @returns The file path to the downloaded file, returned invisibly.
#' @export
#' @seealso
#' * [trud_items()] to find item numbers
#' * [get_subscribed_metadata()] to see items you can access
#' * [get_item_metadata()] to explore available releases before downloading
#'
#' @examplesIf identical(Sys.getenv("IN_PKGDOWN"), "true")
#' # Download Community Services Data Set pre-deadline extract XML Schema
#' x <- download_item(394, directory = tempdir())
#'
#' # List downloaded files
#' unzip(x, list = TRUE)
#'
#' # Download a previous release
#' # First get all releases to see available options
#' metadata <- get_item_metadata(394, release_scope = "all")
#' release_id <- metadata$releases[[2]]$id
#'
#' y <- download_item(394, directory = tempdir(), release = release_id)
#'
#' unzip(y, list = TRUE)
#'
#' @examples
#' # An informative error is raised if your API key is invalid or missing
#' try(withr::with_envvar(c("TRUD_API_KEY" = ""), download_item(394)))
download_item <- function(
  item,
  directory = ".",
  file_type = c("archive", "checksum", "signature", "publicKey"),
  release = NULL
) {
  # validate args
  validate_arg_item(item = item)

  validate_arg_directory(directory = directory)

  file_type <- rlang::arg_match(file_type)

  get_trud_api_key()

  if (!is.null(release)) {
    if (!rlang::is_string(release)) {
      cli::cli_abort(c("Argument {.code release} must be a string."))
    }
  }

  # get file URLs
  release_scope <- if (is.null(release)) "latest" else "all"

  item_metadata <- get_item_metadata(
    item = item,
    release_scope = release_scope
  )

  # validate `release`
  if (!is.null(release)) {
    if (!release %in% names(item_metadata$releases)) {
      cli::cli_abort(
        c(
          "x" = "Unrecognised {.code release} supplied for item {item}.",
          "i" = "See available releases with {.code get_item_metadata(item = {item}, release_scope = \"all\")}."
        ),
        class = "unrecognised_trud_item_release"
      )
    }
  } else {
    release <- 1
  }

  # download file
  file_name <- purrr::pluck(
    item_metadata,
    "releases",
    release,
    paste0(file_type, "FileName")
  )

  file_path <-
    file.path(
      directory,
      file_name
    )

  if (file.exists(file_path)) {
    cli::cli_warn(
      c(
        "!" = "File {.code {file_name}} already exists in directory {.code {directory}}",
        "i" = "Returning file path {.path {file_path}}"
      )
    )

    return(file_path)
  }

  url <- purrr::pluck(
    item_metadata,
    "releases",
    release,
    paste0(file_type, "FileUrl")
  )

  cli::cli_progress_step(
    "Downloading {file_type} file for TRUD item {item}...",
    msg_done = "Successfully downloaded {.code {file_name}} to {.path {file_path}}.",
    spinner = TRUE
  )

  resp_file_path <- request_download_item(url, file_path) |>
    purrr::pluck("body") |>
    unclass() |>
    normalizePath()

  # return path to downloaded file invisibly
  invisible(resp_file_path)
}

#' Performs request to download an item from NHS TRUD
#'
#' Used by [download_item()]. Facilitates mocking in unit testing.
#'
#' @param url String. Request URL, obtained using [get_item_metadata()].
#' @param file_path File path to download item to.
#'
#' @return httr2 HTTP response.
#' @noRd
request_download_item <- function(url, file_path) {
  httr2::request(url) |>
    req_user_agent_trud() |>
    handle_trud_request() |>
    httr2::req_perform(path = file_path)
}
