`%??%` <- function(lhs, rhs) {
  if (is_empty(lhs)) rhs else lhs
}

is_empty <- function(x) {
  length(x) == 0
}

is_string <- function(x) {
  length(x) == 1 && is.character(x)
}

opposite <- function(f) {
  formals(f) <- rev(formals(f))
  f
}

`%encloses%` <- function(parent, bindings) {
  list2env(bindings, parent = parent)
}
