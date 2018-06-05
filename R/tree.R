tree <- function(x) {
  rapply(x, function(.) NULL, how = "replace")
}

index_paths <- function(x) {
  if (!is.list(x))
    return(NULL)
  indices <- lapply(seq_along(x), function(i) {
    subpaths <- index_paths(x[[i]]) %??% list(NULL)
    lapply(subpaths, function(path) c(i, path))
  })
  do.call("c", indices)
}
