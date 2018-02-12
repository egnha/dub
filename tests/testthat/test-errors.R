context("Catching errors")

test_that("invalid pattern is caught", {
  expect_error((a / b) %<=% list(1, 2), "invalid pattern")
  expect_error((a + b) %<=% list(1, 2), "invalid pattern")
})

test_that("non-matching name is caught", {
  expect_error((a) %<=% list(), "'a' doesn't match component of value")
})

test_that("non-matching pattern is caught", {
  expect_error((a : b) %<=% list(1), "pattern doesn't match value")
  expect_error(((a : b)) %<=% list(1), "pattern doesn't match value")
  expect_error((a : (b : c)) %<=% list(1, 2), "pattern doesn't match value")
})

test_that("empty call in pattern is caught", {
  expect_error((a()) %<=% list(1), "pattern contains empty call 'a\\(\\)'")
})
