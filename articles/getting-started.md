# Getting Started with htmxr

## What is htmxr?

[htmx](https://htmx.org) is a lightweight JavaScript library (~16kb)
that lets any HTML element send HTTP requests — not just `<a>` and
`<form>` tags.

The core philosophy is **HTML over the wire**: your server returns HTML
fragments, not JSON. The browser swaps those fragments directly into the
page without a full reload.

**htmxr** is the R wrapper: it provides `htmltools`-based primitives to
generate htmx attributes and build complete pages, backed by a
[plumber2](https://github.com/andersnotes/plumber2) server.

------------------------------------------------------------------------

## Installation

``` r
install.packages("htmxr")

# development version
pak::pak("hyperverse-r/htmxr")
```

htmxr uses [plumber2](https://github.com/andersnotes/plumber2) as its
HTTP server — make sure it is installed alongside htmxr.

------------------------------------------------------------------------

## How htmx works

Every htmx interaction follows the same four-step cycle:

1.  **User triggers an event** — a click, an input change, a page load,
    a form submission…
2.  **htmx sends an HTTP request** to your server (GET or POST)
3.  **Your server returns an HTML fragment** — a snippet of HTML, not
    JSON
4.  **htmx swaps the fragment** into the targeted DOM element

You control this cycle through five core attributes:

| Attribute    | htmxr parameter      | What it does                                           |
|--------------|----------------------|--------------------------------------------------------|
| `hx-get`     | `get = "/url"`       | Send GET request on trigger                            |
| `hx-post`    | `post = "/url"`      | Send POST request on trigger                           |
| `hx-target`  | `target = "#id"`     | CSS selector of the element to update                  |
| `hx-swap`    | `swap = "innerHTML"` | How to insert the response (`innerHTML`, `outerHTML`…) |
| `hx-trigger` | `trigger = "click"`  | What triggers the request (`click`, `change`, `load`…) |

In htmxr, these map directly to function parameters — no JavaScript to
write.

------------------------------------------------------------------------

## Your first htmxr app

The fastest way to see htmxr in action is to run the built-in `hello`
example:

``` r
library(htmxr)
hx_run_example("hello")
```

This launches an Old Faithful histogram where a slider controls the
number of bins. Let’s walk through how it works.

### The page

The page is served by a `GET /` route.
[`hx_page()`](https://hyperverse-r.github.io/htmxr/reference/hx_page.md)
wraps the full HTML document and injects the htmx script automatically.
[`hx_head()`](https://hyperverse-r.github.io/htmxr/reference/hx_head.md)
handles the `<head>` tag.

The slider is built with
[`hx_slider_input()`](https://hyperverse-r.github.io/htmxr/reference/hx_slider_input.md).
Three htmx parameters connect it to the server:

``` r
hx_slider_input(
  id = "bins",
  label = "Number of bins:",
  value = 30,
  min = 1,
  max = 50,
  get = "/plot",                         # send GET /plot on trigger
  trigger = "input changed delay:300ms", # trigger: input event, debounced 300ms
  target = "#plot"                       # replace the content of #plot
)
```

The plot container is a plain `<div>` with an `id`.
[`hx_set()`](https://hyperverse-r.github.io/htmxr/reference/hx_set.md)
adds htmx attributes to it so the plot loads immediately on page load:

``` r
tags$div(id = "plot") |>
  hx_set(
    get = "/plot",
    trigger = "load",       # fires once when the element is loaded
    target = "#plot",
    swap = "innerHTML"
  )
```

### The fragment endpoint

The `/plot` route returns an SVG string — an HTML fragment, not a full
page:

``` r
#* @get /plot
#* @query bins:integer(30)
#* @parser none
#* @serializer none
function(query) {
  generate_plot(query$bins)
}
```

When the slider moves, htmxr sends `GET /plot?bins=35`. The server
returns the SVG. htmx swaps it into `#plot`. No JavaScript, no JSON
parsing, no manual DOM manipulation.

### The htmx connection

    slider input event
           │
           ▼
    GET /plot?bins=35   ──►   server renders SVG
                                       │
                        ◄──────────────┘
              htmx swaps SVG into #plot

------------------------------------------------------------------------

## Anatomy of an htmxr project

A minimal htmxr app needs only two things:

**`api.R`** — your plumber2 API with two kinds of routes:

- `GET /` — returns the full page (built with
  [`hx_page()`](https://hyperverse-r.github.io/htmxr/reference/hx_page.md))

- `GET /fragment` — returns HTML fragments (one route per dynamic piece)

**[`hx_serve_assets()`](https://hyperverse-r.github.io/htmxr/reference/hx_serve_assets.md)**
— registers the htmx JavaScript file as a static asset on your plumber2
router.
[`hx_page()`](https://hyperverse-r.github.io/htmxr/reference/hx_page.md)
and
[`hx_head()`](https://hyperverse-r.github.io/htmxr/reference/hx_head.md)
handle injecting the `<script>` tag automatically.

``` r
# Minimal api.R structure
library(htmxr)

#* @get /
#* @serializer html
function() {
  hx_page(
    hx_head(
      title = "My app"
    ),
    tags$div(
      id = "content"
    ) |>
      hx_set(
        get = "/content",
        trigger = "load",
        target = "#content"
      )
  )
}

#* @get /content
#* @serializer html
function() {
  tags$p("Hello from the server!")
}
```

Launch API with:

    library(htmxr)

    pr <- plumber2::api("api.R") |>
      hx_serve_assets()

    cat("\n🚀 Launch API...\n")
    cat("🌐 Webapp: http://127.0.0.1:8080/\n\n")

    pr$ignite(port = 8080)

------------------------------------------------------------------------

## Next steps

Explore more built-in examples:

``` r
# List all available examples
hx_run_example()

# Dynamic table filtering with hx_select_input()
hx_run_example("select-input")
```
