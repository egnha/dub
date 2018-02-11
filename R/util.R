opposite <- function(f) {
  formals(f) <- rev(formals(f))
  f
}
