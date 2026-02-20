# Specify additional head elements for an htmxr page

Wraps tags to be included in the page head when passed to
[`hx_page()`](https://thinkr-open.github.io/htmxr/reference/hx_page.md).

## Usage

``` r
hx_head(..., title = "htmxr page")
```

## Arguments

- ...:

  tags to include in the head (stylesheets, scripts, meta, etc.)

- title:

  page title

## Value

A list with class `hx_head`, to be passed to
[`hx_page()`](https://thinkr-open.github.io/htmxr/reference/hx_page.md).
