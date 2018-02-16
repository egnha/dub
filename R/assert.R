do <- function(expr, unless) {
  val <- tryCatch(expr, error = identity)
  assert(ok(val), unless)
  val
}

ok <- function(x) !inherits(x, "error")

assert <- function(cond, because)
  if (!cond) stop(because, call. = FALSE)
