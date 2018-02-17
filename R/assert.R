do <- function(expr, unless)
  tryCatch(expr, error = function(.) stop(unless, call. = FALSE))

assert <- function(cond, because)
  if (!cond) stop(because, call. = FALSE)
