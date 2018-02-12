`%||%` <- function(lhs, rhs)
  if (is.null(lhs)) rhs else lhs

opposite <- function(f) {
  formals(f) <- rev(formals(f))
  f
}

bind_to_env <- function(...)
  list2env(list(...), parent = emptyenv())
