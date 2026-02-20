test_that("hx_button() creates a button with type='button'", {
  result <- hx_button("Click")
  expect_equal(result$name, "button")
  expect_equal(result$attribs$type, "button")
  rendered <- as.character(result)
  expect_match(rendered, "Click", fixed = TRUE)
})

test_that("hx_button() includes id when specified", {
  result <- hx_button("Click", id = "btn1")
  expect_equal(result$attribs$id, "btn1")
})

test_that("hx_button() omits id when not specified", {
  result <- hx_button("Click")
  expect_null(result$attribs$id)
})

test_that("hx_button() applies class", {
  result <- hx_button("Click", class = "btn btn-primary")
  expect_equal(result$attribs$class, "btn btn-primary")
})

test_that("hx_button() adds hx-get when specified", {
  result <- hx_button("Load", get = "/api/data")
  expect_equal(result$attribs$`hx-get`, "/api/data")
})

test_that("hx_button() adds multiple htmx attributes", {
  result <- hx_button(
    "Delete",
    post = "/api/delete",
    target = "#list",
    confirm = "Are you sure?"
  )
  expect_equal(result$attribs$`hx-post`, "/api/delete")
  expect_equal(result$attribs$`hx-target`, "#list")
  expect_equal(result$attribs$`hx-confirm`, "Are you sure?")
})

test_that("hx_button() passes extra attributes via ...", {
  result <- hx_button("Click", `data-action` = "submit", disabled = NA)
  expect_equal(result$attribs$`data-action`, "submit")
})
