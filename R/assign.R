assignable <- function(nm) nm != "."

#' Assign names to the components of a list or vector
#'
#' @param pattern Assignment pattern (see examples).
#' @param value List or vector.
#'
#' @return Returns `value` invisibly.
#'
#' @examples
#' (one : two) %<=% c(1, 2)
#' (one : two) %<=% 1:2
#' (p : (q : r : s)) %<=% list(1, list(2, 3, 4))
#' (a : (. : (c : d) : e)) %<=% list(1, list(2, list(3, 4), 5))
#' (. : (. : b : .)) %<=% list(1, list(2, list(3, 4), 5))
#' (z : .) %<=% list(list(1))
#' ((x : y)) %<=% list(list(1, 2))
#'
#' @export
#' @name assign
`%<=%` <- function(pattern, value) {
  nms <- positioned_names(substitute(pattern))
  val <- as.list(value)
  for (path in index_paths(nms)) {
    nm <- nms[[path]]
    if (assignable(nm))
      assign(nm, val[[path]], envir = parent.frame())
  }
  invisible(value)
}

#' @export
#' @rdname assign
`%=>%` <- opposite(`%<=%`)

positioned_names <- function(expr) {
  nms <- do.call("substitute", list(as_strings(expr), struts))
  eval(nms)[[1]]
}

as_strings <- function(expr) {
  if (!is.call(expr))
    return(as.character(expr))
  for (i in 2:length(expr))
    expr[[i]] <- Recall(expr[[i]])
  expr
}

struts <- list("(" = quote(list), ":" = quote(concat))
concat <- function(...) as.list(c(...))