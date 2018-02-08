opposite <- function(f) {
  formals(f) <- rev(formals(f))
  f
}

#' Find all index paths of (the leaves of) a list
#'
#' @param x List.
#' @return List of index paths (integer vectors).
#'
#' @examples
#' x <- list(1, b = "b", c = list(d = "d", list(4)))
#' paths <- index_paths(x)
#' lapply(paths, function(path) x[[path]])
#' #> [[1]]
#' #> [1] 1
#' #>
#' #> [[2]]
#' #> [1] "b"
#' #>
#' #> [[3]]
#' #> [1] "d"
#' #>
#' #> [[4]]
#' #> [1] 4
#'
#' @noRd
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
