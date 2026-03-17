# Button element

Creates a `<button>` element with optional htmx attributes.

## Usage

``` r
hx_button(
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
)
```

## Arguments

- id:

  Element id.

- label:

  Button label (text or HTML content). Pass `NULL` for icon-only buttons
  — in that case supply an `aria-label` via `...`.

- class:

  Optional CSS class(es).

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
  `"closest form"`, `"find input"`, `"next .sibling"`. Note:
  `params = "none"` does **not** suppress values sourced via `include`.

- push_url:

  Push a URL into the browser history for `hx-push-url`. Use `"true"` to
  push the request URL, `"false"` to disable, or a custom URL.

- select:

  CSS selector for `hx-select`. Extracts a specific element from the
  server response before swapping (e.g. `"#data-table"`).

- vals:

  JSON string of extra values to include in the request for `hx-vals`
  (e.g. `'{"id": 42}'`). Values are passed as-is. Avoid `js:`
  expressions with HTML-special characters — htmltools will escape them.

- encoding:

  Encoding type for `hx-encoding`. Use `"multipart/form-data"` to enable
  file uploads.

- headers:

  JSON string of request headers for `hx-headers` (e.g.
  `'{"X-Custom-Header": "value"}'`). Values are passed as-is. Do not
  embed sensitive tokens in HTML attributes.

- ...:

  Additional HTML attributes passed to the `<button>` element.

## Value

An
[htmltools::tags](https://rstudio.github.io/htmltools/reference/builder.html)
object.

## Examples

``` r
# Simple button
hx_button("btn1", "Click me")
#> <button type="button" id="btn1">Click me</button>

# Button with htmx GET request
hx_button("load-btn", "Load data", get = "/api/data", target = "#result")
#> <button type="button" id="load-btn" hx-get="/api/data" hx-target="#result">Load data</button>

# Button with confirmation
hx_button("del-btn", "Delete", post = "/api/delete", confirm = "Are you sure?")
#> <button type="button" id="del-btn" hx-post="/api/delete" hx-confirm="Are you sure?">Delete</button>
```
