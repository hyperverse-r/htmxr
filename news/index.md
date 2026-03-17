# Changelog

## htmxr 0.3.0

### New features

- [`hx_set()`](https://hyperverse-r.github.io/htmxr/reference/hx_set.md)
  now accepts all CRUD verbs as named parameters: `put`, `patch`,
  `delete` (in addition to existing `get` and `post`).
- New named parameters across
  [`hx_set()`](https://hyperverse-r.github.io/htmxr/reference/hx_set.md)
  and all components
  ([`hx_button()`](https://hyperverse-r.github.io/htmxr/reference/hx_button.md),
  [`hx_select_input()`](https://hyperverse-r.github.io/htmxr/reference/hx_select_input.md),
  [`hx_slider_input()`](https://hyperverse-r.github.io/htmxr/reference/hx_slider_input.md),
  [`hx_table()`](https://hyperverse-r.github.io/htmxr/reference/hx_table.md)):
  `params`, `include`, `push_url`, `select`, `vals`, `encoding`,
  `headers` — covering the most commonly used htmx core attributes as
  named parameters.
- [`hx_set()`](https://hyperverse-r.github.io/htmxr/reference/hx_set.md)
  now accepts `...` as an escape hatch for raw htmx attributes not
  covered by named parameters (e.g. `` `hx-disabled-elt` = "this" ``,
  `` `hx-prompt` = "Reason?" ``). Names must start with `hx-` or
  `data-hx-`.
- New example `delete-row` — demonstrates the `vals` attribute: each
  delete button embeds its row id as JSON via `hx-vals`, no form or
  hidden input needed.

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
