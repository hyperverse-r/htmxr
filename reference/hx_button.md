# Button element

Creates a `<button>` element with optional htmx attributes.

## Usage

``` r
hx_button(
  label,
  id = NULL,
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

- label:

  Button label (text or HTML content).

- id:

  Optional element id.

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
hx_button("Click me")
#> <button type="button">Click me</button>

# Button with htmx GET request
hx_button("Load data", get = "/api/data", target = "#result")
#> <button type="button" hx-get="/api/data" hx-target="#result">Load data</button>

# Button with confirmation
hx_button("Delete", post = "/api/delete", confirm = "Are you sure?")
#> <button type="button" hx-post="/api/delete" hx-confirm="Are you sure?">Delete</button>
```
