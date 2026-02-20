test_that("hx_serve_assets() exists and has the expected signature", {
  expect_true(is.function(hx_serve_assets))
  args <- formals(hx_serve_assets)
  expect_true("api" %in% names(args))
})
