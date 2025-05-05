test_that("Expected errors raised for invalid `release` arg with `download_item()`", {
  skip_if_offline()
  expect_error(download_item(394, release = 1),
               "Argument `release` must be a string")

  expect_error(download_item(394, release = "invalid_release_arg"),
               class = "unrecognised_trud_item_release")
})

test_that("", {
  skip_if_offline()
  x <- download_item(394, directory = tempdir())

  expect_true(file.exists(x))

  expect_warning(download_item(394, directory = tempdir()), "already exists in directory")

})
