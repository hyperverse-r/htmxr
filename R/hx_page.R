#' Specify additional head elements for an htmxr page
#'
#' Wraps tags to be included in the page head when passed to [hx_page()].
#'
#' @param ... tags to include in the head (stylesheets, scripts, meta, etc.)
#' @param title page title
#'
#' @return A list with class `hx_head`, to be passed to [hx_page()].
#'
#' @examples
#' hx_head(title = "My app")
#'
#' hx_head(
#'   title = "My app",
#'   tags$link(rel = "stylesheet", href = "/style.css")
#' )
#'
#' @export
hx_head <- function(..., title = "htmxr page") {
  structure(list(..., tags$title(title)), class = "hx_head")
}

#' Generate a complete HTML page with htmx
#'
#' @param ... page content. Use [hx_head()] to add elements to the head.
#' @param lang language code for the `<html>` element (default `"en"`).
#' @param html_attrs a named list of additional attributes to set on the
#'   `<html>` element (e.g. `list("data-theme" = "cupcake")` for DaisyUI).
#'
#' @importFrom htmltools tags doRenderTags
#'
#' @return A length-one character string containing the full HTML document
#'   (including `<!DOCTYPE html>`), ready to be served as an HTTP response.
#'
#' @examples
#' hx_page(tags$h1("Hello, htmxr!"))
#'
#' hx_page(
#'   hx_head(title = "My app"),
#'   tags$p("Hello, world!")
#' )
#'
#' @export
hx_page <- function(..., lang = "en", html_attrs = list()) {
  dots <- list(...)
  is_head <- vapply(dots, inherits, logical(1), "hx_head")
  head_extra <- unlist(dots[is_head], recursive = FALSE)
  body_content <- dots[!is_head]

  if ("lang" %in% names(html_attrs)) {
    stop(
      'Use the `lang` parameter of `hx_page()` to set the language, not `html_attrs`.'
    )
  }

  html_args <- c(
    list(lang = lang),
    html_attrs,
    list(
      tags$head(
        tags$meta(charset = "UTF-8"),
        tags$script(src = "/htmxr/assets/htmx/2.0.8/htmx.min.js"),
        head_extra
      ),
      tags$body(body_content)
    )
  )

  page <- do.call(tags$html, html_args)
  paste0("<!DOCTYPE html>\n", doRenderTags(page) |> as.character())
}
