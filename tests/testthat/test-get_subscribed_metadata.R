test_that("`get_subscribed_metadata()` runs as expected", {
  with_mocked_bindings(
    get_item_metadata = function(...)
      list(
        apiVersion = "",
        releases = list(
          item1 = list(id = "item1"),
          item2 = list(id = "item2")
        ),
        httpStatus = 200,
        message = "OK"
      ),
    get_trud_api_key = function(...) NULL,
    code = {
      result <- get_subscribed_metadata()
    }
  )

  expect_s3_class(result, "tbl")

  expect_identical(names(result), c("item_number", "item_name", "metadata"))

  # Tests to be run with valid API key, with at least one subscribed item
  expect_true(nrow(result) > 0)
})

test_that("`get_subscribed_metadata()` runs without error", {
  skip_if_offline()
  skip_if(condition = identical(Sys.getenv("TRUD_API_KEY"), ""))
  skip_if(condition = identical(Sys.getenv("PKG_CHECK"), "true")) # see pkgcheck.yaml
  expect_true(is.data.frame(get_subscribed_metadata()))
})
