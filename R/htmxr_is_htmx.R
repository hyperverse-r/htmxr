#' Detect if a request comes from htmx
#'
#' Checks whether the incoming HTTP request was made by htmx by inspecting
#' the `HX-Request` header. htmx sends this header with every AJAX request.
#'
#' @param request A request object (e.g. from a plumber2 handler). Must have
#'   a `headers` element — a named list or character vector of HTTP headers
#'   (lowercase keys, as provided by plumber2).
#'
#' @return `TRUE` if the request was made by htmx, `FALSE` otherwise.
#'
#' @examples
#' # Simulated htmx request
#' req <- list(headers = list(`hx-request` = "true"))
#' htmxr_is_htmx(req)
#'
#' # Regular request
#' req <- list(headers = list())
#' htmxr_is_htmx(req)
#'
#' @export
htmxr_is_htmx <- function(request) {
  identical(request$headers[["hx-request"]], "true")
}
