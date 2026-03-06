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
