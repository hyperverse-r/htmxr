#' Table rows fragment
#'
#' Converts a data frame into a `tagList` of `<tr>` elements, one per row.
#' Designed to be used as a fragment endpoint response — the output replaces
#' a `<tbody>` via htmx swap.
#'
#' @param data A data frame.
#' @param columns Character vector of column names to include (and their order).
#'   If `NULL`, all columns are used.
#' @param col_classes Named list of CSS classes to add to `<td>` elements,
#'   keyed by column name. Example: `list(price = "text-end fw-bold")`.
#'
#' @return A [htmltools::tagList] of `<tr>` tags.
#'
#' @examples
#' df <- data.frame(cut = c("Fair", "Good"), price = c(326L, 400L))
#' hx_table_rows(df, columns = c("cut", "price"))
#'
#' # With CSS classes on specific columns
#' hx_table_rows(df, col_classes = list(price = "text-end fw-bold"))
#'
#' @export
hx_table_rows <- function(data, columns = NULL, col_classes = NULL) {
  if (!is.null(columns)) data <- data[, columns, drop = FALSE]

  do.call(tagList, lapply(seq_len(nrow(data)), function(i) {
    row <- data[i, , drop = FALSE]
    cells <- lapply(names(row), function(col) {
      tags$td(class = col_classes[[col]], as.character(row[[col]]))
    })
    do.call(tags$tr, cells)
  }))
}

#' Table with htmx-powered tbody
#'
#' Builds a complete `<table>` element with a `<thead>` and a `<tbody>`.
#' htmx attributes are applied to the `<tbody>`, making it the swap target.
#' When `data` is `NULL` (the default), the `<tbody>` is empty and its content
#' is loaded lazily via htmx (e.g. `trigger = "load"`).
#'
#' @param columns Character vector of column names to display. Defines the
#'   `<thead>` structure (required).
#' @param data Optional data frame. If provided, rows are rendered in the
#'   `<tbody>` via [hx_table_rows()]. If `NULL`, the `<tbody>` is empty.
#' @param id `id` attribute applied to the `<tbody>`.
#' @param col_labels Labels for the `<thead>`. If `NULL`, column names are used
#'   as-is. Can be a named vector (`c(price = "Price ($)")`) to override
#'   specific columns, or an unnamed positional vector to replace all labels.
#' @param col_classes Named list of CSS classes for `<td>` cells, passed to
#'   [hx_table_rows()] when `data` is provided.
#' @param class CSS class(es) for the `<table>` element.
#' @param thead_class CSS class(es) for the `<thead>` element.
#' @param get URL for `hx-get` (applied to `<tbody>`).
#' @param post URL for `hx-post` (applied to `<tbody>`).
#' @param target CSS selector for `hx-target` (applied to `<tbody>`).
#' @param swap Swap strategy for `hx-swap` (applied to `<tbody>`).
#' @param trigger Trigger specification for `hx-trigger` (applied to `<tbody>`).
#' @param indicator CSS selector for `hx-indicator` (applied to `<tbody>`).
#' @param swap_oob Out-of-band swap targets for `hx-swap-oob` (applied to `<tbody>`).
#' @param confirm Confirmation message for `hx-confirm` (applied to `<tbody>`).
#' @param ... Additional HTML attributes passed to the `<table>` element.
#'
#' @return An [htmltools::tags] object (`<table>`).
#'
#' @examples
#' # Lazy-load table (empty tbody, content loaded on trigger)
#' hx_table(
#'   columns = c("cut", "color", "price"),
#'   col_labels = c("Cut", "Color", "Price"),
#'   id = "tbody",
#'   get = "/rows",
#'   trigger = "load",
#'   swap = "innerHTML"
#' )
#'
#' # Table with data pre-rendered
#' df <- data.frame(cut = c("Fair", "Good"), price = c(326L, 400L))
#' hx_table(columns = c("cut", "price"), data = df)
#'
#' @export
hx_table <- function(
  columns,
  data = NULL,
  id = NULL,
  col_labels = NULL,
  col_classes = NULL,
  class = NULL,
  thead_class = NULL,
  get = NULL,
  post = NULL,
  target = NULL,
  swap = NULL,
  trigger = NULL,
  indicator = NULL,
  swap_oob = NULL,
  confirm = NULL,
  ...
) {
  # Resolve column labels
  labels <- columns
  if (!is.null(col_labels)) {
    if (!is.null(names(col_labels))) {
      labels[match(names(col_labels), columns)] <- col_labels
    } else {
      labels <- col_labels
    }
  }

  # thead
  header_cells <- lapply(labels, tags$th)
  thead <- tags$thead(class = thead_class, do.call(tags$tr, header_cells))

  # tbody
  hx <- hx_attrs(get, post, target, swap, trigger, indicator, swap_oob, confirm)
  rows <- if (!is.null(data)) hx_table_rows(data, columns = columns, col_classes = col_classes) else list()
  tbody <- do.call(tags$tbody, c(list(id = id), hx, rows))

  # table
  do.call(tags$table, c(list(class = class), list(thead, tbody), list(...)))
}
