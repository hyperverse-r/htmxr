make_res <- function() {
  headers <- list()
  list(
    set_header = function(name, value) headers[[name]] <<- value,
    getHeader = function(name) headers[[name]]
  )
}

# hx_trigger() -----------------------------------------------------------------

test_that("hx_trigger() sets HX-Trigger with a single event", {
  res <- make_res()
  hx_trigger(res, "confetti")
  expect_equal(res$getHeader("HX-Trigger"), "confetti")
})

test_that("hx_trigger() joins multiple events with ', '", {
  res <- make_res()
  hx_trigger(res, c("confetti", "refresh"))
  expect_equal(res$getHeader("HX-Trigger"), "confetti, refresh")
})

test_that("hx_trigger() serialises named list to JSON", {
  res <- make_res()
  hx_trigger(res, list(showMessage = list(level = "info", text = "Saved!")))
  expect_equal(
    res$getHeader("HX-Trigger"),
    '{"showMessage":{"level":"info","text":"Saved!"}}'
  )
})

test_that("hx_trigger() handles NULL detail in named list", {
  res <- make_res()
  hx_trigger(res, list(confetti = NULL, refresh = NULL))
  expect_equal(res$getHeader("HX-Trigger"), '{"confetti":null,"refresh":null}')
})

test_that("hx_trigger() returns res invisibly", {
  res <- make_res()
  result <- withVisible(hx_trigger(res, "e"))
  expect_false(result$visible)
})

test_that("hx_trigger() errors on invalid event type", {
  res <- make_res()
  expect_error(hx_trigger(res, 42), "`event` must be")
})

# hx_trigger_after_swap() ------------------------------------------------------

test_that("hx_trigger_after_swap() sets HX-Trigger-After-Swap", {
  res <- make_res()
  hx_trigger_after_swap(res, "updateChart")
  expect_equal(res$getHeader("HX-Trigger-After-Swap"), "updateChart")
})

test_that("hx_trigger_after_swap() supports named list with detail", {
  res <- make_res()
  hx_trigger_after_swap(res, list(highlight = list(id = "result")))
  expect_equal(
    res$getHeader("HX-Trigger-After-Swap"),
    '{"highlight":{"id":"result"}}'
  )
})

test_that("hx_trigger_after_swap() returns res invisibly", {
  res <- make_res()
  result <- withVisible(hx_trigger_after_swap(res, "e"))
  expect_false(result$visible)
})

# hx_trigger_after_settle() ----------------------------------------------------

test_that("hx_trigger_after_settle() sets HX-Trigger-After-Settle", {
  res <- make_res()
  hx_trigger_after_settle(res, "animationDone")
  expect_equal(res$getHeader("HX-Trigger-After-Settle"), "animationDone")
})

test_that("hx_trigger_after_settle() supports multiple events", {
  res <- make_res()
  hx_trigger_after_settle(res, c("animationDone", "cleanup"))
  expect_equal(
    res$getHeader("HX-Trigger-After-Settle"),
    "animationDone, cleanup"
  )
})

test_that("hx_trigger_after_settle() returns res invisibly", {
  res <- make_res()
  result <- withVisible(hx_trigger_after_settle(res, "e"))
  expect_false(result$visible)
})
