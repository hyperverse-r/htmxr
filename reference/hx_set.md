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
  target = NULL,
  swap = NULL,
  trigger = NULL,
  indicator = NULL,
  swap_oob = NULL,
  confirm = NULL
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
