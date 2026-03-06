test_that("hx_is_htmx() returns TRUE for htmx request", {
  req <- list(headers = list(`hx-request` = "true"))
  expect_true(hx_is_htmx(req))
})

test_that("hx_is_htmx() returns FALSE without header", {
  req <- list(headers = list())
  expect_false(hx_is_htmx(req))
})

test_that("hx_is_htmx() returns FALSE for wrong header value", {
  req <- list(headers = list(`hx-request` = "false"))
  expect_false(hx_is_htmx(req))
})
