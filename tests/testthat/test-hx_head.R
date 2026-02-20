test_that("hx_head() returns an object of class hx_head", {
  result <- hx_head(title = "Foo")
  expect_s3_class(result, "hx_head")
})

test_that("hx_head() contains a title tag", {
  result <- hx_head(title = "Foo")
  rendered <- as.character(htmltools::tagList(result))
  expect_match(rendered, "<title>Foo</title>", fixed = TRUE)
})

test_that("hx_head() includes extra elements", {
  result <- hx_head(
    tags$link(rel = "stylesheet", href = "/style.css"),
    title = "Test"
  )
  rendered <- as.character(htmltools::tagList(result))
  expect_match(rendered, "style.css", fixed = TRUE)
})

test_that("hx_head() integrates with hx_page()", {
  page <- hx_page(
    hx_head(
      tags$link(rel = "stylesheet", href = "/custom.css"),
      title = "My Page"
    ),
    div("body content")
  )
  expect_match(page, "<title>My Page</title>", fixed = TRUE)
  expect_match(page, "custom.css", fixed = TRUE)
  expect_match(page, "body content", fixed = TRUE)
})
