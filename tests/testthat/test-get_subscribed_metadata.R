test_that("`get_subscribed_metadata()` runs without error", {
  skip_if_offline()

  result <- get_subscribed_metadata()

  expect_s3_class(result, "tbl")

  expect_identical(names(result), c("item_number", "item_name", "metadata"))

  # Tests to be run with valid API key, with at least one subscribed item
  expect_true(nrow(result) > 0)
})
