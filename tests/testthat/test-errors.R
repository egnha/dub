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
    "pattern is invalid",
    {a} %<=% list(1),
    {a : b} %<=% list(1, 2),
    (a / b) %<=% list(1, 2),
    (a + b) %<=% list(1, 2),
    (a(b)) %<=% list(1, list(2))
  )
  expect_errors_with_message(
    "pattern can only have names, not calls \\(missing ':'\\?\\)",
    (a()) %<=% list(1, list(2))
  )
})

test_that("non-matching pattern is caught", {
  expect_errors_with_message(
    "\\(sub\\)pattern without '...' must match all components at its level",
    (a) %<=% list(),
    (a) %<=% list(1, 2),
    ((a)) %<=% list(1),
    (((a))) %<=% list(1),
    (((a))) %<=% list(list(1)),
    (a : b) %<=% list(1),
    (a : b) %<=% list(1, 2, 3),
    (a : (b)) %<=% list(1, 2),
    (a : (b : c)) %<=% list(1, list(2, 3, 4))
  )
  expect_errors_with_message(
    "\\(sub\\)pattern with '...' can't have more names than components at its level",
    (a : ...) %<=% list(),
    (... : a) %<=% list(),
    (... : a : b) %<=% list(1),
    (a : ... : b) %<=% list(1),
    (a : b : ...) %<=% list(1)
  )
})

test_that("ambiguous dots are caught", {
  expect_errors_with_message(
    "multiple '...' at the same level are ambiguous",
    (... : ...) %<=% list(1, 2, 3, 4),
    (a : b : ... : ...) %<=% list(1, 2, 3, 4),
    (a : ... : b : ...) %<=% list(1, 2, 3, 4),
    (a : ... : ... : b) %<=% list(1, 2, 3, 4),
    (... : a : b : ...) %<=% list(1, 2, 3, 4),
    (... : a : ... : b) %<=% list(1, 2, 3, 4),
    (... : ... : a : b) %<=% list(1, 2, 3, 4)
  )
})
