# Generate a complete HTML page with htmx

Generate a complete HTML page with htmx

## Usage

``` r
hx_page(..., lang = "en", html_attrs = list())
```

## Arguments

- ...:

  page content. Use
  [`hx_head()`](https://hyperverse-r.github.io/htmxr/reference/hx_head.md)
  to add elements to the head.

- lang:

  language code for the `<html>` element (default `"en"`).

- html_attrs:

  a named list of additional attributes to set on the `<html>` element
  (e.g. `list("data-theme" = "cupcake")` for DaisyUI).

## Value

A length-one character string containing the full HTML document
(including `<!DOCTYPE html>`), ready to be served as an HTTP response.

## Examples

``` r
hx_page(tags$h1("Hello, htmxr!"))
#> [1] "<!DOCTYPE html>\n<html lang=\"en\">\n  <head>\n    <meta charset=\"UTF-8\"/>\n    <script src=\"/htmxr/assets/htmx/2.0.8/htmx.min.js\"></script>\n  </head>\n  <body>\n    <h1>Hello, htmxr!</h1>\n  </body>\n</html>"

hx_page(
  hx_head(title = "My app"),
  tags$p("Hello, world!")
)
#> [1] "<!DOCTYPE html>\n<html lang=\"en\">\n  <head>\n    <meta charset=\"UTF-8\"/>\n    <script src=\"/htmxr/assets/htmx/2.0.8/htmx.min.js\"></script>\n    <title>My app</title>\n  </head>\n  <body>\n    <p>Hello, world!</p>\n  </body>\n</html>"
```
