test_that("`trud_items()` returns a tibble with expected properties", {
  skip_if_offline()
  trud_items_df <- trud_items()

  expect_true(inherits(trud_items_df,
                       what = "tbl_df"))

  expect_true(identical(names(trud_items_df), c("item_number", "item_name")))

  expect_true(inherits(trud_items_df$item_number,
                       "integer"))

  expect_true(inherits(trud_items_df$item_name,
                       "character"))

  expect_identical(trud_items_df,
                   trud_items_df |>
                     dplyr::filter(!is.na(item_number) &
                                     !is.na(item_name)))
})

