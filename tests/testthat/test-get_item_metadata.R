test_that("get_item_metadata() throws error when release_scope argument is invalid", {
  with_mocked_bindings(
    get_trud_api_key = function(...) NULL,
    expect_error(
      get_item_metadata(394, release_scope = "invalid"),
      "`release_scope`.*must be one of"
    )
  )
})

test_that("get_item_metadata() successfully processes mocked API response and names releases", {
  with_mocked_bindings(
    request_item_metadata = function(...) {
      list(
        apiVersion = "",
        releases = list(list(id = "item1"), list(id = "item2")),
        httpStatus = 200,
        message = "OK"
      )
    },
    get_trud_api_key = function(...) NULL,
    code = {
      item_metadata_394 <- get_item_metadata(394)

      expect_equal(names(item_metadata_394$releases), c("item1", "item2"))
    }
  )
})

test_that("get_item_metadata() returns metadata with correct structure and single release when retrieving only the latest release", {
  skip_if_offline()
  skip_if(condition = identical(Sys.getenv("TRUD_API_KEY"), ""))
  skip_if(condition = identical(Sys.getenv("PKG_CHECK"), "true")) # see pkgcheck.yaml

  metadata_394 <- tryCatch(
    get_item_metadata(394, release_scope = "latest"),
    httr2_http_404 = \(cnd) "NOT_SUBSCRIBED"
  )

  skip_if(
    condition = identical(metadata_394, "NOT_SUBSCRIBED"),
    message = "Skipping tests - valid TRUD API key detected, but this account is not subscribed to item 394 ('Community Services Data Set pre-deadline extract XML Schema'). Subscribe at: https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/1/items/394/releases"
  )

  expect_equal(
    names(metadata_394),
    c("apiVersion", "releases", "httpStatus", "message")
  )

  expect_equal(length(metadata_394$releases), 1L)

  expect_equal(names(metadata_394$releases), metadata_394$releases[[1]]$id)
})

test_that("get_item_metadata() constructs correct URLs whether retrieving for all item releases or only the latest release", {
  skip_if_offline()
  skip_if(condition = identical(Sys.getenv("TRUD_API_KEY"), ""))
  skip_if(condition = identical(Sys.getenv("PKG_CHECK"), "true")) # see pkgcheck.yaml
  # release_scope = "latest"
  tryCatch(
    {
      withr::with_envvar(
        c("TRUD_API_KEY" = "e963cc518cc41500e1a8940a93ffc3c0915e2983"),
        {
          metadata_394_latest_only <- get_item_metadata(
            394,
            release_scope = "latest"
          )
        }
      )
    },
    error = \(cnd) invisible()
  )

  req <- httr2::last_request()

  expect_equal(
    req$url,
    "https://isd.digital.nhs.uk/trud/api/v1/keys/e963cc518cc41500e1a8940a93ffc3c0915e2983/items/394/releases?latest"
  )

  # release_scope = "all"
  withr::with_envvar(
    new = c("EXPIRED_API_KEY" = "e963cc518cc41500e1a8940a93ffc3c0915e2983"),
    {
      tryCatch(
        {
          withr::with_envvar(
            c("TRUD_API_KEY" = "e963cc518cc41500e1a8940a93ffc3c0915e2983"),
            {
              metadata_394_latest_only <- get_item_metadata(
                394,
                release_scope = "all"
              )
            }
          )
        },
        error = \(cnd) invisible()
      )
      req <- httr2::last_request()
    }
  )

  expect_equal(
    req$url,
    "https://isd.digital.nhs.uk/trud/api/v1/keys/e963cc518cc41500e1a8940a93ffc3c0915e2983/items/394/releases"
  )
})

test_that("get_item_metadata() throws unauthorized error when API key is expired", {
  skip_if_offline()
  skip_if(condition = identical(Sys.getenv("TRUD_API_KEY"), ""))
  skip_if(condition = identical(Sys.getenv("PKG_CHECK"), "true")) # see pkgcheck.yaml
  expect_error(
    withr::with_envvar(
      new = c("TRUD_API_KEY" = "e963cc518cc41500e1a8940a93ffc3c0915e2983"),
      {
        get_item_metadata(1799)
      }
    ),
    "UNAUTHORIZED: API access is disabled for the requesting account."
  )
})
