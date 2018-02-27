assert <- function(cond, because)
  if (!cond) stop(because, call. = FALSE)

`%unless%` <- function(expr, reason)
  tryCatch(expr, error = function(.) stop(reason, call. = FALSE))
