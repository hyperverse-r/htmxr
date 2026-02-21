#' Select input
#'
#' Creates a `<select>` element with optional htmx attributes.
#' When `label` is provided, the input is wrapped in a `<div>` containing a
#' `<label>` element linked via the `for` attribute.
#'
#' @param id Element id. Also used as `name` by default.
#' @param label Optional label text. When provided, the input is wrapped in a
#'   `<div>` with a `<label>`.
#' @param choices Named or unnamed character vector of choices. If unnamed,
#'   values are used as labels. If named, names are used as labels and values
#'   as option values (same convention as Shiny).
#' @param selected Optional value(s) to pre-select.
#' @param multiple Logical. If `TRUE`, adds the `multiple` attribute to allow
#'   multi-selection.
#' @param name Form field name. Defaults to `id`.
#' @param class Optional CSS class(es) for the `<select>` element.
#' @param get URL for `hx-get`.
#' @param post URL for `hx-post`.
#' @param target CSS selector for `hx-target`.
#' @param swap Swap strategy for `hx-swap`.
#' @param trigger Trigger specification for `hx-trigger`.
#' @param indicator CSS selector for `hx-indicator`.
#' @param swap_oob Out-of-band swap targets for `hx-swap-oob`.
#' @param confirm Confirmation message for `hx-confirm`.
#' @param ... Additional HTML attributes passed to the `<select>` element.
#'
#' @return An [htmltools::tags] object.
#'
#' @examples
#' # Simple select without label
#' hx_select_input("cut", choices = c("Fair", "Good", "Ideal"))
#'
#' # Select with label and named choices
#' hx_select_input(
#'   "cut",
#'   label = "Filter by cut:",
#'   choices = c("All" = "all", "Fair", "Good", "Ideal"),
#'   selected = "all"
#' )
#'
#' # Select with htmx attributes
#' hx_select_input(
#'   "cut",
#'   label = "Filter by cut:",
#'   choices = c("All" = "all", "Fair", "Good"),
#'   get = "/rows",
#'   trigger = "change",
#'   target = "#tbody"
#' )
#'
#' @export
hx_select_input <- function(
  id,
  label = NULL,
  choices,
  selected = NULL,
  multiple = FALSE,
  name = id,
  class = NULL,
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
  if (is.null(names(choices))) names(choices) <- as.character(choices)
  blank <- names(choices) == ""
  names(choices)[blank] <- as.character(choices)[blank]

  options_tags <- mapply(
    function(lbl, val) {
      opt_attrs <- list(value = val)
      if (!is.null(selected) && val %in% as.character(selected)) {
        opt_attrs$selected <- NA
      }
      do.call(tags$option, c(opt_attrs, list(lbl)))
    },
    names(choices),
    as.character(choices),
    SIMPLIFY = FALSE,
    USE.NAMES = FALSE
  )

  select_tag <- do.call(
    tags$select,
    c(
      list(
        id = id,
        name = name,
        class = class,
        multiple = if (multiple) NA else NULL
      ),
      options_tags,
      list(...)
    )
  ) |>
    hx_set(
      get = get,
      post = post,
      target = target,
      swap = swap,
      trigger = trigger,
      indicator = indicator,
      swap_oob = swap_oob,
      confirm = confirm
    )

  if (!is.null(label)) {
    tags$div(
      tags$label(`for` = id, label),
      select_tag
    )
  } else {
    select_tag
  }
}
