df <- data.frame(
  cut = c("Fair", "Good", "Ideal"),
  price = c(326L, 400L, 500L),
  stringsAsFactors = FALSE
)

# hx_table_rows() ---------------------------------------------------------------

test_that("hx_table_rows() returns a tagList", {
  result <- hx_table_rows(df)
  expect_s3_class(result, "shiny.tag.list")
})

test_that("hx_table_rows() produces one <tr> per row", {
  result <- hx_table_rows(df)
  expect_length(result, nrow(df))
  for (row in result) expect_equal(row$name, "tr")
})

test_that("hx_table_rows() produces one <td> per column", {
  result <- hx_table_rows(df)
  tr <- result[[1]]
  expect_length(tr$children, ncol(df))
  for (cell in tr$children) expect_equal(cell$name, "td")
})

test_that("hx_table_rows() converts values to character", {
  result <- hx_table_rows(df)
  price_cell <- result[[1]]$children[[2]]
  expect_equal(price_cell$children[[1]], "326")
})

test_that("hx_table_rows() columns filters and orders columns", {
  result <- hx_table_rows(df, columns = c("price", "cut"))
  tr <- result[[1]]
  expect_length(tr$children, 2L)
  expect_equal(tr$children[[1]]$children[[1]], "326")
  expect_equal(tr$children[[2]]$children[[1]], "Fair")
})

test_that("hx_table_rows() col_classes adds class to the right <td>", {
  result <- hx_table_rows(df, col_classes = list(price = "text-end"))
  price_cell <- result[[1]]$children[[2]]
  expect_equal(price_cell$attribs$class, "text-end")
  cut_cell <- result[[1]]$children[[1]]
  expect_null(cut_cell$attribs$class)
})

# hx_table() --------------------------------------------------------------------

test_that("hx_table() returns a <table> tag", {
  result <- hx_table(columns = c("cut", "price"))
  expect_equal(result$name, "table")
})

test_that("hx_table() contains a <thead> with correct labels", {
  result <- hx_table(columns = c("cut", "price"))
  thead <- result$children[[1]]
  expect_equal(thead$name, "thead")
  tr <- thead$children[[1]]
  expect_equal(tr$children[[1]]$children[[1]], "cut")
  expect_equal(tr$children[[2]]$children[[1]], "price")
})

test_that("hx_table() col_labels = NULL uses column names", {
  result <- hx_table(columns = c("cut", "price"))
  thead <- result$children[[1]]
  tr <- thead$children[[1]]
  expect_equal(tr$children[[1]]$children[[1]], "cut")
  expect_equal(tr$children[[2]]$children[[1]], "price")
})

test_that("hx_table() col_labels positional replaces all labels", {
  result <- hx_table(columns = c("cut", "price"), col_labels = c("Cut", "Price ($)"))
  thead <- result$children[[1]]
  tr <- thead$children[[1]]
  expect_equal(tr$children[[1]]$children[[1]], "Cut")
  expect_equal(tr$children[[2]]$children[[1]], "Price ($)")
})

test_that("hx_table() col_labels named replaces only specified columns", {
  result <- hx_table(columns = c("cut", "price"), col_labels = c(price = "Price ($)"))
  thead <- result$children[[1]]
  tr <- thead$children[[1]]
  expect_equal(tr$children[[1]]$children[[1]], "cut")
  expect_equal(tr$children[[2]]$children[[1]], "Price ($)")
})

test_that("hx_table() tbody has the provided id", {
  result <- hx_table(columns = c("cut", "price"), id = "tbody")
  tbody <- result$children[[2]]
  expect_equal(tbody$name, "tbody")
  expect_equal(tbody$attribs$id, "tbody")
})

test_that("hx_table() htmx attributes are on <tbody>", {
  result <- hx_table(
    columns = c("cut", "price"),
    get = "/rows",
    trigger = "load",
    swap = "innerHTML"
  )
  tbody <- result$children[[2]]
  expect_equal(tbody$attribs$`hx-get`, "/rows")
  expect_equal(tbody$attribs$`hx-trigger`, "load")
  expect_equal(tbody$attribs$`hx-swap`, "innerHTML")
})

test_that("hx_table() htmx attributes absent when not specified", {
  result <- hx_table(columns = c("cut", "price"))
  tbody <- result$children[[2]]
  expect_null(tbody$attribs$`hx-get`)
  expect_null(tbody$attribs$`hx-post`)
})

test_that("hx_table() class applies to <table>", {
  result <- hx_table(columns = c("cut", "price"), class = "table table-striped")
  expect_equal(result$attribs$class, "table table-striped")
})

test_that("hx_table() thead_class applies to <thead>", {
  result <- hx_table(columns = c("cut", "price"), thead_class = "table-dark")
  thead <- result$children[[1]]
  expect_equal(thead$attribs$class, "table-dark")
})

test_that("hx_table() data = NULL produces empty tbody", {
  result <- hx_table(columns = c("cut", "price"))
  tbody <- result$children[[2]]
  expect_length(tbody$children, 0L)
})

test_that("hx_table() data provided renders rows in tbody", {
  result <- hx_table(columns = c("cut", "price"), data = df)
  tbody <- result$children[[2]]
  expect_length(tbody$children, nrow(df))
  expect_equal(tbody$children[[1]]$name, "tr")
})
