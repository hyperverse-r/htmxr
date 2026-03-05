library(htmxr)

# Demonstrates hx_trigger(): submitting a form swaps the result area AND fires
# a "notified" event that causes a toast notification to appear at the top —
# two independent zones updated from a single POST.

bootstrap_css <- tags$link(
  rel = "stylesheet",
  href = "https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css",
  integrity = "sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB",
  crossorigin = "anonymous"
)

#* @get /
#* @parser none
#* @serializer html
function() {
  hx_page(
    hx_head(title = "Toast Notification", bootstrap_css),
    div(
      class = "container py-5",
      style = "max-width: 500px",
      # Toast area — empty on load, populated when "notified" event fires.
      div(id = "toast") |>
        hx_set(
          get = "/toast",
          trigger = "notified from:body",
          swap = "innerHTML"
        ),
      tags$h1(class = "h3 mb-4", "Submit an action"),
      div(id = "result", class = "mb-3"),
      hx_button(
        "submit-btn",
        "Submit",
        class = "btn btn-primary",
        post = "/submit",
        target = "#result",
        swap = "innerHTML"
      )
    )
  )
}

#* @post /submit
#* @parser none
#* @serializer html
function(response) {
  # Fire the event — the toast area reacts independently.
  hx_trigger(response, "notified")
  as.character(tags$p(class = "text-success fw-bold", "Action completed."))
}

#* @get /toast
#* @parser none
#* @serializer html
function() {
  as.character(tags$div(
    class = "alert alert-success mb-4",
    tags$strong("Done!"),
    paste(" Triggered at", format(Sys.time(), "%H:%M:%S"), ".")
  ))
}
