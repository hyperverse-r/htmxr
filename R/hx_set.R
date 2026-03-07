#' Add htmx attributes to any HTML tag
#'
#' A generic modifier that appends htmx attributes to an existing
#' [htmltools::tags] object. Works with any HTML element.
#'
#' @param tag An [htmltools::tags] object to modify.
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
#'   `"closest form"`, `"find input"`, `"next .sibling"`, `"previous .sibling"`.
#'   Note: `params = "none"` does **not** suppress values sourced via `include`
#'   — the two operate independently.
#' @param push_url Push a URL into the browser history for `hx-push-url`. Use
#'   `"true"` to push the request URL, `"false"` to disable (e.g. to override
#'   inheritance), or a custom URL string.
#' @param select CSS selector for `hx-select`. Extracts a specific element from
#'   the server response before swapping — useful when the server returns a full
#'   HTML page but only a fragment is needed (e.g. `"#data-table"`).
#' @param vals JSON string of extra values to include in the request for
#'   `hx-vals` (e.g. `'{"id": 42}'`). Values are passed as-is — no
#'   serialisation is performed. The `js:` prefix for dynamic expressions is
#'   supported by htmx but expressions containing HTML-special characters
#'   (`<`, `>`, `&`, `"`) will be escaped by htmltools and silently corrupted
#'   at runtime — avoid them or use DOM-based lookups instead.
#' @param encoding Encoding type for `hx-encoding`. Use
#'   `"multipart/form-data"` to enable file uploads via `<input type="file">`.
#' @param headers JSON string of request headers for `hx-headers` (e.g.
#'   `'{"X-Custom-Header": "value"}'`). Values are passed as-is. Do not
#'   embed sensitive tokens (auth headers, API keys) in HTML attributes —
#'   they are readable by any script on the page.
#' @param ... Additional htmx attributes passed as-is (e.g.
#'   `` `hx-disabled-elt` = "this" ``, `` `hx-prompt` = "Raison ?" ``).
#'   All arguments must be named. Names must start with `hx-` or `data-hx-` —
#'   a warning is emitted otherwise. Values are passed without transformation:
#'   use `"true"`/`"false"` (not `TRUE`/`FALSE`) for boolean htmx attributes,
#'   and pre-serialized JSON strings for `hx-vals` or `hx-headers`.
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
  extra <- list(...)

  if (length(extra) > 0) {
    if (is.null(names(extra)) || any(!nzchar(names(extra)))) {
      stop(
        "All arguments passed to `...` in hx_set() must be named ",
        "(e.g., `hx-disabled-elt` = \"this\").",
        call. = FALSE
      )
    }
    non_hx <- names(extra)[
      !startsWith(names(extra), "hx-") & !startsWith(names(extra), "data-hx-")
    ]
    if (length(non_hx) > 0) {
      warning(
        "hx_set() received non-htmx attributes via `...`: ",
        paste(non_hx, collapse = ", "),
        ". Add HTML-level attributes before calling hx_set().",
        call. = FALSE
      )
    }
  }

  hx <- hx_attrs(
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

  normalized_extra_names <- sub("^data-hx-", "hx-", names(extra))
  conflicts <- intersect(normalized_extra_names, names(hx))
  if (length(conflicts) > 0) {
    conflicting_orig <- names(extra)[normalized_extra_names %in% conflicts]
    stop(
      "hx_set() has conflicting attributes (named param and `...`): ",
      paste(conflicting_orig, collapse = ", "),
      ". Use either the named parameter or `...`, not both.",
      call. = FALSE
    )
  }

  do.call(tagAppendAttributes, c(list(tag), hx, extra))
}
