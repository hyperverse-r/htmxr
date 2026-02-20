#' Internal helper: convert R parameters to hx-* attributes
#'
#' Returns a named list suitable for splicing into htmltools tag functions.
#' NULL values are dropped.
#' @noRd
hx_attrs <- function(
  get = NULL,
  post = NULL,
  target = NULL,
  swap = NULL,
  trigger = NULL,
  indicator = NULL,
  swap_oob = NULL,
  confirm = NULL
) {
  attrs <- list(
    `hx-get` = get,
    `hx-post` = post,
    `hx-target` = target,
    `hx-swap` = swap,
    `hx-trigger` = trigger,
    `hx-indicator` = indicator,
    `hx-swap-oob` = swap_oob,
    `hx-confirm` = confirm
  )
  attrs[!vapply(attrs, is.null, logical(1))]
}
