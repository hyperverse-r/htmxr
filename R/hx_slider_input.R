#' Slider input
#'
#' Creates an `<input type="range">` element with optional htmx attributes.
#' When `label` is provided, the input is wrapped in a `<div>` containing a
#' `<label>` element linked via the `for` attribute.
#'
#' @param id Element id. Also used as `name` by default.
#' @param label Optional label text. When provided, the input is wrapped in a
#'   `<div>` with a `<label>`.
#' @param value Initial value (default `50`).
#' @param min Minimum value (default `0`).
#' @param max Maximum value (default `100`).
#' @param step Step increment (default `1`).
#' @param name Form field name. Defaults to `id`.
#' @param class Optional CSS class(es) for the `<input>` element.
#' @param get URL for `hx-get`.
#' @param post URL for `hx-post`.
#' @param target CSS selector for `hx-target`.
#' @param swap Swap strategy for `hx-swap`.
#' @param trigger Trigger specification for `hx-trigger`.
#' @param indicator CSS selector for `hx-indicator`.
#' @param swap_oob Out-of-band swap targets for `hx-swap-oob`.
#' @param confirm Confirmation message for `hx-confirm`.
#' @param ... Additional HTML attributes passed to the `<input>` element.
#'
#' @return An [htmltools::tags] object.
#'
#' @examples
#' # Simple slider
#' hx_slider_input("bins", label = "Number of bins:", min = 1, max = 50)
#'
#' # Slider with htmx attributes
#' hx_slider_input(
#'   "bins",
#'   label = "Number of bins:",
#'   value = 30, min = 1, max = 50,
#'   get = "/plot",
#'   trigger = "input changed delay:300ms",
#'   target = "#plot"
#' )
#'
#' @export
hx_slider_input <- function(
  id,
  label = NULL,
  value = 50,
  min = 0,
  max = 100,
  step = 1,
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
  input <- tags$input(
    type = "range",
    id = id,
    name = name,
    value = as.character(value),
    min = as.character(min),
    max = as.character(max),
    step = as.character(step),
    class = class,
    ...
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
      input
    )
  } else {
    input
  }
}
