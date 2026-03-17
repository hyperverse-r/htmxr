# Add htmx attributes to any HTML tag

A generic modifier that appends htmx attributes to an existing
[htmltools::tags](https://rstudio.github.io/htmltools/reference/builder.html)
object. Works with any HTML element.

## Usage

``` r
hx_set(
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
)
```

## Arguments

- tag:

  An
  [htmltools::tags](https://rstudio.github.io/htmltools/reference/builder.html)
  object to modify.

- get:

  URL for `hx-get`.

- post:

  URL for `hx-post`.

- put:

  URL for `hx-put`.

- patch:

  URL for `hx-patch`.

- delete:

  URL for `hx-delete`. Note: parameters are sent in the URL query string
  (not the request body) — read them via the injected `query` argument
  (e.g. `function(query) query$id`) or via `request$query` if you are
  using the full request object in your route.

- target:

  CSS selector for `hx-target`.

- swap:

  Swap strategy for `hx-swap`.

- trigger:

  Trigger specification for `hx-trigger`.

- indicator:

  CSS selector for `hx-indicator`.

- swap_oob:

  Out-of-band swap targets for `hx-swap-oob`.

- confirm:

  Confirmation message for `hx-confirm`.

- params:

  Parameters to submit for `hx-params`. Use `"*"` to include all
  parameters (equivalent to omitting this argument), `"none"` to send
  none, or a comma-separated list of names (e.g. `"id, name"`). Prefix
  with `not` to exclude specific parameters (e.g. `"not id, name"`).

- include:

  CSS selector for `hx-include`. Additional elements whose values are
  included in the request. htmx relative selectors are valid:
  `"closest form"`, `"find input"`, `"next .sibling"`,
  `"previous .sibling"`. Note: `params = "none"` does **not** suppress
  values sourced via `include` — the two operate independently.

- push_url:

  Push a URL into the browser history for `hx-push-url`. Use `"true"` to
  push the request URL, `"false"` to disable (e.g. to override
  inheritance), or a custom URL string.

- select:

  CSS selector for `hx-select`. Extracts a specific element from the
  server response before swapping — useful when the server returns a
  full HTML page but only a fragment is needed (e.g. `"#data-table"`).

- vals:

  JSON string of extra values to include in the request for `hx-vals`
  (e.g. `'{"id": 42}'`). Values are passed as-is — no serialisation is
  performed. The `js:` prefix for dynamic expressions is supported by
  htmx but expressions containing HTML-special characters (`<`, `>`,
  `&`, `"`) will be escaped by htmltools and silently corrupted at
  runtime — avoid them or use DOM-based lookups instead.

- encoding:

  Encoding type for `hx-encoding`. Use `"multipart/form-data"` to enable
  file uploads via `<input type="file">`.

- headers:

  JSON string of request headers for `hx-headers` (e.g.
  `'{"X-Custom-Header": "value"}'`). Values are passed as-is. Do not
  embed sensitive tokens (auth headers, API keys) in HTML attributes —
  they are readable by any script on the page.

- ...:

  Additional htmx attributes passed as-is (e.g.
  `` `hx-disabled-elt` = "this" ``, `` `hx-prompt` = "Raison ?" ``). All
  arguments must be named. Names must start with `hx-` or `data-hx-` — a
  warning is emitted otherwise. Values are passed without
  transformation: use `"true"`/`"false"` (not `TRUE`/`FALSE`) for
  boolean htmx attributes, and pre-serialized JSON strings for `hx-vals`
  or `hx-headers`.

## Value

The input `tag` with htmx attributes appended.

## Examples

``` r
tags$div(id = "plot") |>
  hx_set(get = "/plot", trigger = "load", target = "#plot", swap = "innerHTML")
#> <div id="plot" hx-get="/plot" hx-target="#plot" hx-swap="innerHTML" hx-trigger="load"></div>

hx_set(
  tags$div(id = "result", class = "container"),
  get = "/data",
  trigger = "load"
)
#> <div id="result" class="container" hx-get="/data" hx-trigger="load"></div>
```
