
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dub

*dub* is a tiny R package that provides an operator `%<=%` that enables
you to use *pattern matching* to selectively assign the components of a
list or vector to names (*unpacking assignment*). Think of `<=` as a
pictograph representing multiple `<-`’s.

``` r
library(dub)

(one : two : three) %<=% c(1, 2, 3)
one
#> [1] 1
two
#> [1] 2
three
#> [1] 3

(x) %<=% list(1)
x
#> [1] 1

((y : z)) %<=% list(list(1, list(2, 3)))
y
#> [1] 1
z
#> [[1]]
#> [1] 2
#> 
#> [[2]]
#> [1] 3

# Use a dot to drop components
(a : (. : (. : b))) %<=% list(1, list(2, list(3, 4), 5))
a
#> [1] 1
b
#> [1] 4
```

The pattern matching syntax comes from
[Haskell](https://en.wikibooks.org/wiki/Haskell/Pattern_matching). It
shares the semantics of `list()` (but not of `c()`).

## Installation

Install from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("egnha/dub")
```

## Design choices

  - The ad hoc pattern-matching syntax is very compact and avoids
    conflicting with R’s existing semantics. (dub appropriates `` `:` ``
    as a symbol concatenator, in a strictly localized context; the usual
    `` `:` `` is a operator of an altogether different type and
    semantics.)

  - The code is kept deliberately small—around 40 lines—to make it easy
    to grasp (granting some familiarity with [computing on the
    language](https://cran.r-project.org/doc/manuals/r-release/R-lang.html#Computing-on-the-language)).

The code is small because unpacking assignment is conceptually simple.
The tree structure of the pattern on the left-hand side of `%<=%`
mirrors that of the value on the right-hand side. In particular, they
have the same leaves. Assignment is made by mapping over the non-dot
leaves. The only subtlety is to make `` `:` `` an associative operator.

## Prior art

Unpacking/multiple assignment appears in other languages, e.g.,
[Python](https://docs.python.org/3/tutorial/datastructures.html#tuples-and-sequences)
and
[Javascript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment).
While R has no such feature built-in, the idea of using a custom
operator to do this has long been folklore knowledge. The earliest
implementation that I could find is due to [Gabor
Grothendieck](https://stat.ethz.ch/pipermail/r-help/2004-June/053343.html)
(2004).

If you’re looking for a more robust and full-featured option for tuple
unpacking, or you want to combine subsequence splicing and assignment in
a single operation, use the
[zeallot](https://github.com/nteetor/zeallot) package by [Nate
Teetor](https://github.com/nteetor).

## License

MIT Copyright © 2018 [Eugene Ha](https://github.com/egnha)
