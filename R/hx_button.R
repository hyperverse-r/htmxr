#' Button element
#'
#' Creates a `<button>` element with optional htmx attributes.
#'
#' @param label Button label (text or HTML content).
#' @param id Optional element id.
#' @param class Optional CSS class(es).
#' @param get URL for `hx-get`.
#' @param post URL for `hx-post`.
#' @param target CSS selector for `hx-target`.
#' @param swap Swap strategy for `hx-swap`.
#' @param trigger Trigger specification for `hx-trigger`.
#' @param indicator CSS selector for `hx-indicator`.
#' @param swap_oob Out-of-band swap targets for `hx-swap-oob`.
#' @param confirm Confirmation message for `hx-confirm`.
#' @param ... Additional HTML attributes passed to the `<button>` element.
#'
#' @return An [htmltools::tags] object.
#'
#' @examples
#' # Simple button
#' hx_button("Click me")
#'
#' # Button with htmx GET request
#' hx_button("Load data", get = "/api/data", target = "#result")
#'
#' # Button with confirmation
#' hx_button("Delete", post = "/api/delete", confirm = "Are you sure?")
#'
#' @export
hx_button <- function(
  label,
  id = NULL,
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
  tags$button(label, type = "button", id = id, class = class, ...) |>
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
}
