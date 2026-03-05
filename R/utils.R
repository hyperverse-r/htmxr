# Internal utilities -----------------------------------------------------------

#' @noRd
.hx_trigger_value <- function(event) {
  if (is.character(event)) {
    paste(event, collapse = ", ")
  } else if (is.list(event) && !is.null(names(event))) {
    pairs <- mapply(
      function(k, v) paste0('"', k, '":', .hx_to_json(v)),
      names(event),
      event,
      SIMPLIFY = FALSE
    )
    paste0("{", paste(unlist(pairs), collapse = ","), "}")
  } else {
    stop("`event` must be a character vector or a named list.", call. = FALSE)
  }
}

# Minimal JSON serialiser for htmx event details.
# Supports: NULL, single logical, single numeric, single character, named list.
#' @noRd
.hx_to_json <- function(x) {
  if (is.null(x)) return("null")
  if (is.logical(x) && length(x) == 1L) return(if (x) "true" else "false")
  if (is.numeric(x) && length(x) == 1L) return(as.character(x))
  if (is.character(x) && length(x) == 1L) {
    x <- gsub("\\\\", "\\\\\\\\", x)
    x <- gsub('"', '\\"', x, fixed = TRUE)
    return(paste0('"', x, '"'))
  }
  if (is.list(x) && !is.null(names(x))) {
    pairs <- mapply(
      function(k, v) paste0('"', k, '":', .hx_to_json(v)),
      names(x),
      x,
      SIMPLIFY = FALSE
    )
    return(paste0("{", paste(unlist(pairs), collapse = ","), "}"))
  }
  stop("Unsupported value type in event detail: ", class(x)[1L], call. = FALSE)
}
