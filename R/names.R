reify_names <- function(expr, tree) {
  is_enclosed(expr) %because% "pattern must be enclosed in parentheses"
  nms <- as_strings(expr)
  nms <- eval(nms, cons)[[1]] %unless% "pattern is invalid"
  dots_matched(nms, tree)
}

is_enclosed <- function(expr) {
  is.call(expr) && identical(expr[[1]], sym_paren)
}
sym_paren <- as.name("(")

cons <- emptyenv() %encloses% list(
  "(" = list,
  ":" = function(...) as.list(c(...))
)

as_strings <- function(expr) {
  if (!is.call(expr))
    return(as.character(expr))
  if (encloses_bare_name(expr))
    return(as_head(expr))
  (length(expr) > 1) %because%
    "pattern can only have names, not calls (missing ':'?)"
  for (i in 2:length(expr))
    expr[[i]] <- Recall(expr[[i]])
  expr
}

encloses_bare_name <- function(expr) {
  identical(expr[[1]], sym_paren) && is.symbol(expr[[2]])
}

as_head <- function(expr) {
  bquote((.(as.character(expr[[2]])) : NULL))
}

dots_matched <- function(nms, tree) {
  if (is_name(nms))
    return(nms)
  wh_dots <- which(nms == "...")
  (length(wh_dots) <= 1) %because% "multiple '...' at the same level are ambiguous"
  if (is_empty(wh_dots)) {
    (length(nms) == length(tree)) %because%
      "(sub)pattern without '...' must match all components at its level"
    return(Map(dots_matched, nms, tree))
  }
  n_dots <- length(tree) - length(nms) + 1
  (n_dots >= 0) %because%
    "(sub)pattern with '...' can't have more names than components at its level"
  dots <- rep(".", n_dots)
  before <-  seq_len(wh_dots - 1)
  after  <- -seq_len(wh_dots)
  rest   <- -seq_len(wh_dots - 1 + n_dots) %??% seq_along(tree)
  c(Recall(nms[before], tree[before]), dots, Recall(nms[after], tree[rest]))
}

is_name <- function(x) {
  is_string(x) && x != "..."
}
