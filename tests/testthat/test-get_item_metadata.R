test_that("Error raised with invalid `latest_only` arg value for `get_item_metadata()`",
          {
            skip_if_offline()
            expect_error(
              get_item_metadata(394, latest_only = "TRUE"),
              "Argument `latest_only` must be either `TRUE` or `FALSE`"
            )
          })

test_that("`get_item_metadata()` returns result with expected format", {
  skip_if_offline()
  metadata_394 <- get_item_metadata(394, latest_only = TRUE)

  expect_equal(names(metadata_394),
               c("apiVersion", "releases", "httpStatus", "message"))

  expect_equal(length(metadata_394$releases), 1L)

  expect_equal(names(metadata_394$releases), metadata_394$releases[[1]]$id)
})

test_that(
  "Expected request URL is generated for `get_item_metadata()`, with `latest_only = TRUE` and `latest_only = FALSE`",
  {
    skip_if_offline()
    # latest_only = TRUE
    withr::with_envvar(new = c("EXPIRED_API_KEY" = "e963cc518cc41500e1a8940a93ffc3c0915e2983"),
                       {
                         try({
                           metadata_394_lastet_only <- get_item_metadata(394, TRUD_API_KEY = "EXPIRED_API_KEY", latest_only = TRUE)
                         })
                         req <- httr2::last_request()
                       })

    expect_equal(
      req$url,
      "https://isd.digital.nhs.uk/trud/api/v1/keys/e963cc518cc41500e1a8940a93ffc3c0915e2983/items/394/releases?latest"
    )

    # latest_only = FALSE
    withr::with_envvar(new = c("EXPIRED_API_KEY" = "e963cc518cc41500e1a8940a93ffc3c0915e2983"),
                       {
                         try({
                           metadata_394_lastet_only <- get_item_metadata(394, TRUD_API_KEY = "EXPIRED_API_KEY", latest_only = FALSE)
                         })
                         req <- httr2::last_request()
                       })

    expect_equal(
      req$url,
      "https://isd.digital.nhs.uk/trud/api/v1/keys/e963cc518cc41500e1a8940a93ffc3c0915e2983/items/394/releases"
    )
  }
)
