`%because%` <- function(cond, reason)
  if (!cond) stop(reason, call. = FALSE)

`%unless%` <- function(expr, exception)
  tryCatch(expr, error = function(.) stop(exception, call. = FALSE))
