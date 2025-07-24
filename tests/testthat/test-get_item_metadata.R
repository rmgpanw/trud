test_that("Error raised with invalid `latest_only` arg value for `get_item_metadata()`", {
  with_mocked_bindings(
    get_trud_api_key = function(...) NULL,
    expect_error(
      get_item_metadata(394, latest_only = "TRUE"),
      "Argument `latest_only` must be either `TRUE` or `FALSE`"
    )
  )
})

test_that("`get_item_metadata()` runs with mocked API response", {
  with_mocked_bindings(
    request_item_metadata = function(...)
      list(
        apiVersion = "",
        releases = list(list(id = "item1"), list(id = "item2")),
        httpStatus = 200,
        message = "OK"
      ),
    get_trud_api_key = function(...) NULL,
    code = {
      item_metadata_394 <- get_item_metadata(394)

      expect_equal(names(item_metadata_394$releases), c("item1", "item2"))
    }
  )
})

test_that("`get_item_metadata()` returns result with expected format", {
  skip_if_offline()
  skip_if(condition = identical(Sys.getenv("TRUD_API_KEY"), ""))
  skip_if(condition = identical(Sys.getenv("PKG_CHECK"), "true")) # see pkgcheck.yaml

  metadata_394 <- tryCatch(
    get_item_metadata(394, latest_only = TRUE),
    httr2_http_404 = \(cnd) "NOT_SUBSCRIBED"
  )

  skip_if(condition = identical(metadata_394, "NOT_SUBSCRIBED"),
          message = "Skipping tests - valid TRUD API key detected, however this account is not subscribed to item 394 (required for these tests).")

  expect_equal(
    names(metadata_394),
    c("apiVersion", "releases", "httpStatus", "message")
  )

  expect_equal(length(metadata_394$releases), 1L)

  expect_equal(names(metadata_394$releases), metadata_394$releases[[1]]$id)
})

test_that(
  "Expected request URL is generated for `get_item_metadata()`, with `latest_only = TRUE` and `latest_only = FALSE`",
  {
    skip_if_offline()
    skip_if(condition = identical(Sys.getenv("TRUD_API_KEY"), ""))
    skip_if(condition = identical(Sys.getenv("PKG_CHECK"), "true")) # see pkgcheck.yaml
    # latest_only = TRUE
    withr::with_envvar(new = c("EXPIRED_API_KEY" = "e963cc518cc41500e1a8940a93ffc3c0915e2983"), {
      tryCatch({
        metadata_394_lastet_only <- get_item_metadata(394, TRUD_API_KEY = "EXPIRED_API_KEY", latest_only = TRUE)
      },
      error = \(cnd) invisible())
      req <- httr2::last_request()
    })

    expect_equal(
      req$url,
      "https://isd.digital.nhs.uk/trud/api/v1/keys/e963cc518cc41500e1a8940a93ffc3c0915e2983/items/394/releases?latest"
    )

    # latest_only = FALSE
    withr::with_envvar(new = c("EXPIRED_API_KEY" = "e963cc518cc41500e1a8940a93ffc3c0915e2983"), {
      tryCatch({
        metadata_394_lastet_only <- get_item_metadata(394, TRUD_API_KEY = "EXPIRED_API_KEY", latest_only = FALSE)
      },
      error = \(cnd) invisible())
      req <- httr2::last_request()
    })

    expect_equal(
      req$url,
      "https://isd.digital.nhs.uk/trud/api/v1/keys/e963cc518cc41500e1a8940a93ffc3c0915e2983/items/394/releases"
    )
  }
)

test_that("get_item_metadata() raises error for expired API key", {
  skip_if_offline()
  skip_if(condition = identical(Sys.getenv("TRUD_API_KEY"), ""))
  skip_if(condition = identical(Sys.getenv("PKG_CHECK"), "true")) # see pkgcheck.yaml
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
