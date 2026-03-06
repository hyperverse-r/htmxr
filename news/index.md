# Changelog

## htmxr 0.2.0

CRAN release: 2026-03-06

### Breaking changes

- `htmxr_is_htmx()` renamed to
  [`hx_is_htmx()`](https://hyperverse-r.github.io/htmxr/reference/hx_is_htmx.md)
  to follow the `hx_` prefix convention applied to all exported
  functions.
- [`hx_button()`](https://hyperverse-r.github.io/htmxr/reference/hx_button.md)
  parameter order changed: `id` is now first and required (was `label`).
  Update calls like `hx_button("Click me")` to
  `hx_button("my-btn", label = "Click me")`.
- [`hx_table()`](https://hyperverse-r.github.io/htmxr/reference/hx_table.md)
  parameter `id` renamed to `tbody_id` to clarify that the id is applied
  to the `<tbody>`, not the `<table>`.

### New functions

- [`hx_trigger()`](https://hyperverse-r.github.io/htmxr/reference/hx_trigger.md)
  — adds an `HX-Trigger` response header to a plumber2 response, causing
  htmx to fire a client-side event immediately after the response.
- [`hx_trigger_after_swap()`](https://hyperverse-r.github.io/htmxr/reference/hx_trigger.md)
  — same, but fires after htmx swaps the new content into the DOM
  (`HX-Trigger-After-Swap`).
- [`hx_trigger_after_settle()`](https://hyperverse-r.github.io/htmxr/reference/hx_trigger.md)
  — same, but fires after htmx settles (`HX-Trigger-After-Settle`).
- The `event` argument accepts a character vector (multiple events) or a
  named list (events with JSON detail payloads), serialised without
  external dependencies.

## htmxr 0.1.1

CRAN release: 2026-03-04

- Fix invalid ‘plumber2’ URL in vignette (was pointing to a non-existent
  GitHub repository, now points to <https://plumber2.posit.co/>).
- Quote technical terms in `DESCRIPTION` to comply with CRAN spell check
  conventions.
- Add `Depends: R (>= 4.1.0)` for native pipe `|>` compatibility.

## htmxr 0.1.0

- Initial CRAN release.
