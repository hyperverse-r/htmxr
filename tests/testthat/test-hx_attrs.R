test_that("hx_attrs() without args returns empty list", {
  result <- hx_attrs()
  expect_length(result, 0)
  expect_type(result, "list")
})

test_that("hx_attrs() maps R params to hx-* attributes", {
  expect_equal(
    hx_attrs(get = "/foo"),
    list(`hx-get` = "/foo")
  )
  expect_equal(
    hx_attrs(post = "/bar"),
    list(`hx-post` = "/bar")
  )
  expect_equal(
    hx_attrs(target = "#result"),
    list(`hx-target` = "#result")
  )
  expect_equal(
    hx_attrs(swap = "innerHTML"),
    list(`hx-swap` = "innerHTML")
  )
  expect_equal(
    hx_attrs(trigger = "click"),
    list(`hx-trigger` = "click")
  )
  expect_equal(
    hx_attrs(indicator = "#spinner"),
    list(`hx-indicator` = "#spinner")
  )
  expect_equal(
    hx_attrs(swap_oob = "true"),
    list(`hx-swap-oob` = "true")
  )
  expect_equal(
    hx_attrs(confirm = "Are you sure?"),
    list(`hx-confirm` = "Are you sure?")
  )
})

test_that("hx_attrs() drops NULL values", {
  result <- hx_attrs(get = "/foo", post = NULL, target = "#bar")
  expect_equal(result, list(`hx-get` = "/foo", `hx-target` = "#bar"))
  expect_false("hx-post" %in% names(result))
})

test_that("hx_attrs() with all params returns all attributes", {
  result <- hx_attrs(
    get = "/a",
    post = "/b",
    target = "#c",
    swap = "outerHTML",
    trigger = "click",
    indicator = "#d",
    swap_oob = "true",
    confirm = "Sure?"
  )
  expect_length(result, 8)
  expect_named(result, c(
    "hx-get", "hx-post", "hx-target", "hx-swap",
    "hx-trigger", "hx-indicator", "hx-swap-oob", "hx-confirm"
  ))
})
