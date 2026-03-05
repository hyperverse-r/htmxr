# .hx_to_json() ----------------------------------------------------------------

test_that(".hx_to_json() handles NULL", {
  expect_equal(htmxr:::.hx_to_json(NULL), "null")
})

test_that(".hx_to_json() handles TRUE and FALSE", {
  expect_equal(htmxr:::.hx_to_json(TRUE), "true")
  expect_equal(htmxr:::.hx_to_json(FALSE), "false")
})

test_that(".hx_to_json() handles integer and double", {
  expect_equal(htmxr:::.hx_to_json(42L), "42")
  expect_equal(htmxr:::.hx_to_json(3.14), "3.14")
})

test_that(".hx_to_json() wraps strings in double quotes", {
  expect_equal(htmxr:::.hx_to_json("hello"), '"hello"')
})

test_that(".hx_to_json() escapes double quotes inside strings", {
  expect_equal(htmxr:::.hx_to_json('say "hi"'), '"say \\"hi\\""')
})

test_that(".hx_to_json() escapes backslashes inside strings", {
  expect_equal(htmxr:::.hx_to_json("a\\b"), '"a\\\\b"')
})

test_that(".hx_to_json() serialises a flat named list", {
  expect_equal(
    htmxr:::.hx_to_json(list(a = 1, b = "x")),
    '{"a":1,"b":"x"}'
  )
})

test_that(".hx_to_json() serialises a nested named list", {
  expect_equal(
    htmxr:::.hx_to_json(list(outer = list(inner = TRUE))),
    '{"outer":{"inner":true}}'
  )
})

test_that(".hx_to_json() handles NULL values inside a list", {
  expect_equal(
    htmxr:::.hx_to_json(list(a = NULL, b = 1)),
    '{"a":null,"b":1}'
  )
})

test_that(".hx_to_json() errors on unnamed list", {
  expect_error(htmxr:::.hx_to_json(list(1, 2)), "Unsupported value type")
})

test_that(".hx_to_json() errors on unsupported atomic type", {
  expect_error(
    htmxr:::.hx_to_json(as.Date("2024-01-01")),
    "Unsupported value type"
  )
})

# .hx_trigger_value() ----------------------------------------------------------

test_that(".hx_trigger_value() returns a single event as-is", {
  expect_equal(htmxr:::.hx_trigger_value("confetti"), "confetti")
})

test_that(".hx_trigger_value() joins multiple events with ', '", {
  expect_equal(
    htmxr:::.hx_trigger_value(c("confetti", "refresh")),
    "confetti, refresh"
  )
})

test_that(".hx_trigger_value() serialises named list to JSON", {
  expect_equal(
    htmxr:::.hx_trigger_value(list(showMessage = list(level = "info"))),
    '{"showMessage":{"level":"info"}}'
  )
})

test_that(".hx_trigger_value() handles mixed NULL and list details", {
  expect_equal(
    htmxr:::.hx_trigger_value(list(
      confetti = NULL,
      showMessage = list(level = "info")
    )),
    '{"confetti":null,"showMessage":{"level":"info"}}'
  )
})

test_that(".hx_trigger_value() errors on invalid type", {
  expect_error(htmxr:::.hx_trigger_value(42), "`event` must be")
})

test_that(".hx_trigger_value() errors on unnamed list", {
  expect_error(htmxr:::.hx_trigger_value(list("e1", "e2")), "`event` must be")
})
