test_that("hx_set() returns tag unchanged when no htmx params given", {
  tag <- tags$div(id = "foo")
  result <- hx_set(tag)
  expect_equal(result$attribs$id, "foo")
  expect_null(result$attribs[["hx-get"]])
})

test_that("hx_set() preserves existing attributes", {
  tag <- tags$div(id = "foo", class = "bar", `data-x` = "1")
  result <- hx_set(tag, get = "/api")
  expect_equal(result$attribs$id, "foo")
  expect_equal(result$attribs$class, "bar")
  expect_equal(result$attribs[["data-x"]], "1")
  expect_equal(result$attribs[["hx-get"]], "/api")
})

test_that("hx_set() sets hx-get", {
  result <- hx_set(tags$div(), get = "/api")
  expect_equal(result$attribs[["hx-get"]], "/api")
})

test_that("hx_set() sets hx-post", {
  result <- hx_set(tags$div(), post = "/submit")
  expect_equal(result$attribs[["hx-post"]], "/submit")
})

test_that("hx_set() sets hx-target", {
  result <- hx_set(tags$div(), target = "#result")
  expect_equal(result$attribs[["hx-target"]], "#result")
})

test_that("hx_set() sets hx-swap", {
  result <- hx_set(tags$div(), swap = "outerHTML")
  expect_equal(result$attribs[["hx-swap"]], "outerHTML")
})

test_that("hx_set() sets hx-trigger", {
  result <- hx_set(tags$div(), trigger = "load")
  expect_equal(result$attribs[["hx-trigger"]], "load")
})

test_that("hx_set() sets hx-indicator", {
  result <- hx_set(tags$div(), indicator = "#spinner")
  expect_equal(result$attribs[["hx-indicator"]], "#spinner")
})

test_that("hx_set() sets hx-swap-oob", {
  result <- hx_set(tags$div(), swap_oob = "#oob")
  expect_equal(result$attribs[["hx-swap-oob"]], "#oob")
})

test_that("hx_set() sets hx-confirm", {
  result <- hx_set(tags$div(), confirm = "Are you sure?")
  expect_equal(result$attribs[["hx-confirm"]], "Are you sure?")
})

test_that("hx_set() sets multiple htmx attributes and drops NULL", {
  result <- hx_set(
    tags$div(),
    get = "/api",
    target = "#out",
    trigger = "load",
    swap = "innerHTML",
    post = NULL
  )
  expect_equal(result$attribs[["hx-get"]], "/api")
  expect_equal(result$attribs[["hx-target"]], "#out")
  expect_equal(result$attribs[["hx-trigger"]], "load")
  expect_equal(result$attribs[["hx-swap"]], "innerHTML")
  expect_null(result$attribs[["hx-post"]])
})

test_that("hx_set() works with pipe operator", {
  result <- tags$span(id = "x") |>
    hx_set(get = "/data", trigger = "load")
  expect_equal(result$attribs$id, "x")
  expect_equal(result$attribs[["hx-get"]], "/data")
  expect_equal(result$attribs[["hx-trigger"]], "load")
})

test_that("hx_set() works on various tag types", {
  for (tag_fn in list(tags$div, tags$span, tags$p, tags$form, tags$button)) {
    result <- hx_set(tag_fn(), get = "/x")
    expect_equal(result$attribs[["hx-get"]], "/x")
  }
})

test_that("hx_set() produces correct HTML output", {
  html <- as.character(
    tags$div(id = "plot", class = "text-center") |>
      hx_set(
        get = "/plot",
        trigger = "load",
        target = "#plot",
        swap = "innerHTML"
      )
  )
  expect_match(html, 'hx-get="/plot"')
  expect_match(html, 'hx-trigger="load"')
  expect_match(html, 'hx-target="#plot"')
  expect_match(html, 'hx-swap="innerHTML"')
  expect_match(html, 'id="plot"')
  expect_match(html, 'class="text-center"')
})
