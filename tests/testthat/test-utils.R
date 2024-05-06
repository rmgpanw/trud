test_that("get_trud_api_key() raises error with non-string argument", {
  expect_error(get_trud_api_key(1),
               "Argument `TRUD_API_KEY` must either be a string or `NULL`")
})
