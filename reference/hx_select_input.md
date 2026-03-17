# Select input

Creates a `<select>` element with optional htmx attributes. When `label`
is provided, the input is wrapped in a `<div>` containing a `<label>`
element linked via the `for` attribute.

## Usage

``` r
hx_select_input(
  id,
  label = NULL,
  choices,
  selected = NULL,
  multiple = FALSE,
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
)
```

## Arguments

- id:

  Element id. Also used as `name` by default.

- label:

  Optional label text. When provided, the input is wrapped in a `<div>`
  with a `<label>`.

- choices:

  Named or unnamed character vector of choices. If unnamed, values are
  used as labels. If named, names are used as labels and values as
  option values (same convention as Shiny).

- selected:

  Optional value(s) to pre-select.

- multiple:

  Logical. If `TRUE`, adds the `multiple` attribute to allow
  multi-selection.

- name:

  Form field name. Defaults to `id`.

- class:

  Optional CSS class(es) for the `<select>` element.

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

  Additional HTML attributes passed to the `<select>` element.

## Value

An
[htmltools::tags](https://rstudio.github.io/htmltools/reference/builder.html)
object.

## Examples

``` r
# Simple select without label
hx_select_input("cut", choices = c("Fair", "Good", "Ideal"))
#> <select id="cut" name="cut">
#>   <option value="Fair">Fair</option>
#>   <option value="Good">Good</option>
#>   <option value="Ideal">Ideal</option>
#> </select>

# Select with label and named choices
hx_select_input(
  "cut",
  label = "Filter by cut:",
  choices = c("All" = "all", "Fair", "Good", "Ideal"),
  selected = "all"
)
#> <div>
#>   <label for="cut">Filter by cut:</label>
#>   <select id="cut" name="cut">
#>     <option value="all" selected>All</option>
#>     <option value="Fair">Fair</option>
#>     <option value="Good">Good</option>
#>     <option value="Ideal">Ideal</option>
#>   </select>
#> </div>

# Select with htmx attributes
hx_select_input(
  "cut",
  label = "Filter by cut:",
  choices = c("All" = "all", "Fair", "Good"),
  get = "/rows",
  trigger = "change",
  target = "#tbody"
)
#> <div>
#>   <label for="cut">Filter by cut:</label>
#>   <select id="cut" name="cut" hx-get="/rows" hx-target="#tbody" hx-trigger="change">
#>     <option value="all">All</option>
#>     <option value="Fair">Fair</option>
#>     <option value="Good">Good</option>
#>   </select>
#> </div>
```
