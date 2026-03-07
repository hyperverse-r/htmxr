#' Button element
#'
#' Creates a `<button>` element with optional htmx attributes.
#'
#' @param id Element id.
#' @param label Button label (text or HTML content). Pass `NULL` for icon-only
#'   buttons — in that case supply an `aria-label` via `...`.
#' @param class Optional CSS class(es).
#' @param get URL for `hx-get`.
#' @param post URL for `hx-post`.
#' @param put URL for `hx-put`.
#' @param patch URL for `hx-patch`.
#' @param delete URL for `hx-delete`. Note: parameters are sent in the URL
#'   query string (not the request body) — read them via `request$query` in
#'   your plumber2 route.
#' @param target CSS selector for `hx-target`.
#' @param swap Swap strategy for `hx-swap`.
#' @param trigger Trigger specification for `hx-trigger`.
#' @param indicator CSS selector for `hx-indicator`.
#' @param swap_oob Out-of-band swap targets for `hx-swap-oob`.
#' @param confirm Confirmation message for `hx-confirm`.
#' @param params Parameters to submit for `hx-params`. Use `"*"` to include
#'   all parameters (equivalent to omitting this argument), `"none"` to send
#'   none, or a comma-separated list of names (e.g. `"id, name"`). Prefix with
#'   `not` to exclude specific parameters (e.g. `"not id, name"`).
#' @param include CSS selector for `hx-include`. Additional elements whose
#'   values are included in the request. htmx relative selectors are valid:
#'   `"closest form"`, `"find input"`, `"next .sibling"`. Note: `params =
#'   "none"` does **not** suppress values sourced via `include`.
#' @param push_url Push a URL into the browser history for `hx-push-url`. Use
#'   `"true"` to push the request URL, `"false"` to disable, or a custom URL.
#' @param select CSS selector for `hx-select`. Extracts a specific element from
#'   the server response before swapping (e.g. `"#data-table"`).
#' @param vals JSON string of extra values to include in the request for
#'   `hx-vals` (e.g. `'{"id": 42}'`). Values are passed as-is. Avoid `js:`
#'   expressions with HTML-special characters — htmltools will escape them.
#' @param encoding Encoding type for `hx-encoding`. Use
#'   `"multipart/form-data"` to enable file uploads.
#' @param headers JSON string of request headers for `hx-headers` (e.g.
#'   `'{"X-Custom-Header": "value"}'`). Values are passed as-is. Do not
#'   embed sensitive tokens in HTML attributes.
#' @param ... Additional HTML attributes passed to the `<button>` element.
#'
#' @return An [htmltools::tags] object.
#'
#' @examples
#' # Simple button
#' hx_button("btn1", "Click me")
#'
#' # Button with htmx GET request
#' hx_button("load-btn", "Load data", get = "/api/data", target = "#result")
#'
#' # Button with confirmation
#' hx_button("del-btn", "Delete", post = "/api/delete", confirm = "Are you sure?")
#'
#' @export
hx_button <- function(
  id,
  label = NULL,
  class = NULL,
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
  vals = NULL,
  encoding = NULL,
  headers = NULL,
  ...
) {
  tags$button(label, type = "button", id = id, class = class, ...) |>
    hx_set(
      get = get,
      post = post,
      put = put,
      patch = patch,
      delete = delete,
      target = target,
      swap = swap,
      trigger = trigger,
      indicator = indicator,
      swap_oob = swap_oob,
      confirm = confirm,
      params = params,
      include = include,
      push_url = push_url,
      select = select,
      vals = vals,
      encoding = encoding,
      headers = headers
    )
}
