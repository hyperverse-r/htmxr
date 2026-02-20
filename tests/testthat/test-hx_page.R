test_that("hx_page() returns a string starting with <!DOCTYPE html>", {
  result <- hx_page(div("hello"))
  expect_type(result, "character")
  expect_length(result, 1)
  expect_true(startsWith(result, "<!DOCTYPE html>"))
})

test_that("hx_page() includes htmx script tag", {
  result <- hx_page(div("hello"))
  expect_match(
    result,
    '<script src="/htmxr/assets/htmx/2.0.8/htmx.min.js"></script>',
    fixed = TRUE
  )
})

test_that("hx_page() uses lang='en' by default", {
  result <- hx_page(div("hello"))
  expect_match(result, 'lang="en"', fixed = TRUE)
})

test_that("hx_page() respects custom lang", {
  result <- hx_page(div("bonjour"), lang = "fr")
  expect_match(result, 'lang="fr"', fixed = TRUE)
})

test_that("hx_page() includes body content", {
  result <- hx_page(div("my content"))
  expect_match(result, "my content", fixed = TRUE)
})
