get_trud_api_key <- function(TRUD_API_KEY, call = rlang::caller_env()) {
  error_guidance_messages <-
    c("i" = "Set your NHS TRUD API key as an environment variable using {.code Sys.setenv(TRUD_API_KEY='<<your-key>>')}, or preferably use a {.code .Renviron} file",
      "i" = "To get an API key, first sign up for a NHS TRUD account at {.url https://isd.digital.nhs.uk/trud/users/guest/filters/0/account/form}",
      "i" = "To find Your API key, log in and visit your account profile page ({.url https://isd.digital.nhs.uk/trud/users/authenticated/filters/0/account/manage}).")

  if (is.null(TRUD_API_KEY)) {
    TRUD_API_KEY <- "TRUD_API_KEY"
  } else {
    if (!rlang::is_string(TRUD_API_KEY)) {
      cli::cli_abort(
        message = c(
          "x" = "Argument {.code TRUD_API_KEY} must either be a string or {.code NULL}",
          error_guidance_messages
        ),
        call = call
      )
    }
  }

  TRUD_API_KEY <- Sys.getenv(TRUD_API_KEY)
  if (identical(TRUD_API_KEY, "")) {
    cli::cli_abort(message = c("x" = "Can't find NHS TRUD API key",
                               error_guidance_messages),
                   call = call)
  }

  invisible(TRUD_API_KEY)
}

trud_error_message <- function(resp) {
  resp <- try_resp_body_json(resp)

  if (inherits(resp, "character")) {
    return(resp)
  }

  switch(
    as.character(resp$httpStatus),
    "404" = c(
      "x" = stringr::str_replace(resp$message, "API key .*,", "supplied API key,"),
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

try_resp_body_json <- function(resp) {
  tryCatch(
    resp %>%
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

validate_arg_item <- function(item, call = rlang::caller_env()) {
  if (!rlang::is_scalar_integerish(item)) {
    cli::cli_abort(c("x" = "Argument {.code item} must be an integer.",
                     "i" = "Use {.code trud_items()} to see available items."),
                   call = call)
  }
}

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
    cli::cli_abort(c("x" = "Argument {.code directory} must be a string.",
                     directory_arg_example),
                   call = call)
  }

  if (!dir.exists(directory)) {
    cli::cli_abort(
      message = c(
        "x" = "Argument {.code directory} must be a valid file path.",
        "!" = stringr::str_glue("Directory does not exist: {{.code {directory}}}."),
        directory_arg_example
      ),
      call = call
    )
  }
}

validate_arg_download_file <- function(download_file, call = rlang::caller_env()) {
  valid_download_file_values <- c("archive", "checksum", "signature", "publicKey")

  if (!rlang::is_string(download_file)) {
    cli::cli_abort(c(
      "x" = "Argument {.code download_file} must be a string.",
      "i" = paste0(
        "Valid values: '",
        paste(valid_download_file_values, sep = "", collapse = "', '"),
        "'."
      )
    ),
    call = call)
  }

  rlang::arg_match(download_file,
                   valid_download_file_values,
                   error_call = call)
}

req_user_agent_trud <- function(req) {
  req %>%
    httr2::req_user_agent("trud (http://github.com/rmgpanw/trud)")
}
