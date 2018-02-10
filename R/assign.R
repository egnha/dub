assignable <- function(nm) nm != "."

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
  nms <- position_names(substitute(pattern), tree(val))
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

position_names <- function(expr, tree) {
  nms <- do.call("substitute", list(as_strings(expr), cons))
  nms <- as.list(eval(nms)[[1]])
  dots_expanded(nms, tree)
}

as_strings <- function(expr) {
  if (!is.call(expr))
    return(as.character(expr))
  for (i in 2:length(expr))
    expr[[i]] <- Recall(expr[[i]])
  expr
}

cons <- list("(" = quote(list), ":" = quote(concat))
concat <- function(...) as.list(c(...))

dots_expanded <- function(nms, tree) {
  if (encapsulates_string(nms))
    return(nms)
  wh_dots <- which(nms == "...")
  if (length(wh_dots) == 0)
    return(Map(dots_expanded, nms, tree))
  dots <- rep(".", length(tree) - length(nms) + 1)
  before <-  seq_len(wh_dots - 1)
  after  <- -seq_len(wh_dots)
  rest   <- -seq_len(wh_dots - 1 + length(dots))
  c(Recall(nms[before], tree[before]), dots, Recall(nms[after], tree[rest]))
}
