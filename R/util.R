`%??%` <- function(lhs, rhs)
  if (length(lhs) == 0) rhs else lhs

is_string <- function(x)
  length(x) == 1 && is.character(x)

opposite <- function(f) {
  formals(f) <- rev(formals(f))
  f
}

bind_to_env <- function(...)
  list2env(list(...), parent = emptyenv())
