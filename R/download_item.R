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
#'  download_item(1799)
#' }
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
    release <- 1
  }

  item_metadata <- get_item_metadata(item = item,
                                     TRUD_API_KEY = TRUD_API_KEY,
                                     latest_only = latest_only)

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
    cli::cli_abort(
      stringr::str_glue(
        "File {{.code {file_name}}} already exists in directory {{.code {directory}}}"
      )
    )
  }

  url <- purrr::pluck(item_metadata,
                      "releases",
                      release,
                      paste0(download_file, "FileUrl"))

  resp <- httr2::request(url) %>%
    req_user_agent_trud() %>%
    httr2::req_perform(path = file_path)

  cli::cli_alert_success(stringr::str_glue("Successfully downloaded {{.code {file_name}}} to {{.code {file_path}}}."))

  # return path to downloaded file invisibly
  invisible(file_path)
}
