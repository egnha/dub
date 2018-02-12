attempt <- function(expr, errmsg) {
  val <- tryCatch(expr, error = identity)
  assert(is_not_error(val), errmsg)
  val
}

is_not_error <- function(x)
  !inherits(x, "error")

assert <- function(cond, errmsg)
  if (!cond) stop(errmsg, call. = FALSE)
