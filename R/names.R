reify_names <- function(expr, tree) {
  nms <- as_strings(expr)
  nms <- attempt(eval(nms, env_cons), "invalid pattern")
  attempt(dots_matched(nms[[1]], tree), "pattern doesn't match value")
}

env_cons <- new_env(
  "(" = list,
  ":" = function(...) as.list(c(...))
)

as_strings <- function(expr) {
  if (encloses_bare_name(expr))
    return(as_head(expr))
  if (!is.call(expr))
    return(as.character(expr))
  assert(length(expr) > 1, "pattern contains empty call {expr}")
  for (i in 2:length(expr))
    expr[[i]] <- Recall(expr[[i]])
  expr
}

encloses_bare_name <- function(expr)
  is_paren(expr) && is.symbol(expr[[2]])
is_paren <- function(expr)
  is.call(expr) && identical(expr[[1]], sym_paren)
sym_paren <- as.name("(")

as_head <- function(expr)
  bquote((.(as.character(expr[[2]])) : NULL))

dots_matched <- function(nms, tree) {
  if (encapsulates_name(nms))
    return(nms)
  wh_dots <- which(nms == "...")
  if (length(wh_dots) == 0)
    return(Map(dots_matched, nms, tree))
  dots <- rep(".", length(tree) - length(nms) + 1)
  before <-  seq_len(wh_dots - 1)
  after  <- -seq_len(wh_dots)
  rest   <- -seq_len(wh_dots - 1 + length(dots))
  c(Recall(nms[before], tree[before]), dots, Recall(nms[after], tree[rest]))
}

encapsulates_name <- function(x)
  length(x) == 1 && is.character(x[[1]]) && x[[1]] != "..."
