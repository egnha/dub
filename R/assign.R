#' Assign multiple components of a list to names
#'
#' The \code{\%<=\%} operator enables you to assign multiple components of a
#' list (or vector) to names, via _pattern matching_. This is especially
#' convenient when a function returns multiple values as a list and you want to
#' assign individual names to them.
#'
#' @param pattern Assignment pattern (see below).
#' @param value List or vector.
#'
#' @return Returns `value` invisibly.
#'
#' @section Assignment pattern: An _assignment pattern_ is a concise, ad hoc
#'   syntax for matching names to the (nested) components of a list, by
#'   mirroring the structure of the list. Use pairs of parentheses (`()`) to
#'   indicate a list and a colon (`:`) to indicate successive names. A specific
#'   component, or range of components, can be skipped with a dot (`.`), or dots
#'   (`...`).
#'
#' @examples
#' ## assign successive components
#' (one : two : three) %<=% list(1, 2, 3)
#' stopifnot(c(one, two, three) == 1:3)
#'
#' ## assign nested components
#' (p : (q : r : (s : t))) %<=% list(1, list(2, 3, list(4, 5)))
#' stopifnot(c(p, q, r, s, t) == 1:5)
#'
#' ## nested parentheses dig into a list
#' (w) %<=% list(1:3)
#' (((z))) %<=% list(list(list(3)))
#' ((x : y)) %<=% list(list(1, 2))
#' stopifnot(w == 1:3, c(x, y, z) == 1:3)
#'
#' ## skip components with a dot (.)
#' (a : . : b) %<=% list("a", "skip this", "b")
#' ((c : .) : .) %<=% list(list("c", "skip this"), "skip this")
#' stopifnot(c(a, b, c) == c("a", "b", "c"))
#'
#' ## skip ranges with dots (...)
#' (first : ... : last) %<=% letters
#' (. : second : ...) %<=% letters
#' (mpg : cyl : ...) %<=% mtcars
#' stopifnot(c(first, second, last) == c("a", "b", "z"),
#'           mpg == mtcars$mpg, cyl == mtcars$cyl)
#'
#' @export
#' @rdname assign
#' @aliases %<=%
`%<=%` <- function(pattern, value) {
  val <- as.list(value)
  nms <- reify_names(substitute(pattern), tree(val))
  for (path in index_paths(nms)) {
    nm <- nms[[path]]
    if (assignable(nm))
      assign(nm, val[[path]], envir = parent.frame())
  }
  invisible(value)
}

assignable <- function(nm) nm != "."

#' @export
#' @rdname assign
`%=>%` <- opposite(`%<=%`)
