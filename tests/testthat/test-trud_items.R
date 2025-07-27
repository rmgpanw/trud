test_that("trud_items() returns tibble with correct columns and data types", {
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

test_that("trud_items() warns when no items are found (page structure changed)", {
  # Mock HTML that doesn't contain any TRUD items
  empty_html <- "<html><body><p>No items found</p></body></html>"
  
  with_mocked_bindings(
    get_trud_items_html = function() rvest::read_html(empty_html),
    code = {
      expect_warning(
        result <- trud_items(),
        "No TRUD items found — page structure may have changed"
      )
      expect_equal(nrow(result), 0)
    }
  )
})

test_that("trud_items() warns when HTML structure changes but returns partial results", {
  # Mock HTML that has enough items to avoid the "few items" warning
  partial_html <- '
  <html>
    <body>
      <div class="content">
        <a href="/trud/users/guest/filters/0/categories/1/items/123">Item 1</a>
        <a href="/trud/users/guest/filters/0/categories/1/items/456">Item 2</a>
        <a href="/trud/users/guest/filters/0/categories/1/items/789">Item 3</a>
        <a href="/trud/users/guest/filters/0/categories/1/items/101">Item 4</a>
        <a href="/trud/users/guest/filters/0/categories/1/items/112">Item 5</a>
        <a href="/trud/users/guest/filters/0/categories/1/items/131">Item 6</a>
        <a href="/trud/users/guest/filters/0/categories/1/items/415">Item 7</a>
        <a href="/trud/users/guest/filters/0/categories/1/items/161">Item 8</a>
        <a href="/trud/users/guest/filters/0/categories/1/items/718">Item 9</a>
        <a href="/trud/users/guest/filters/0/categories/1/items/191">Item 10</a>
        <a href="/trud/users/guest/filters/0/categories/1/items/202">Item 11</a>
        <a href="/different/structure/456">Broken Item</a>
      </div>
    </body>
  </html>'
  
  with_mocked_bindings(
    get_trud_items_html = function() rvest::read_html(partial_html),
    code = {
      # Should not warn because enough items were found (>= 10)
      expect_no_warning(result <- trud_items())
      expect_gt(nrow(result), 10)
      expect_true("Item 1" %in% result$item_name)
    }
  )
})

test_that("trud_items() warns when unusually few items are found", {
  # Mock HTML that has only a few items (simulating partial parsing failure)
  few_items_html <- '
  <html>
    <body>
      <div class="content">
        <a href="/trud/users/guest/filters/0/categories/1/items/123">Item 1</a>
        <a href="/trud/users/guest/filters/0/categories/1/items/456">Item 2</a>
      </div>
    </body>
  </html>'
  
  with_mocked_bindings(
    get_trud_items_html = function() rvest::read_html(few_items_html),
    code = {
      expect_warning(
        result <- trud_items(),
        "Unusually few TRUD items found \\(2 items\\)"
      )
      expect_equal(nrow(result), 2)
    }
  )
})

test_that("trud_items() successfully retrieves available items as data frame", {
  skip_if_offline()
  skip_if(condition = identical(Sys.getenv("TRUD_API_KEY"), ""))
  skip_if(condition = identical(Sys.getenv("PKG_CHECK"), "true")) # see pkgcheck.yaml
  expect_true(is.data.frame(trud_items()))
})
