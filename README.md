
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis build
status](https://travis-ci.org/egnha/dub.svg?branch=master)](https://travis-ci.org/egnha/dub)
[![Coverage
status](https://codecov.io/gh/egnha/dub/branch/master/graph/badge.svg)](https://codecov.io/github/egnha/dub?branch=master)
![Status](https://img.shields.io/badge/status-experimental-blue.svg)

# dub

*dub* is a tiny, single-purpose R package for *unpacking assignment*: it
provides an operator `%<=%` that enables you to assign components of a
list (or vector) to names, via pattern matching. Think of `<=` as a
pictograph representing multiple `<-`’s.

The pattern matching syntax, which comes from
[Haskell](https://en.wikibooks.org/wiki/Haskell/Pattern_matching), is
concise and flexible. It mirrors the semantics of `list()`.

``` r
library(dub)

(one : two : three) %<=% 1:3
one
#> [1] 1
two
#> [1] 2
three
#> [1] 3

(x) %<=% list(list("x"))
((y)) %<=% list(list("y"))
x
#> [[1]]
#> [1] "x"
y
#> [1] "y"

(u : (v : w)) %<=% list(1, list(2, 3:4))
u
#> [1] 1
v
#> [1] 2
w
#> [1] 3 4

# Use . to drop specific components, ... to drop greedily (the _ in Haskell)
(a : (. : (. : b) : ... : c)) %<=% list(1, list(2, list(3, 4), 5, 6, 7))
a
#> [1] 1
b
#> [1] 4
c
#> [1] 7
```

## Installation

``` r
# install.packages("devtools")
devtools::install_github("egnha/dub")
```

## Desiderata

The main objective of dub is to cover the most common cases of unpacking
assignment:

  - assigning the top-level components of a list
  - unpacking nested components

The pattern matching syntax should be economical and avoid conflict with
R’s established semantics. The code should be short and easy to grasp.

### Implementation

  - dub overloads `` `:` `` as a symbol concatenator, in a strictly
    localized context. There is no semantic conflict with the usual
    `` `:` ``, which is an operator of an altogether different type
    (namely, a range operator of integers).

  - To keep the code short, explicit validation is currently omitted.

The brevity of the code reflects the simplicity of unpacking assignment:
the leaves of the left-hand side of `%<=%` are matched, via `<-`, with
the leaves on the right-hand side. The only subtleties are to handle
greedy matching and make `` `:` `` right-associative.

## Prior art

Unpacking/multiple assignment appears in other languages, e.g.,
[Python](https://docs.python.org/3/tutorial/datastructures.html#tuples-and-sequences)
and
[Javascript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment).
While R has no such feature, using a custom operator to do this has long
been a folklore method. The earliest implementation that I could find is
due to [Gabor
Grothendieck](https://stat.ethz.ch/pipermail/r-help/2004-June/053343.html)
(2004).

I recommend the [zeallot](https://github.com/nteetor/zeallot) package by
[Nate Teetor](https://github.com/nteetor) as a more robust and
full-featured option for unpacking assignment.

## License

MIT Copyright © 2018 [Eugene Ha](https://github.com/egnha)
