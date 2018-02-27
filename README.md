
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis build
status](https://travis-ci.org/egnha/dub.svg?branch=master)](https://travis-ci.org/egnha/dub)
[![Coverage
status](https://codecov.io/gh/egnha/dub/branch/master/graph/badge.svg)](https://codecov.io/github/egnha/dub?branch=master)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/dub)](https://cran.r-project.org/package=dub)

# dub

*dub* is a small, single-purpose R package for *unpacking assignment*:
it provides an operator `%<=%` that enables you to assign (nested)
components of a list (or vector) to names via pattern matching. Think of
the “dubble arrow” `<=` as a pictograph representing multiple `<-`’s.

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
(. : width : ... : species) %<=% iris
head(width)
#> [1] 3.5 3.0 3.2 3.1 3.6 3.9
head(species)
#> [1] setosa setosa setosa setosa setosa setosa
#> Levels: setosa versicolor virginica
```

More details and examples are in the package documentation,
`help(package = dub)`.

## Installation

Install from CRAN:

``` r
install.packages("dub")
```

Alternatively, install the development version from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("egnha/dub")
```

## Prior art

Unpacking/multiple assignment appears in other languages, e.g.,
[Python](https://docs.python.org/3/tutorial/datastructures.html#tuples-and-sequences)
and
[Javascript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment).
While R has no such feature, using a custom operator to do this has long
been a folklore method. To my knowledge, the earliest implementation is
by [Gabor
Grothendieck](https://stat.ethz.ch/pipermail/r-help/2004-June/053343.html)
(2004), cf. `list` in the
[gsubfn](https://cran.r-project.org/package=gsubfn) package.

If you need specialized forms of “destructured” assignment, I recommend
the [zeallot](https://github.com/nteetor/zeallot) package by [Nate
Teetor](https://github.com/nteetor).

## License

MIT Copyright © 2018 [Eugene Ha](https://github.com/egnha)
