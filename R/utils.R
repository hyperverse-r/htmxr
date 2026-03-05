# Internal utilities -----------------------------------------------------------

.hx_all_named <- function(x) {
  !is.null(names(x)) && all(!is.na(names(x)) & nzchar(names(x)))
}

#' @noRd
.hx_trigger_value <- function(event) {
  if (is.character(event)) {
    paste(event, collapse = ", ")
  } else if (is.list(event) && .hx_all_named(event)) {
    pairs <- mapply(
      function(k, v)
        paste0('"', .hx_escape_json_string(k), '":', .hx_to_json(v)),
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
# Supports: NULL, logical, numeric, character, atomic vector (→ array), named list.
#' @noRd
.hx_to_json <- function(x) {
  if (is.null(x)) return("null")
  if (is.logical(x) && length(x) == 1L) {
    if (is.na(x))
      stop("NA is not a valid JSON value in event details.", call. = FALSE)
    return(if (x) "true" else "false")
  }
  if (is.numeric(x) && length(x) == 1L) {
    if (!is.finite(x))
      stop(
        "NA, NaN, and Inf are not valid JSON values in event details.",
        call. = FALSE
      )
    return(as.character(x))
  }
  if (is.character(x) && length(x) == 1L) {
    return(paste0('"', .hx_escape_json_string(x), '"'))
  }
  # Atomic vectors of length > 1 → JSON array
  if (is.atomic(x) && length(x) > 1L) {
    return(paste0(
      "[",
      paste(vapply(x, .hx_to_json, character(1L)), collapse = ","),
      "]"
    ))
  }
  if (is.list(x) && .hx_all_named(x)) {
    pairs <- mapply(
      function(k, v)
        paste0('"', .hx_escape_json_string(k), '":', .hx_to_json(v)),
      names(x),
      x,
      SIMPLIFY = FALSE
    )
    return(paste0("{", paste(unlist(pairs), collapse = ","), "}"))
  }
  stop("Unsupported value type in event detail: ", class(x)[1L], call. = FALSE)
}

#' @noRd
.hx_escape_json_string <- function(x) {
  x <- gsub("\\\\", "\\\\\\\\", x)
  x <- gsub('"', '\\"', x, fixed = TRUE)
  x <- gsub("\n", "\\n", x, fixed = TRUE)
  x <- gsub("\r", "\\r", x, fixed = TRUE)
  x <- gsub("\t", "\\t", x, fixed = TRUE)
  x
}
