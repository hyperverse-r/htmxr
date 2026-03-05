test_that("hx_button() creates a button with type='button'", {
  result <- hx_button("btn1", "Click")
  expect_equal(result$name, "button")
  expect_equal(result$attribs$type, "button")
  rendered <- as.character(result)
  expect_match(rendered, "Click", fixed = TRUE)
})

test_that("hx_button() sets id", {
  result <- hx_button("btn1", "Click")
  expect_equal(result$attribs$id, "btn1")
})

test_that("hx_button() label defaults to NULL", {
  result <- hx_button("btn1")
  expect_null(result$children[[1]])
})

test_that("hx_button() applies class", {
  result <- hx_button("btn1", "Click", class = "btn btn-primary")
  expect_equal(result$attribs$class, "btn btn-primary")
})

test_that("hx_button() adds hx-get when specified", {
  result <- hx_button("btn1", "Load", get = "/api/data")
  expect_equal(result$attribs$`hx-get`, "/api/data")
})

test_that("hx_button() adds multiple htmx attributes", {
  result <- hx_button(
    "del-btn",
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
  result <- hx_button("btn1", "Click", `data-action` = "submit", disabled = NA)
  expect_equal(result$attribs$`data-action`, "submit")
})
