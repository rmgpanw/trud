#' Utility function to retrieve NHS TRUD API key
#'
#' An informative error is raised if no key is found.
#'
#' @param call The function call from which to display any error messages.
#'
#' @return The TRUD API key as a string, invisibly.
#' @noRd
get_trud_api_key <- function(call = rlang::caller_env()) {
  error_guidance_messages <-
    c(
      "i" = "Set your NHS TRUD API key as an environment variable using {.code Sys.setenv(TRUD_API_KEY='<<your-key>>')}, or preferably use a {.code .Renviron} file",
      "i" = "To get an API key, first sign up for a NHS TRUD account at {.url https://isd.digital.nhs.uk/trud/users/guest/filters/0/account/form}",
      "i" = "To find Your API key, log in and visit your account profile page ({.url https://isd.digital.nhs.uk/trud/users/authenticated/filters/0/account/manage})."
    )

  TRUD_API_KEY <- Sys.getenv("TRUD_API_KEY")
  if (identical(TRUD_API_KEY, "")) {
    cli::cli_abort(
      message = c(
        "x" = "Can't find NHS TRUD API key",
        error_guidance_messages
      ),
      class = "missing_api_key",
      call = call
    )
  }

  invisible(TRUD_API_KEY)
}

#' Raise an informative error message for invalid NHS TRUD API key
#'
#' To be used with [httr2::req_error()] within [request_item_metadata()].
#'
#' @param resp An `httr2_request` object, as returned by [httr2::request()].
#'
#' @return Returns the input `httr2_request` object if no errors raised.
#' @noRd
trud_error_message <- function(resp) {
  resp <- try_resp_body_json(resp)

  if (inherits(resp, "character")) {
    return(resp)
  }

  switch(
    as.character(resp$httpStatus),
    "404" = c(
      "x" = stringr::str_replace(
        resp$message,
        "API key .*,",
        "supplied API key,"
      ),
      "i" = "Either this item number does not exist, or you are not subscribed to it",
      "i" = "For further information, see https://isd.digital.nhs.uk/trud/users/guest/filters/0/api"
    ),
    "400" = c("x" = "BAD REQUEST: invalid API key"),
    "401" = c(
      "x" = resp$message,
      "i" = "Have you changed your NHS TRUD account password? If so, your API key will have also updated"
    )
  )
}

#' Attempt to extract JSON from httr2 request object
#'
#' Specific error statuses are handled by [trud_error_message()]. This handles
#' other error types, including when the TRUD service is unavailable.
#'
#' @param resp An `httr2_request` object, as returned by [httr2::request()].
#'
#' @return A list (parsed JSON from request object), if no error.
#' @noRd
try_resp_body_json <- function(resp) {
  tryCatch(
    resp |>
      httr2::resp_body_json(),
    error = function(cnd) {
      c(
        "x" = stringr::str_glue(
          "HTTP Status {httr2::resp_status(resp)}: {httr2::resp_status_desc(resp)}"
        ),
        "!" = "Unexpected error. Is the TRUD website down?"
      )
    }
  )
}

#' Validates `item` arg
#'
#' @param item An integer, the item to be downloaded or retrieve metadata for.
#' @param call The function call from which to display any error messages.
#'
#' @return Called for side effect
#' @noRd
validate_arg_item <- function(item, call = rlang::caller_env()) {
  if (!rlang::is_scalar_integerish(item)) {
    cli::cli_abort(
      c(
        "x" = "Argument {.code item} must be an integer.",
        "i" = "Use {.code trud_items()} to see available items."
      ),
      call = call
    )
  }
}

#' Validates `directory` arg
#'
#' @param directory Path to the directory to which this item will be downloaded
#'   to. This is set to the current working directory by default.
#' @param call The function call from which to display any error messages.
#'
#' @return Called for side effect
#' @noRd
validate_arg_directory <- function(directory, call = rlang::caller_env()) {
  directory_arg_example <-
    c(
      "i" = stringr::str_glue(
        "For example, if {{.code directory = '.'}}, the selected TRUD item ",
        "file will be downloaded to the current working directory. ",
        "This could also be achieved with {{.code directory = '{getwd()}'}}"
      )
    )

  if (!rlang::is_string(directory)) {
    cli::cli_abort(
      c(
        "x" = "Argument {.code directory} must be a string.",
        directory_arg_example
      ),
      call = call
    )
  }

  if (!dir.exists(directory)) {
    cli::cli_abort(
      message = c(
        "x" = "Argument {.code directory} must be a valid file path.",
        "!" = stringr::str_glue(
          "Directory does not exist: {{.code {directory}}}."
        ),
        directory_arg_example
      ),
      call = call
    )
  }
}

#' Add user agent to TRUD API request object
#'
#' @param req An `httr2_request` object, created by [httr2::request()].
#'
#' @return An `httr2_request` object
#' @noRd
req_user_agent_trud <- function(req) {
  user_agent_header <- Sys.getenv(
    "TRUD_USER_AGENT",
    unset = "trud (http://github.com/ropensci/trud)"
  )

  req |> httr2::req_user_agent(user_agent_header)
}

#' Configure error handling, retry logic, and rate limiting for TRUD API requests
#'
#' This function adds request handling to httr2 request objects for
#' interaction with the NHS TRUD API. It configures custom error messages,
#' automatic retry for transient failures, and rate limiting to respect API limits.
#'
#' **Retryable errors (will retry automatically):**
#' - `429` (TOO_MANY_REQUESTS) - Rate limiting (essential for NHS APIs)
#' - `500` (INTERNAL_SERVER_ERROR) - Server errors that might resolve on retry
#' - `502` (BAD_GATEWAY) - Gateway/proxy issues that are often temporary
#' - `503` (SERVICE_UNAVAILABLE) - Server maintenance/overload
#' - `504` (GATEWAY_TIMEOUT) - Timeout issues that may succeed on retry
#'
#' **Non-retryable errors (will fail immediately):**
#' - 4xx client errors (400, 401, 403, 404, 409) - Problems with the request
#' - `501` (NOT_IMPLEMENTED) - The endpoint doesn't support the method
#'
#' For further information about NHS API standards, see the
#' [NHS reference guide for API standards](https://digital.nhs.uk/developer/guides-and-documentation/reference-guide#api-status).
#'
#' @param req An `httr2_request` object created by [httr2::request()].
#' @param max_tries Integer. Maximum number of retry attempts (default: 3).
#' @param retry_status An integer vector. HTTP status codes that should trigger
#'   automatic retry (default: `c(429, 500, 502, 503, 504)`).
#' @param capacity Integer. Maximum number of requests per `fill_time_s`
#'   period for rate limiting (default: 2).
#' @param fill_time_s Integer Time period in seconds for the rate limiting
#'   bucket to refill (default: 2).
#'
#' @returns An `httr2_request` object with error handling, retry logic, and
#'   rate limiting configured.
#' @noRd
#' @examples
#' \dontrun{
#' # Configure a TRUD API request with default retry and rate limiting
#' req <- httr2::request("https://isd.digital.nhs.uk/trud/api/v1/keys/...")
#' req <- handle_trud_request(req)
#'
#' # Customize retry behavior
#' req <- handle_trud_request(
#'   req,
#'   max_tries = 5,
#'   capacity = 1,
#'   fill_time_s = 3
#' )
#' }
handle_trud_request <- function(
  req,
  max_tries = 3,
  retry_status = c(429, 500, 502, 503, 504),
  capacity = 2,
  fill_time_s = 2
) {
  req |>
    httr2::req_error(body = trud_error_message) |>
    httr2::req_retry(
      max_tries = max_tries,
      is_transient = function(resp) {
        httr2::resp_status(resp) %in% retry_status
      }
    ) |>
    httr2::req_throttle(capacity = capacity, fill_time_s = fill_time_s)
}

#' Validate release_scope argument
#' @param release_scope Character vector to validate
#' @return The matched value, invisibly
#' @noRd
validate_arg_release_scope <- function(release_scope) {
  rlang::arg_match(release_scope, c("all", "latest"))
}
