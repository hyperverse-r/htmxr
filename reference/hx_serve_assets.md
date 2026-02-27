# Serve htmxr static assets

Configures a plumber2 API to serve htmxr's static assets (htmx
JavaScript library) at `/htmxr/assets/`.

## Usage

``` r
hx_serve_assets(api)
```

## Arguments

- api:

  a plumber2 API object

## Value

the API object (modified, for piping)

## Examples

``` r
plumber2::api() |>
  hx_serve_assets()
#> ── A plumber server ────────────────────────────────────────────────────────────
#> Serving on http://127.0.0.1:8080
#> Currently not running
```
