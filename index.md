# htmxr

> Build modern web applications in R — without writing JavaScript.

[htmx](https://htmx.org) handles client-side interactions via HTML
attributes. [plumber2](https://plumber2.posit.co) handles R endpoints
server-side. [htmxr](https://github.com/thinkr-open/htmxr) bridges the
two with R helpers that generate the right HTML and wire everything
together.

## Installation

``` r
pak::pak("thinkr-open/htmxr")
```

## How it works

![htmxr architecture diagram](reference/figures/intro_htmxr.png)

On first load, the server returns a complete HTML page. When the user
interacts with an element (e.g. a slider), htmx sends a request to the R
endpoint and swaps the response into the DOM — no JavaScript needed, no
full page reload.

## Example — Old Faithful

The `hello` example ships with
[htmxr](https://github.com/thinkr-open/htmxr). It reproduces the classic
Old Faithful histogram with a slider to control the number of bins.

### The page

The `GET /` endpoint returns a full HTML page built with
[`hx_page()`](https://thinkr-open.github.io/htmxr/reference/hx_page.md)
and
[`hx_head()`](https://thinkr-open.github.io/htmxr/reference/hx_head.md).
The slider is created with
[`hx_slider_input()`](https://thinkr-open.github.io/htmxr/reference/hx_slider_input.md),
which generates a `<input type="range">` wired to htmx attributes.

``` r
#* @get /
#* @parser none
#* @serializer html
function() {
  hx_page(
    hx_head(title = "Old Faithful Geyser Data", bootstrap_css),
    tags$div(
      class = "container py-5",
      # ...
      hx_slider_input(
        id = "bins",
        label = "Number of bins:",
        value = 30,
        min = 1,
        max = 50,
        get = "/plot",
        trigger = "input changed delay:300ms",
        target = "#plot"
      )
      # ...
    )
  )
}
```

### The endpoint

The `GET /plot` endpoint is a standard plumber2 handler. It receives the
`bins` query parameter, generates an SVG histogram, and returns it as an
HTML fragment.

``` r
generate_plot <- function(bins = 30) {
  svg_string <- svglite::xmlSVG({
    x <- faithful[, 2]
    bins_seq <- seq(min(x), max(x), length.out = as.numeric(bins) + 1)
    hist(x, breaks = bins_seq, col = "darkgray", border = "white")
  })
  svg_string
}

#* @get /plot
#* @query bins:integer(30)
#* @parser none
#* @serializer none
function(query) {
  generate_plot(query$bins)
}
```

![htmxr hello example
screenshot](reference/figures/intro_htmxr_hello.png)

### Run it

``` r
hx_run_example("hello")
```

## Key ideas

- **CSS-agnostic** — [htmxr](https://github.com/thinkr-open/htmxr)
  doesn’t depend on any CSS framework. Use Bootstrap, Tailwind, or
  nothing at all.
- **htmltools re-exported** — `tags`, `div`, `p`, etc. are available
  directly from [htmxr](https://github.com/thinkr-open/htmxr).
