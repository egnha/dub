#' Assign nested components of a list to names
#'
#' \code{\%<=\%} is an operator that enables you to assign nested components of
#' a list (or vector) to names via _pattern matching_. This is especially
#' convenient for:
#' - assigning individual names to the multiple values that a function may
#'   return as the components of a list
#' - extracting deeply nested list components
#'
#' @param pattern Pattern of names that the components of `value` are assigned
#'   to (see below).
#' @param value List or vector.
#'
#' @return Returns `value` invisibly.
#'
#' @section Pattern-matching names: Names are matched to the (nested) components
#'   of a list using an ad hoc pattern-matching syntax (coming from
#'   [Haskell](https://en.wikibooks.org/wiki/Haskell/Pattern_matching)) that
#'   mirrors the structure of the list. Use pairs of parentheses (`()`) to
#'   indicate a list, and a colon (`:`), rather than a comma, to indicate
#'   successive names. Use a dot (`.`) to skip assignment of a specific
#'   component, or dots (`...`) to skip assignment of a range of components.
#'
#' @examples
#' ## assign successive components
#' (one : two : three) %<=% list(1, 2, 3)
#' stopifnot(identical(list(one, two, three), list(1, 2, 3)))
#'
#' ## assign nested components
#' (p : (q : r : (s : t))) %<=% list(1, list(2, 3, list(4, 5)))
#' (P : (Q : R : S)) %<=% list(1, list(2, 3, list(4, 5)))
#' stopifnot(identical(list(p, q, r, s, t), list(1, 2, 3, 4, 5)),
#'           identical(list(P, Q, R, S), list(1, 2, 3, list(4, 5))))
#'
#' ## nested parentheses dig into a list
#' (w) %<=% list(1:3)
#' (((z))) %<=% list(list(list("z")))
#' ((x : y)) %<=% list(list("x", "y"))
#' stopifnot(w == 1:3, identical(list(x, y, z), list("x", "y", "z")))
#'
#' ## skip a component with a dot (.)
#' (a : . : b) %<=% list("a", "skip this", "b")
#' ((c : .) : .) %<=% list(list("c", "skip this"), "skip this")
#' stopifnot(identical(list(a, b, c), list("a", "b", "c")))
#'
#' ## skip a range of components with dots (...)
#' (first : ... : last) %<=% letters
#' (. : second : ...) %<=% letters
#' (mpg : cyl : ...) %<=% mtcars
#' stopifnot(identical(list(first, second, last), list("a", "b", "z")),
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
