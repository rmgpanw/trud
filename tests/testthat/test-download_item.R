test_that("Expected errors raised for invalid `release` arg with `download_item()`", {
  expect_error(download_item(394, release = 1),
               "Argument `release` must be a string")

  skip_if_offline()
  expect_error(download_item(394, release = "invalid_release_arg"),
               "See available releases with `get_item_metadata\\(item = 394, latest_only = FALSE\\)`")
})
