# Specify additional head elements for an htmxr page

Wraps tags to be included in the page head when passed to
[`hx_page()`](https://hyperverse-r.github.io/htmxr/reference/hx_page.md).

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
[`hx_page()`](https://hyperverse-r.github.io/htmxr/reference/hx_page.md).

## Examples

``` r
hx_head(title = "My app")
#> [[1]]
#> <title>My app</title>
#> 
#> attr(,"class")
#> [1] "hx_head"

hx_head(
  title = "My app",
  tags$link(rel = "stylesheet", href = "/style.css")
)
#> [[1]]
#> <link rel="stylesheet" href="/style.css"/>
#> 
#> [[2]]
#> <title>My app</title>
#> 
#> attr(,"class")
#> [1] "hx_head"
```
