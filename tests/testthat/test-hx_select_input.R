test_that("hx_select_input() without label returns a select tag", {
  result <- hx_select_input("cut", choices = c("Fair", "Good"))
  expect_equal(result$name, "select")
})

test_that("hx_select_input() with label wraps in div with label", {
  result <- hx_select_input("cut", label = "Cut:", choices = c("Fair", "Good"))
  expect_equal(result$name, "div")
  rendered <- as.character(result)
  expect_match(rendered, "<label", fixed = TRUE)
  expect_match(rendered, "Cut:", fixed = TRUE)
  expect_match(rendered, 'for="cut"', fixed = TRUE)
})

test_that("hx_select_input() sets id and name", {
  result <- hx_select_input("cut", choices = c("Fair"))
  expect_equal(result$attribs$id, "cut")
  expect_equal(result$attribs$name, "cut")
})

test_that("hx_select_input() name defaults to id", {
  result <- hx_select_input("cut", choices = c("Fair"))
  expect_equal(result$attribs$name, "cut")
})

test_that("hx_select_input() allows custom name", {
  result <- hx_select_input("cut", choices = c("Fair"), name = "diamond_cut")
  expect_equal(result$attribs$name, "diamond_cut")
})

test_that("hx_select_input() sets class", {
  result <- hx_select_input("cut", choices = c("Fair"), class = "form-select")
  expect_equal(result$attribs$class, "form-select")
})

test_that("hx_select_input() generates options from unnamed vector", {
  result <- hx_select_input("cut", choices = c("Fair", "Good", "Ideal"))
  rendered <- as.character(result)
  expect_match(rendered, 'value="Fair"', fixed = TRUE)
  expect_match(rendered, 'value="Good"', fixed = TRUE)
  expect_match(rendered, 'value="Ideal"', fixed = TRUE)
  expect_match(rendered, ">Fair<", fixed = TRUE)
  expect_match(rendered, ">Good<", fixed = TRUE)
})

test_that("hx_select_input() generates options from named vector", {
  result <- hx_select_input("cut", choices = c("All" = "all", "Fair" = "Fair"))
  rendered <- as.character(result)
  expect_match(rendered, 'value="all"', fixed = TRUE)
  expect_match(rendered, ">All<", fixed = TRUE)
  expect_match(rendered, 'value="Fair"', fixed = TRUE)
  expect_match(rendered, ">Fair<", fixed = TRUE)
})

test_that("hx_select_input() marks selected option", {
  result <- hx_select_input("cut", choices = c("All" = "all", "Fair"), selected = "all")
  rendered <- as.character(result)
  expect_match(rendered, 'value="all" selected', fixed = TRUE)
  expect_no_match(rendered, 'value="Fair" selected')
})

test_that("hx_select_input() multiple = TRUE adds multiple attribute", {
  result <- hx_select_input("cut", choices = c("Fair", "Good"), multiple = TRUE)
  rendered <- as.character(result)
  expect_match(rendered, "multiple", fixed = TRUE)
})

test_that("hx_select_input() multiple = FALSE omits multiple attribute", {
  result <- hx_select_input("cut", choices = c("Fair", "Good"), multiple = FALSE)
  expect_null(result$attribs$multiple)
})

test_that("hx_select_input() adds htmx attributes when specified", {
  result <- hx_select_input(
    "cut",
    choices = c("Fair"),
    get = "/rows",
    target = "#tbody",
    trigger = "change"
  )
  expect_equal(result$attribs$`hx-get`, "/rows")
  expect_equal(result$attribs$`hx-target`, "#tbody")
  expect_equal(result$attribs$`hx-trigger`, "change")
})

test_that("hx_select_input() omits htmx attributes when not specified", {
  result <- hx_select_input("cut", choices = c("Fair"))
  expect_null(result$attribs$`hx-get`)
  expect_null(result$attribs$`hx-post`)
  expect_null(result$attribs$`hx-target`)
})

test_that("hx_select_input() passes extra attributes via ...", {
  result <- hx_select_input("cut", choices = c("Fair"), `data-custom` = "val")
  expect_equal(result$attribs$`data-custom`, "val")
})
