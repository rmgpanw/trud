#' Download NHS TRUD item
#'
#' Downloads files for a specified NHS TRUD item (requires a subscription). By
#' default this is the latest release.
#'
#' @param item An integer, the item to be downloaded.
#' @param directory Path to the directory to which this item will be downloaded
#'   to. This is set to the current working directory by default.
#' @param download_file The item file to be downloaded. Valid values:
#'   - `"archive"` (the release item)
#'   - `"checksum"`
#'   - `"signature"`
#'   - `"publickKey"`
#' @param TRUD_API_KEY A string. The name of an environmental variable
#'   containing your TRUD API key. If `NULL` (default) this is assumed to be
#'   called `TRUD_API_KEY`.
#' @param release The name of a specific release ID to be downloaded (this can
#'   be ascertained using [get_item_metadata()]). If `NULL` (default), then the
#'   latest item release will be downloaded.
#'
#' @return The file path to the downloaded file, returned invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#'  # Download Community Services Data Set pre-deadline extract XML Schema
#'  x <- download_item(394, directory = tempdir())
#'
#'  # List downloaded files
#'  unzip(x, list = TRUE)
#'
#'  # Download a previous release
#'  release <- get_item_metadata(394)$releases[[2]]$id
#'
#'  y <- download_item(394, directory = tempdir(), release = release)
#'
#'  unzip(y, list = TRUE)
#' }
#'
#' # An informative error is raised if your API key is invalid or missing
#' try(download_item(394, TRUD_API_KEY = "INVALID_API_KEY"))
download_item <- function(item,
                          directory = ".",
                          download_file = "archive",
                          TRUD_API_KEY = NULL,
                          release = NULL) {

  # validate args
  validate_arg_item(item = item)

  validate_arg_directory(directory = directory)

  validate_arg_download_file(download_file = download_file)

  get_trud_api_key(TRUD_API_KEY)

  if (!is.null(release)) {
    if (!rlang::is_string(release)) {
      cli::cli_abort(c("Argument {.code release} must be a string."))
    }
  }

  # get file URLs
  latest_only <- FALSE

  if (is.null(release)) {
    latest_only <- TRUE
  }

  item_metadata <- get_item_metadata(item = item,
                                     TRUD_API_KEY = TRUD_API_KEY,
                                     latest_only = latest_only)

  # validate `release`
  if (!is.null(release)) {
    if (!release %in% names(item_metadata$releases)) {
      cli::cli_abort(
        c("x" = "Unrecognised {.code release} supplied for item {item}.",
          "i" = "See available releases with {.code get_item_metadata(item = {item}, latest_only = FALSE)}.")
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
    paste0(download_file, "FileName")
  )

  file_path <-
    file.path(directory,
              file_name)

  if (file.exists(file_path)) {
    cli::cli_warn(
        c("!" = "File {.code {file_name}} already exists in directory {.code {directory}}",
          "i" = "Returning file path {.path {file_path}}")
      )

    return(file_path)
  }

  url <- purrr::pluck(item_metadata,
                      "releases",
                      release,
                      paste0(download_file, "FileUrl"))

  cli::cli_progress_step("Downloading {download_file} file for TRUD item {item}...",
                         msg_done = "Successfully downloaded {.code {file_name}} to {.path {file_path}}.",
                         spinner = TRUE)

  resp <- httr2::request(url) %>%
    req_user_agent_trud() %>%
    httr2::req_perform(path = file_path)

  # return path to downloaded file invisibly
  invisible(file_path)
}
