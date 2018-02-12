# `msg` may be an interpolated string, e.g., "foo {bar} and {baz}",
# where `bar` and `baz` are names in the calling environment of assert()
assert <- function(cond, msg) {
  if (!cond)
    stop(interpolate(msg, parent.frame()), call. = FALSE)
}

interpolate <- function(text, env) {
  matches <- gregexpr("\\{.*?\\}", text)
  nms <- interpolated_names(text, matches, env)
  regmatches(text, matches) <- "%s"
  sprintf(text, nms)
}

interpolated_names <- function(text, matches, env) {
  nms <- regmatches(text, matches)[[1]]
  nms <- gsub("[\\{\\}]", "", nms)
  vapply(nms, function(nm) deparse(get(nm, envir = env)), character(1))
}
