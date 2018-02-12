context("Catching errors")

expect_errors_with_message <- function(regexp, ...) {
  exprs <- eval(substitute(alist(...)))
  expectations <- lapply(exprs, function(expr)
    bquote(expect_error(.(expr), .(regexp)))
  )
  for (expectation in expectations)
    eval(expectation)
}

test_that("invalid pattern is caught", {
  expect_errors_with_message(
    "invalid pattern",
    {a} %<=% list(1),
    {a : b} %<=% list(1, 2),
    (a / b) %<=% list(1, 2),
    (a + b) %<=% list(1, 2),
    (a(b)) %<=% list(1, list(2))
  )
})

test_that("non-matching pattern is caught", {
  expect_errors_with_message(
    "pattern doesn't match value",
    (a) %<=% list(),
    (a) %<=% list(1, 2),
    ((a)) %<=% list(1),
    (((a))) %<=% list(1),
    (((a))) %<=% list(list(1)),
    (a : b) %<=% list(1),
    (a : b) %<=% list(1, 2, 3),
    (a : ... : b) %<=% list(1),
    (a : (b)) %<=% list(1, 2),
    (a : (b : c)) %<=% list(1, list(2, 3, 4))
  )
})
