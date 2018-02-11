expect_names <- function(..., all.names = TRUE) {
  nms <- ls(envir = parent.frame(), all.names = all.names)
  expect_identical(sort(nms), sort(c(...)))
}

context("Flat assignment")

test_that("flat lists can be assigned", {
  (a) %<=% list(1)
  (b : c) %<=% list(2, 3)
  (d : e : f) %<=% list(4, 5, 6)
  expect_names("a", "b", "c", "d", "e", "f")
  expect_equal(a, 1)
  expect_equal(b, 2)
  expect_equal(c, 3)
  expect_equal(d, 4)
  expect_equal(e, 5)
  expect_equal(f, 6)
})

test_that("vectors can be assigned", {
  (a) %<=% 1
  (b : c) %<=% 2:3
  (d : e : f) %<=% 4:6
  expect_names("a", "b", "c", "d", "e", "f")
  expect_equal(a, 1)
  expect_equal(b, 2)
  expect_equal(c, 3)
  expect_equal(d, 4)
  expect_equal(e, 5)
  expect_equal(f, 6)
})

context("Nested assignment")

test_that("nested lists can be assigned", {
  ((a)) %<=% list(list(1))
  (((b))) %<=% list(list(list(2)))
  ((((c)))) %<=% list(list(list(list(3))))
  expect_names("a", "b", "c")
  expect_equal(a, 1)
  expect_equal(b, 2)
  expect_equal(c, 3)

  (a : (b)) %<=% list(11, list(12))
  expect_equal(a, 11)
  expect_equal(b, 12)

  ((a) : b) %<=% list(list(21), 22)
  expect_equal(a, 21)
  expect_equal(b, 22)

  (a : ((b))) %<=% list(31, list(list(32)))
  expect_equal(a, 31)
  expect_equal(b, 32)

  (a : (b : (c))) %<=% list(41, list(42, list(43)))
  expect_equal(a, 41)
  expect_equal(b, 42)
  expect_equal(c, 43)

  (((a) : b) : c) %<=% list(list(list(51), 52), 53)
  expect_equal(a, 51)
  expect_equal(b, 52)
  expect_equal(c, 53)
})

test_that("consecutively nested lists can be assigned", {
  (a : (b)) %<=% list(1, list(list(2, 3)))
  expect_names("a", "b")
  expect_equal(a, 1)
  expect_equal(b, list(2, 3))

  ((a) : b) %<=% list(list(list(1, 2)), 3)
  expect_names("a", "b")
  expect_equal(a, list(1, 2))
  expect_equal(b, 3)

  (a : (b : (c))) %<=% list(1, list(2, list(list(3, 4))))
  expect_names("a", "b", "c")
  expect_equal(a, 1)
  expect_equal(b, 2)
  expect_equal(c, list(3, 4))

  (((a) : b) : c) %<=% list(list(list(list(1, 2)), 3), 4)
  expect_names("a", "b", "c")
  expect_equal(a, list(1, 2))
  expect_equal(b, 3)
  expect_equal(c, 4)

  (a : (b : c)) %<=% list(1, list(2, 3))
  expect_names("a", "b", "c")
  expect_equal(a, 1)
  expect_equal(b, 2)
  expect_equal(c, 3)

  (a : (b : (c : d))) %<=% list(1, list(2, list(3, 4)))
  expect_names("a", "b", "c", "d")
  expect_equal(a, 1)
  expect_equal(b, 2)
  expect_equal(c, 3)
  expect_equal(d, 4)
})

context("Skipping a specific assignment")

test_that("single dot ignores specific component", {
  (.) %<=% list(1)
  (. : .) %<=% list(1, 2)
  (. : . : .) %<=% list(1, 2, 3)
  expect_names(character())

  (a : .) %<=% list(1, 2)
  (. : b) %<=% list(1, 2)
  expect_names("a", "b")
  expect_equal(a, 1)
  expect_equal(b, 2)

  (a : . : .) %<=% list("a", 0, 0)
  (. : b : .) %<=% list(0, "b", 0)
  (. : . : c) %<=% list(0, 0, "c")
  expect_names("a", "b", "c")
  expect_identical(a, "a")
  expect_identical(b, "b")
  expect_identical(c, "c")

  (. : a : b) %<=% list(0, 1, 2)
  expect_equal(a, 1)
  expect_equal(b, 2)

  (a : . : b) %<=% list("a", 0, "b")
  expect_identical(a, "a")
  expect_identical(b, "b")

  (a : b : .) %<=% list(1, 2, 0)
  expect_equal(a, 1)
  expect_equal(b, 2)

  (. : (a : b)) %<=% list(0, list("a", "b"))
  expect_identical(a, "a")
  expect_identical(b, "b")

  (a : (. : b)) %<=% list(1, list(0, 2))
  expect_equal(a, 1)
  expect_equal(b, 2)

  (a : (b : .)) %<=% list("a", list("b", 0))
  expect_identical(a, "a")
  expect_identical(b, "b")
})

context("Skipping greedy ranges of assignments")

test_that("dots ignore greedily", {
  (. : ...) %<=% list(1, 2, 3)
  (... : .) %<=% list(1, 2, 3)
  expect_names(character())

  (a : ...) %<=% list(1, 2, 3)
  (... : b) %<=% list(1, 2, 3)
  expect_names("a", "b")
  expect_equal(a, 1)
  expect_equal(b, 3)

  (... : a : b) %<=% list(0, 1, 2, 3)
  expect_names("a", "b")
  expect_equal(a, 2)
  expect_equal(b, 3)

  (a : ... : b) %<=% list(0, 1, 2, 3)
  expect_names("a", "b")
  expect_equal(a, 0)
  expect_equal(b, 3)

  (a : b : ...) %<=% list(0, 1, 2, 3)
  expect_names("a", "b")
  expect_equal(a, 0)
  expect_equal(b, 1)

  (a : (b : ...)) %<=% list(1, list(2, 3, 4))
  (x : (... : y)) %<=% list(1, list(2, 3, 4))
  (u : (v : ... : w)) %<=% list(1, list(2, 3, 4))
  expect_names("a", "b", "x", "y", "u", "v", "w")
  expect_equal(a, 1)
  expect_equal(b, 2)
  expect_equal(x, 1)
  expect_equal(y, 4)
  expect_equal(u, 1)
  expect_equal(v, 2)
  expect_equal(w, 4)
})

test_that("dots can match zero components", {
  (a : ...) %<=% list(1)
  (... : b) %<=% list(2)
  (c : ... : d) %<=% list(3, 4)
  expect_names("a", "b", "c", "d")
  expect_equal(a, 1)
  expect_equal(b, 2)
  expect_equal(c, 3)
  expect_equal(d, 4)
})

test_that("dot and dots are compatible", {
  (a : . : ...) %<=% list("a", 0, 0, 0)
  (b : ... : .) %<=% list("b", 0, 0, 0)
  (. : c : ...) %<=% list(0, "c", 0, 0)
  (... : d : .) %<=% list(0, 0, "d", 0)
  (. : ... : e) %<=% list(0, 0, 0, "e")
  (... : . : f) %<=% list(0, 0, 0, "f")
  expect_names("a", "b", "c", "d", "e", "f")
  expect_identical(a, "a")
  expect_identical(b, "b")
  expect_identical(c, "c")
  expect_identical(d, "d")
  expect_identical(e, "e")
  expect_identical(f, "f")
})
