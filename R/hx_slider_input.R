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
#' @param put URL for `hx-put`.
#' @param patch URL for `hx-patch`.
#' @param delete URL for `hx-delete`. Note: parameters are sent in the URL
#'   query string (not the request body) — read them via the injected `query`
#'   argument (e.g. `function(query) query$id`) or via `request$query` if you
#'   are using the full request object in your route.
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

  if (!is.null(label)) {
    tags$div(
      tags$label(`for` = id, label),
      input
    )
  } else {
    input
  }
}
