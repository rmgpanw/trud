test_that("`trud_items()` returns a tibble with expected properties", {
  with_mocked_bindings(
    get_trud_items_html = function() rvest::read_html(snapshot_trud_items_html),
    code = {
      trud_items_df <- trud_items()
    }
  )

  expect_true(inherits(trud_items_df, what = "tbl_df"))

  expect_true(identical(names(trud_items_df), c("item_number", "item_name")))

  expect_true(inherits(
    trud_items_df$item_number,
    "integer"
  ))

  expect_true(inherits(
    trud_items_df$item_name,
    "character"
  ))

  expect_identical(
    trud_items_df,
    trud_items_df |>
      dplyr::filter(
        !is.na(item_number) &
          !is.na(item_name)
      )
  )
})

test_that("`trud_items()` runs without error", {
  skip_if_offline()
  skip_if(condition = identical(Sys.getenv("TRUD_API_KEY"), ""))
  skip_if(condition = identical(Sys.getenv("PKG_CHECK"), "true")) # see pkgcheck.yaml
  expect_true(is.data.frame(trud_items()))
})
