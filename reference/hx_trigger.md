# Trigger client-side htmx events via response headers

Adds an `HX-Trigger`, `HX-Trigger-After-Swap`, or
`HX-Trigger-After-Settle` header to a plumber2 response, causing htmx to
fire one or more client-side events after the response is received.

## Usage

``` r
hx_trigger(response, event)

hx_trigger_after_swap(response, event)

hx_trigger_after_settle(response, event)
```

## Arguments

- response:

  A plumber2 response object. The parameter **must** be named `response`
  in route handlers — it is the only name plumber2 recognises for
  injecting the response object.

- event:

  One of:

  - A **character string** — fires a single event: `"myEvent"`.

  - A **character vector** — fires multiple events:
    `c("event1", "event2")`.

  - A **named list** — fires events with detail payloads:
    `list(showMessage = list(level = "info"), confetti = NULL)`. Each
    name is an event; each value is its detail (use `NULL` for no
    detail).

## Value

The response object `response`, invisibly.

## Details

### Timing variants

- `hx_trigger()` — fires immediately when the response is received
  (`HX-Trigger`).

- `hx_trigger_after_swap()` — fires after htmx swaps the new content
  into the DOM (`HX-Trigger-After-Swap`). Use this when the event
  handler needs to interact with the freshly-swapped elements.

- `hx_trigger_after_settle()` — fires after htmx settles (CSS
  transitions complete) (`HX-Trigger-After-Settle`).

### Detail serialisation

When `event` is a named list, values are serialised to JSON using a
minimal built-in serialiser that supports `NULL`, logicals, numbers,
strings, and named lists of the above. No external dependency required.

## Examples

``` r
if (FALSE) { # \dontrun{
#* @post /submit
function(response) {
  # Simple event
  hx_trigger(response, "formSubmitted")

  # Multiple events
  hx_trigger(response, c("formSubmitted", "refresh"))

  # Event with detail payload
  hx_trigger(response, list(showMessage = list(level = "info", text = "Saved!")))

  list(status = "ok")
}
} # }
```
