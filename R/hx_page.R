#' Specify additional head elements for an htmxr page
#'
#' Wraps tags to be included in the page head when passed to [hx_page()].
#'
#' @param ... tags to include in the head (stylesheets, scripts, meta, etc.)
#' @param title page title
#'
#' @return A list with class `hx_head`, to be passed to [hx_page()].
#'
#' @export
hx_head <- function(..., title = "htmxr page") {
  structure(list(..., tags$title(title)), class = "hx_head")
}

#' Generate a complete HTML page with htmx
#'
#' @param ... page content. Use [hx_head()] to add elements to the head.
#' @param lang language code for the `<html>` element (default `"en"`).
#'
#' @importFrom htmltools tags doRenderTags
#'
#' @return A length-one character string containing the full HTML document
#'   (including `<!DOCTYPE html>`), ready to be served as an HTTP response.
#'
#' @export
hx_page <- function(..., lang = "en") {
  dots <- list(...)
  is_head <- vapply(dots, inherits, logical(1), "hx_head")
  head_extra <- unlist(dots[is_head], recursive = FALSE)
  body_content <- dots[!is_head]

  page <- tags$html(
    lang = lang,
    tags$head(
      tags$meta(charset = "UTF-8"),
      tags$script(src = "/htmxr/assets/htmx/2.0.8/htmx.min.js"),
      head_extra
    ),
    tags$body(body_content)
  )

  paste0("<!DOCTYPE html>\n", doRenderTags(page) |> as.character())
}
