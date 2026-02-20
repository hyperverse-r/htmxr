test_that("hx_slider_input() without label returns an input tag", {
  result <- hx_slider_input("myid")
  expect_equal(result$name, "input")
  expect_equal(result$attribs$type, "range")
})

test_that("hx_slider_input() with label wraps in div with label", {
  result <- hx_slider_input("myid", label = "My Label")
  expect_equal(result$name, "div")
  rendered <- as.character(result)
  expect_match(rendered, "<label", fixed = TRUE)
  expect_match(rendered, "My Label", fixed = TRUE)
  expect_match(rendered, 'for="myid"', fixed = TRUE)
})

test_that("hx_slider_input() sets id, name, value, min, max, step", {
  result <- hx_slider_input("sid", value = 30, min = 5, max = 80, step = 2)
  expect_equal(result$attribs$id, "sid")
  expect_equal(result$attribs$name, "sid")
  expect_equal(result$attribs$value, "30")
  expect_equal(result$attribs$min, "5")
  expect_equal(result$attribs$max, "80")
  expect_equal(result$attribs$step, "2")
})

test_that("hx_slider_input() name defaults to id", {
  result <- hx_slider_input("foo")
  expect_equal(result$attribs$name, "foo")
})

test_that("hx_slider_input() allows custom name", {
  result <- hx_slider_input("foo", name = "bar")
  expect_equal(result$attribs$name, "bar")
})

test_that("hx_slider_input() adds htmx attributes when specified", {
  result <- hx_slider_input(
    "sid",
    get = "/data",
    target = "#result",
    trigger = "change"
  )
  expect_equal(result$attribs$`hx-get`, "/data")
  expect_equal(result$attribs$`hx-target`, "#result")
  expect_equal(result$attribs$`hx-trigger`, "change")
})

test_that("hx_slider_input() omits htmx attributes when not specified", {
  result <- hx_slider_input("sid")
  expect_null(result$attribs$`hx-get`)
  expect_null(result$attribs$`hx-post`)
  expect_null(result$attribs$`hx-target`)
})

test_that("hx_slider_input() passes extra attributes via ...", {
  result <- hx_slider_input("sid", `data-custom` = "val")
  expect_equal(result$attribs$`data-custom`, "val")
})
