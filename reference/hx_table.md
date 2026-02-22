# Table with htmx-powered tbody

Builds a complete `<table>` element with a `<thead>` and a `<tbody>`.
htmx attributes are applied to the `<tbody>`, making it the swap target.
When `data` is `NULL` (the default), the `<tbody>` is empty and its
content is loaded lazily via htmx (e.g. `trigger = "load"`).

## Usage

``` r
hx_table(
  columns,
  data = NULL,
  id = NULL,
  col_labels = NULL,
  col_classes = NULL,
  class = NULL,
  thead_class = NULL,
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

- columns:

  Character vector of column names to display. Defines the `<thead>`
  structure (required).

- data:

  Optional data frame. If provided, rows are rendered in the `<tbody>`
  via
  [`hx_table_rows()`](https://hyperverse-r.github.io/htmxr/reference/hx_table_rows.md).
  If `NULL`, the `<tbody>` is empty.

- id:

  `id` attribute applied to the `<tbody>`.

- col_labels:

  Labels for the `<thead>`. If `NULL`, column names are used as-is. Can
  be a named vector (`c(price = "Price ($)")`) to override specific
  columns, or an unnamed positional vector to replace all labels.

- col_classes:

  Named list of CSS classes for `<td>` cells, passed to
  [`hx_table_rows()`](https://hyperverse-r.github.io/htmxr/reference/hx_table_rows.md)
  when `data` is provided.

- class:

  CSS class(es) for the `<table>` element.

- thead_class:

  CSS class(es) for the `<thead>` element.

- get:

  URL for `hx-get` (applied to `<tbody>`).

- post:

  URL for `hx-post` (applied to `<tbody>`).

- target:

  CSS selector for `hx-target` (applied to `<tbody>`).

- swap:

  Swap strategy for `hx-swap` (applied to `<tbody>`).

- trigger:

  Trigger specification for `hx-trigger` (applied to `<tbody>`).

- indicator:

  CSS selector for `hx-indicator` (applied to `<tbody>`).

- swap_oob:

  Out-of-band swap targets for `hx-swap-oob` (applied to `<tbody>`).

- confirm:

  Confirmation message for `hx-confirm` (applied to `<tbody>`).

- ...:

  Additional HTML attributes passed to the `<table>` element.

## Value

An
[htmltools::tags](https://rstudio.github.io/htmltools/reference/builder.html)
object (`<table>`).

## Examples

``` r
# Lazy-load table (empty tbody, content loaded on trigger)
hx_table(
  columns = c("cut", "color", "price"),
  col_labels = c("Cut", "Color", "Price"),
  id = "tbody",
  get = "/rows",
  trigger = "load",
  swap = "innerHTML"
)
#> <table>
#>   <thead>
#>     <tr>
#>       <th>Cut</th>
#>       <th>Color</th>
#>       <th>Price</th>
#>     </tr>
#>   </thead>
#>   <tbody id="tbody" hx-get="/rows" hx-swap="innerHTML" hx-trigger="load"></tbody>
#> </table>

# Table with data pre-rendered
df <- data.frame(cut = c("Fair", "Good"), price = c(326L, 400L))
hx_table(columns = c("cut", "price"), data = df)
#> <table>
#>   <thead>
#>     <tr>
#>       <th>cut</th>
#>       <th>price</th>
#>     </tr>
#>   </thead>
#>   <tbody>
#>     <tr>
#>       <td>Fair</td>
#>       <td>326</td>
#>     </tr>
#>     <tr>
#>       <td>Good</td>
#>       <td>400</td>
#>     </tr>
#>   </tbody>
#> </table>
```
