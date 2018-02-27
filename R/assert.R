assert <- function(cond, because)
  if (!cond) stop(because, call. = FALSE)

`%unless%` <- function(expr, exception)
  tryCatch(expr, error = function(.) stop(exception, call. = FALSE))
