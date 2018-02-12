context("Catching errors")

expect_error_with <- function(regexp)
  function(...) expect_error(regexp = regexp, ...)

test_that("invalid pattern is caught", {
  expect_invalid_pattern <- expect_error_with("invalid pattern")

  expect_invalid_pattern({a} %<=% list(1))
  expect_invalid_pattern({a : b} %<=% list(1, 2))
  expect_invalid_pattern((a / b) %<=% list(1, 2))
  expect_invalid_pattern((a + b) %<=% list(1, 2))
  expect_invalid_pattern((a(b)) %<=% list(1, list(2)))
})

test_that("non-matching pattern is caught", {
  expect_nonmatching <- expect_error_with("pattern doesn't match value")

  expect_nonmatching((a) %<=% list())
  expect_nonmatching((a) %<=% list(1, 2))
  expect_nonmatching(((a)) %<=% list(1))
  expect_nonmatching((((a))) %<=% list(1))
  expect_nonmatching((((a))) %<=% list(list(1)))
  expect_nonmatching((a : b) %<=% list(1))
  expect_nonmatching((a : b) %<=% list(1, 2, 3))
  expect_nonmatching((a : ... : b) %<=% list(1))
  expect_nonmatching((a : (b)) %<=% list(1, 2))
  expect_nonmatching((a : (b : c)) %<=% list(1, list(2, 3, 4)))
})
