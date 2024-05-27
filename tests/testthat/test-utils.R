test_that("get_trud_api_key() raises error with non-string argument", {
  expect_error(get_trud_api_key(1),
               "Argument `TRUD_API_KEY` must either be a string or `NULL`")
})

test_that("get_trud_api_key() raises error with missing API key", {
  expect_error(get_trud_api_key(TRUD_API_KEY = "MISSING_API_KEY"),
               "Can't find NHS TRUD API key")
})

test_that("get_item_metadata() raises error for expired API key", {
  skip_if_offline()
  expect_error(
    withr::with_envvar(
      new = c("EXPIRED_API_KEY" = "e963cc518cc41500e1a8940a93ffc3c0915e2983"),
      {
        get_item_metadata(1799, TRUD_API_KEY = "EXPIRED_API_KEY")
      }
    ),
    "UNAUTHORIZED: API access is disabled for the requesting account."
  )
})

test_that("validate_arg_item() raises error with non-integer argument", {
  expect_error(validate_arg_item("1"), "Argument `item` must be an integer.")
})


test_that("validate_arg_directory() raises error with non-string argument",
          {
            expect_error(validate_arg_directory(1),
                         "Argument `directory` must be a string")

            expect_error(
              validate_arg_directory(file.path(tempdir(), "invaliddirectory")),
              "Argument `directory` must be a valid file path."
            )
          })

test_that("trud_error_message() returns expected error messages", {
  response_without_json_body <- httr2::response(
    status_code = 499,
    url = "https://example.com",
    method = "GET",
    headers = list(),
    body = raw()
  )

  expect_match(trud_error_message(response_without_json_body)[2],
               "Is the TRUD website down?")

  example_response <- httr2::response(
    status_code = 200,
    url = "https://example.com",
    method = "GET",
    headers = list(),
    body = raw()
  )

  with_mocked_bindings({
    status_400_result <- trud_error_message(example_response)

    expect_match(status_400_result, "invalid API key")
  }, try_resp_body_json = function(...) {
    list(httpStatus = 400)
  })

  with_mocked_bindings({
    status_404_result <- trud_error_message(example_response)

    expect_match(
      status_404_result[1],
      "Either this item number does not exist, or you are not subscribed to it"
    )
  }, try_resp_body_json = function(...) {
    list(httpStatus = 404)
  })

})

test_that("validate_arg_download_file() raises error with non-string argument",
          {
            expect_error(validate_arg_download_file(1),
                         "Argument `download_file` must be a string.")
          })
