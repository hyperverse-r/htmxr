# Generate a complete HTML page with htmx

Generate a complete HTML page with htmx

## Usage

``` r
hx_page(..., lang = "en")
```

## Arguments

- ...:

  page content. Use
  [`hx_head()`](https://thinkr-open.github.io/htmxr/reference/hx_head.md)
  to add elements to the head.

- lang:

  language code for the `<html>` element (default `"en"`).

## Value

A length-one character string containing the full HTML document
(including `<!DOCTYPE html>`), ready to be served as an HTTP response.
