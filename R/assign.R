#' Assign nested components of a list to names
#'
#' @description
#' The `%<<-%` operator assigns multiple (nested) components of a list or vector
#' to names via pattern matching (“unpacking assignment”). Think of the
#' “dub(ble) arrow” `<<-` as a pictograph representing multiple `<-`'s.
#'
#' `%<<-%` is especially convenient for:
#'
#' - assigning individual names to the multiple values that a function may
#'   return in the form of a list;
#'
#' - extracting deeply nested list components.
#'
#' @param pattern Pattern of names that the components of `value` are assigned
#'   to (see below).
#' @param value List or vector.
#'
#' @return Returns `value` invisibly.
#'
#' @section Pattern-matching names: Names are matched to the (nested) components
#'   of a list using a concise pattern matching syntax that mirrors the
#'   structure of the list. Apart from names, the syntax consists of two classes
#'   of symbols:
#'
#'   - **List constructors** — Use a pair of parentheses to indicate a list, and
#'     a colon, rather than a comma, to indicate successive names.
#'
#'   - **Wildcards** — Use a dot (`.`) to skip assignment of a specific
#'     component, or dots (`...`) to skip assignment of a range of components.
#'
#'   See the examples for an illustration of common use cases.
#'
#' @section Prior art: Unpacking/multiple assignment appears in other
#'   languages (e.g.,
#'   [Python](https://docs.python.org/3/tutorial/datastructures.html#tuples-and-sequences),
#'   [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment),
#'   [Clojure](https://clojure.org/guides/destructuring)).
#'   While R has no such feature, using a custom operator to do this has long
#'   been a folklore method. An early implementation is due to
#'   [Gabor Grothendieck](https://stat.ethz.ch/pipermail/r-help/2004-June/053343.html)
#'   (2004), cf. `list` in the
#'   [gsubfn](https://cran.r-project.org/package=gsubfn) package.
#'
#' @examples
#' # Assign successive components
#' (one : two : three) %<<-% list(1, 2, 3)
#' stopifnot(one == 1, two == 2, three == 3)
#'
#' # Assign nested components
#' (p : (q : r : (s : t))) %<<-% list(1, list(2, 3, list(4, 5)))
#' (P : (Q : R : S)) %<<-% list(1, list(2, 3, list(4, 5)))
#' stopifnot(p == 1, q == 2, r == 3, s == 4, t == 5,
#'           P == 1, Q == 2, R == 3, identical(S, list(4, 5)))
#'
#' # Unpack nested components with nested parentheses
#' (w) %<<-% list(1:3)
#' (((z))) %<<-% list(list(list("z")))
#' ((x : y)) %<<-% list(list("x", "y"))
#' stopifnot(w == 1:3, x == "x", y == "y", z == "z")
#'
#' # Skip a component with a dot (.)
#' (a : . : b) %<<-% list("a", "skip this", "b")
#' ((c : .) : .) %<<-% list(list("c", "skip this"), "skip this")
#' stopifnot(a == "a", b == "b", c == "c")
#'
#' # Skip a range of components with dots (...)
#' (first : ... : last) %<<-% letters
#' (. : second : ...) %<<-% letters
#' (mpg : cyl : ...) %<<-% mtcars
#' stopifnot(
#'   first == "a", second == "b", last == "z",
#'   mpg == mtcars$mpg, cyl == mtcars$cyl
#' )
#'
#' @export
#' @rdname assign
#' @aliases %<<-%
`%<<-%` <- function(pattern, value) {
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
`%->>%` <- opposite(`%<<-%`)
