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
  target = NULL,
  swap = NULL,
  trigger = NULL,
  indicator = NULL,
  swap_oob = NULL,
  confirm = NULL,
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
