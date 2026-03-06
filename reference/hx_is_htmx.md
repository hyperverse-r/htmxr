# Detect if a request comes from htmx

Checks whether the incoming HTTP request was made by htmx by inspecting
the `HX-Request` header. htmx sends this header with every AJAX request.

## Usage

``` r
hx_is_htmx(request)
```

## Arguments

- request:

  A request object (e.g. from a plumber2 handler). Must have a `headers`
  element — a named list or character vector of HTTP headers (lowercase
  keys, as provided by plumber2).

## Value

`TRUE` if the request was made by htmx, `FALSE` otherwise.

## Examples

``` r
# Simulated htmx request
req <- list(headers = list(`hx-request` = "true"))
hx_is_htmx(req)
#> [1] TRUE

# Regular request
req <- list(headers = list())
hx_is_htmx(req)
#> [1] FALSE
```
