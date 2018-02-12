reify_names <- function(expr, tree) {
  nms <- as_strings(expr)
  nms <- attempt(eval(nms, cons)[[1]], "invalid pattern")
  attempt(dots_matched(nms, tree), "pattern doesn't match value")
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
  assert(length(expr) > 1, "invalid pattern")
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
  if (encapsulates_name(nms))
    return(nms)
  wh_dots <- which(nms == "...")
  if (length(wh_dots) == 0) {
    assert(length(nms) == length(tree), "pattern doesn't match value")
    return(Map(dots_matched, nms, tree))
  }
  dots <- rep(".", length(tree) - length(nms) + 1)
  before <-  seq_len(wh_dots - 1)
  after  <- -seq_len(wh_dots)
  rest   <- -seq_len(wh_dots - 1 + length(dots))
  c(Recall(nms[before], tree[before]), dots, Recall(nms[after], tree[rest]))
}

encapsulates_name <- function(x)
  length(x) == 1 && is.character(x[[1]]) && x[[1]] != "..."
