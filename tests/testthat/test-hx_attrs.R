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
  expect_equal(
    hx_attrs(put = "/items/1"),
    list(`hx-put` = "/items/1")
  )
  expect_equal(
    hx_attrs(patch = "/items/1"),
    list(`hx-patch` = "/items/1")
  )
  expect_equal(
    hx_attrs(delete = "/items/1"),
    list(`hx-delete` = "/items/1")
  )
  expect_equal(
    hx_attrs(params = "none"),
    list(`hx-params` = "none")
  )
  expect_equal(
    hx_attrs(include = "#form"),
    list(`hx-include` = "#form")
  )
  expect_equal(
    hx_attrs(push_url = "true"),
    list(`hx-push-url` = "true")
  )
  expect_equal(
    hx_attrs(select = "#data-table"),
    list(`hx-select` = "#data-table")
  )
  expect_equal(
    hx_attrs(vals = '{"id": 42}'),
    list(`hx-vals` = '{"id": 42}')
  )
  expect_equal(
    hx_attrs(encoding = "multipart/form-data"),
    list(`hx-encoding` = "multipart/form-data")
  )
  expect_equal(
    hx_attrs(headers = '{"X-Custom-Header": "value"}'),
    list(`hx-headers` = '{"X-Custom-Header": "value"}')
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
    put = "/c",
    patch = "/d",
    delete = "/e",
    target = "#f",
    swap = "outerHTML",
    trigger = "click",
    indicator = "#g",
    swap_oob = "true",
    confirm = "Sure?",
    params = "none",
    include = "#form",
    push_url = "true",
    select = "#data-table",
    vals = '{"id": 1}',
    encoding = "multipart/form-data",
    headers = '{"X-Custom": "val"}'
  )
  expect_length(result, 18)
  expect_named(
    result,
    c(
      "hx-get",
      "hx-post",
      "hx-put",
      "hx-patch",
      "hx-delete",
      "hx-target",
      "hx-swap",
      "hx-trigger",
      "hx-indicator",
      "hx-swap-oob",
      "hx-confirm",
      "hx-params",
      "hx-include",
      "hx-push-url",
      "hx-select",
      "hx-vals",
      "hx-encoding",
      "hx-headers"
    )
  )
})
