#' Serve htmxr static assets
#'
#' Configures a plumber2 API to serve htmxr's static assets
#' (htmx JavaScript library) at `/htmxr/assets/`.
#'
#' @param api a plumber2 API object
#'
#' @importFrom plumber2 api_statics
#'
#' @return the API object (modified, for piping)
#'
#' @examples
#' \donttest{
#'   plumber2::api() |>
#'     hx_serve_assets()
#' }
#'
#' @export
hx_serve_assets <- function(api) {
  api_statics(
    api,
    at = "/htmxr/assets/",
    path = system.file("assets", package = "htmxr")
  )
}
