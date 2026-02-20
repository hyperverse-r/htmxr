test_that("hx_run_example() without arg returns available examples", {
  result <- suppressMessages(hx_run_example())
  expect_type(result, "character")
  expect_true(length(result) > 0)
  expect_true("hello" %in% result)
})

test_that("hx_run_example() with nonexistent example errors", {
  expect_error(
    hx_run_example("nonexistent_example_xyz"),
    "not found"
  )
})
