#' Assign the components of a list or vector to names
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
#' (z) %<=% list(list(1))
#' ((x : y)) %<=% list(list(1, 2))
#'
#' @export
#' @rdname assign
#' @aliases %<=%
`%<=%` <- function(pattern, value) {
  val <- as.list(value)
  nms <- reify_names(substitute(pattern), tree(val))
  for (path in index_paths(nms)) {
    nm <- nms[[path]]
    if (assignable(nm))
      assign(nm, val[[path]], envir = parent.frame())
  }
  invisible(value)
}

assignable <- function(nm) nm != "."

#' @export
#' @rdname assign
`%=>%` <- opposite(`%<=%`)
