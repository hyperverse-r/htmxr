#' Add htmx attributes to any HTML tag
#'
#' A generic modifier that appends htmx attributes to an existing
#' [htmltools::tags] object. Works with any HTML element.
#'
#' @param tag An [htmltools::tags] object to modify.
#' @param get URL for `hx-get`.
#' @param post URL for `hx-post`.
#' @param target CSS selector for `hx-target`.
#' @param swap Swap strategy for `hx-swap`.
#' @param trigger Trigger specification for `hx-trigger`.
#' @param indicator CSS selector for `hx-indicator`.
#' @param swap_oob Out-of-band swap targets for `hx-swap-oob`.
#' @param confirm Confirmation message for `hx-confirm`.
#'
#' @return The input `tag` with htmx attributes appended.
#'
#' @examples
#' tags$div(id = "plot") |>
#'   hx_set(get = "/plot", trigger = "load", target = "#plot", swap = "innerHTML")
#'
#' hx_set(
#'   tags$div(id = "result", class = "container"),
#'   get = "/data",
#'   trigger = "load"
#' )
#'
#' @importFrom htmltools tagAppendAttributes
#' @export
hx_set <- function(
  tag,
  get = NULL,
  post = NULL,
  target = NULL,
  swap = NULL,
  trigger = NULL,
  indicator = NULL,
  swap_oob = NULL,
  confirm = NULL
) {
  hx <- hx_attrs(
    get = get,
    post = post,
    target = target,
    swap = swap,
    trigger = trigger,
    indicator = indicator,
    swap_oob = swap_oob,
    confirm = confirm
  )
  do.call(tagAppendAttributes, c(list(tag), hx))
}
