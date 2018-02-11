reify_names <- function(expr, tree) {
  nms <- do.call("substitute", list(as_strings(expr), cons))
  nms <- eval(nms)[[1]]
  dots_expanded(nms, tree)
}

cons <- list("(" = quote(list), ":" = quote(concat))
concat <- function(...) as.list(c(...))

as_strings <- function(expr) {
  if (encloses_bare_name(expr))
    return(as_get_first(expr))
  if (!is.call(expr))
    return(as.character(expr))
  for (i in 2:length(expr))
    expr[[i]] <- Recall(expr[[i]])
  expr
}

encloses_bare_name <- function(expr)
  is_paren(expr) && is.symbol(expr[[2]])
is_paren <- function(expr)
  is.call(expr) && identical(expr[[1]], sym_paren)
sym_paren <- as.name("(")

as_get_first <- function(expr)
  bquote((.(as.character(expr[[2]])) : NULL))

dots_expanded <- function(nms, tree) {
  if (encapsulates_name(nms))
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

encapsulates_name <- function(x)
  length(x) == 1 && is.character(x[[1]]) && x[[1]] != "..."
