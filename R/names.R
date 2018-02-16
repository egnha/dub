reify_names <- function(expr, tree) {
  nms <- as_strings(expr)
  nms <- do(eval(nms, cons)[[1]], unless = "pattern is invalid")
  dots_matched(nms, tree)
}

cons <- bind_to_env(
  "(" = list,
  ":" = function(...) as.list(c(...))
)

as_strings <- function(expr) {
  if (!is.call(expr))
    return(as.character(expr))
  if (encloses_bare_name(expr))
    return(as_head(expr))
  assert(length(expr) > 1,
         because = "pattern can only have names, not calls (missing ':'?)")
  for (i in 2:length(expr))
    expr[[i]] <- Recall(expr[[i]])
  expr
}

encloses_bare_name <- function(expr)
  identical(expr[[1]], sym_paren) && is.symbol(expr[[2]])
sym_paren <- as.name("(")

as_head <- function(expr)
  bquote((.(as.character(expr[[2]])) : NULL))

dots_matched <- function(nms, tree) {
  if (is_name(nms))
    return(nms)
  wh_dots <- which(nms == "...")
  assert(length(wh_dots) <= 1,
         because = "multiple '...' at the same level are ambiguous")
  if (is_empty(wh_dots)) {
    assert(length(nms) == length(tree),
           because = "pattern without '...' must match all components of value")
    return(Map(dots_matched, nms, tree))
  }
  n_dots <- length(tree) - length(nms) + 1
  assert(n_dots >= 0,
         because = "pattern with '...' can't have more components than value")
  dots <- rep(".", n_dots)
  before <-  seq_len(wh_dots - 1)
  after  <- -seq_len(wh_dots)
  rest   <- -seq_len(wh_dots - 1 + n_dots) %??% seq_along(tree)
  c(Recall(nms[before], tree[before]), dots, Recall(nms[after], tree[rest]))
}

is_name <- function(x)
  is_string(x) && x != "..."
