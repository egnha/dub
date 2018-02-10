expect_names <- function(...) {
  nms <- ls(envir = parent.frame())
  expect_identical(sort(nms), sort(c(...)))
}

context("Flat assignment")

test_that("vector components can be assigned", {
  (x1 : y1 : z1) %<=% 1:3
  1:3 %=>% (x2 : y2 : z2)
  expect_names("x1", "y1", "z1", "x2", "y2", "z2")
  expect_equal(x1 - 1, x2 - 1)
  expect_equal(y1 - 2, y2 - 2)
  expect_equal(z1 - 3, z2 - 3)
})

test_that("flat list components can be assigned", {
  (x1 : y1 : z1) %<=% list(1, 2, 3)
  list(1, 2, 3) %=>% (x2 : y2 : z2)
  expect_names("x1", "y1", "z1", "x2", "y2", "z2")
  expect_equal(x1 - 1, x2 - 1)
  expect_equal(y1 - 2, y2 - 2)
  expect_equal(z1 - 3, z2 - 3)
})

test_that("singletons can be assigned using bare parentheses", {
  (x) %<=% list("x")
  (y) %<=% "y"
  expect_names("x", "y")
  expect_identical(x, "x")
  expect_identical(y, "y")
})

context("Nested assignment")

test_that("nested components can be assigned", {
  (x : (y : z) : (((w)))) %<=% list(1, list(2, list(3, 4)), list(list(5)))
  expect_names("x", "y", "z", "w")
  expect_equal(x, 1)
  expect_equal(y, 2)
  expect_equal(z, list(3, 4))
  expect_equal(w, 5)
})

context("Skipping assignment")

test_that("a single bare dot makes no assignment whatsoever", {
  (.) %<=% list(1, 2, 3)
  expect_names(character())
})

test_that("dots ignore intervening components", {
  (x : ... : (... : (y : ...)) : z) %<=% list(1, 2, list(3, 4, list(5, 6)), 7)
  (first : ... : (... : last)) %<=% c(letters, list(as.list(LETTERS)))
  expect_names("x", "y", "z", "first", "last")
  expect_equal(x, 1)
  expect_equal(y, 5)
  expect_equal(z, 7)
  expect_identical(first, "a")
  expect_identical(last , "Z")
})

test_that("a dot skips assignment", {
  value <- list(1, 2, 3, list(4, 5))
  (x : ...) %<=% value
  (. : y : ...) %<=% value
  (. : . : z : ...) %<=% value
  (... : (. : w)) %<=% value
  expect_names("x", "y", "z", "w", "value")
  expect_equal(x, 1)
  expect_equal(y, 2)
  expect_equal(z, 3)
  expect_equal(w, 5)
})

test_that("singletons can be assigned by matching first", {
  (x : .) %<=% list("head")
  (y : ...) %<=% list("head")
  expect_names("x", "y")
  expect_identical(x, "head")
  expect_identical(y, "head")
})

test_that("tail can be matched by dots", {
  (... : x) %<=% list(1, 2, "tail")
  expect_names("x")
  expect_equal(x, "tail")
})
