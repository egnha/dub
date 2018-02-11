tree <- function(x)
  rapply(x, function(.) NULL, how = "replace")

index_paths <- function(x) {
  if (!is.list(x))
    return(NULL)
  indices <- lapply(seq_along(x), function(i)
    if (is.list(x[[i]]) && length(x[[i]])) {
      sub_paths <- index_paths(x[[i]])
      lapply(sub_paths, function(path) c(i, path))
    } else
      list(i)
  )
  do.call("c", indices)
}
