test_that("get_trud_api_key() raises error with non-string argument", {
  expect_error(get_trud_api_key(1),
               "Argument `TRUD_API_KEY` must either be a string or `NULL`")
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
  expect_error(validate_arg_item("1"),
               "Argument `item` must be an integer.")
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
