opposite <- function(f) {
  formals(f) <- rev(formals(f))
  f
}

encapsulates_string <- function(x)
  length(x) == 1 && is.character(x[[1]])
