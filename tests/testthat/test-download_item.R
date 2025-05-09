test_that("Expected errors raised for invalid `release` arg with `download_item()`", {
  with_mocked_bindings(
    get_trud_api_key = function(...) NULL,
    expect_error(
      download_item(394, release = 1),
      "Argument `release` must be a string"
    )
  )

  with_mocked_bindings(
    get_item_metadata = function(...)
      list(
        apiVersion = "",
        releases = list(item1 = list(id = "id1"), item2 = list(id = "id2")),
        httpStatus = 200,
        message = "OK"
      ),
    get_trud_api_key = function(...) NULL,
    code = {
      expect_error(download_item(394, release = "invalid_release_arg"), class = "unrecognised_trud_item_release")
    }
  )
})

test_that("Warning raised if file to be downloaded already exists locally", {

  archiveFileName <- "download_file.txt"

  file.create(file.path(tempdir(), archiveFileName))

  with_mocked_bindings(
    get_item_metadata = function(...)
      list(
        apiVersion = "",
        releases = list(item1 = list(id = "item1", archiveFileName = archiveFileName), item2 = list(id = "item2")),
        httpStatus = 200,
        message = "OK"
      ),
    request_download_item = function(...) NULL,
    get_trud_api_key = function(...) NULL,
    code = {
      expect_warning(download_item(394, release = "item1", directory = tempdir()), "already exists in directory")
    }
  )
})

test_that("`download_item()` works", {

  archiveFileName_unique <- basename(tempfile())
  archiveFileName_unique_path <- file.path(tempdir(), archiveFileName_unique)

  with_mocked_bindings(
    get_trud_api_key = function(...) NULL,
    get_item_metadata = function(...)
      list(
        apiVersion = "",
        releases = list(
          item1 = list(
            id = "item1",
            archiveFileName = basename(archiveFileName_unique)
          ),
          item2 = list(id = "item2")
        ),
        httpStatus = 200,
        message = "OK"
      ),
    request_download_item = function(...)
      NULL,
    code = {
      expect_equal(download_item(394, release = "item1", directory = tempdir()),
                   archiveFileName_unique_path)
    }
  )

  # Run the following only if online and TRUD API key is available
  skip_if_offline()
  skip_if(condition = identical(Sys.getenv("TRUD_API_KEY"), ""))
  skip_if(condition = identical(Sys.getenv("PKG_CHECK"), "true")) # see pkgcheck.yaml

  x <- download_item(394, directory = tempdir())

  expect_true(file.exists(x))

  expect_warning(download_item(394, directory = tempdir()), "already exists in directory")
})
