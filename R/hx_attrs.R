#' Internal helper: convert R parameters to hx-* attributes
#'
#' Returns a named list suitable for splicing into htmltools tag functions.
#' NULL values are dropped.
#' @noRd
hx_attrs <- function(
  get = NULL,
  post = NULL,
  put = NULL,
  patch = NULL,
  delete = NULL,
  target = NULL,
  swap = NULL,
  trigger = NULL,
  indicator = NULL,
  swap_oob = NULL,
  confirm = NULL,
  params = NULL,
  include = NULL,
  push_url = NULL,
  select = NULL,
  vals = NULL
) {
  attrs <- list(
    `hx-get` = get,
    `hx-post` = post,
    `hx-put` = put,
    `hx-patch` = patch,
    `hx-delete` = delete,
    `hx-target` = target,
    `hx-swap` = swap,
    `hx-trigger` = trigger,
    `hx-indicator` = indicator,
    `hx-swap-oob` = swap_oob,
    `hx-confirm` = confirm,
    `hx-params` = params,
    `hx-include` = include,
    `hx-push-url` = push_url,
    `hx-select` = select,
    `hx-vals` = vals
  )
  attrs[!vapply(attrs, is.null, logical(1))]
}
