
<!-- README.md is generated from README.Rmd. Please edit that file -->

# trud <a href="https://rmgpanw.github.io/trud/"><img src="man/figures/logo.png" align="right" height="138"/></a>

<!-- badges: start -->

[![pkgdown](https://github.com/rmgpanw/trud/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/rmgpanw/trud/actions/workflows/pkgdown.yaml)
[![Codecov test
coverage](https://codecov.io/gh/rmgpanw/trud/branch/main/graph/badge.svg)](https://app.codecov.io/gh/rmgpanw/trud?branch=main)
[![R-CMD-check](https://github.com/rmgpanw/trud/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/rmgpanw/trud/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/trud)](https://CRAN.R-project.org/package=trud)
[![](https://cranlogs.r-pkg.org/badges/last-month/trud)](https://cran.r-project.org/package=trud)
[![Repo
Status](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Status at rOpenSci Software Peer
Review](https://badges.ropensci.org/705_status.svg)](https://github.com/ropensci/software-review/issues/705)
<!-- badges: end -->

The goal of `trud` is to provide a convenient R interface to the
[National Health Service (NHS) England Technology Reference data Update
Distribution
(TRUD)](https://isd.digital.nhs.uk/trud/users/guest/filters/0/api).

The NHS TRUD service provides essential reference files that underpin a
wide range of electronic health record (EHR) areas, both in the UK and
internationally. These files include clinical coding systems such as
ICD, Read codes, prescription codes, and the SNOMED CT ontology, with
regular updates to reflect new knowledge and changes in clinical
practice. NHS TRUD content supports key research areas like disease
phenotyping, cohort selection, epidemiology, health services research,
and the development of risk prediction models.

trud enables seamless, programmatic retrieval and updating of NHS TRUD
release items, removing the need for manual downloads and reducing the
risk of errors or version drift. This helps researchers maintain
reproducible, up-to-date analyses — whether as part of ad-hoc studies or
automated pipelines.

To learn more about NHS TRUD and its available resources, visit the [NHS
TRUD website](https://isd.digital.nhs.uk/trud).

## Installation

You can install this package from CRAN:

``` r
install.packages("trud")
```

Or you can install the development version of `trud` from
[GitHub](https://github.com/rmgpanw/trud) with:

``` r
# install.packages("pak")
pak::pak("rmgpanw/trud")
```

You will also need to [sign up for a free
account](https://isd.digital.nhs.uk/trud/users/guest/filters/0/account/form)
with NHS TRUD

## Available functionality

The main functions provided by trud are `get_item_metadata()` and
`download_item()`. Use `trud_items()` to list available items and their
IDs, as retrieved from the [NHS TRUD
website](https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/1):

``` r
library(trud)
trud_items()
#> # A tibble: 73 × 2
#>    item_number item_name                                                        
#>          <int> <chr>                                                            
#>  1         246 Cancer Outcomes and Services Data Set XML Schema                 
#>  2         245 Commissioning Data Set XML Schema                                
#>  3         599 Community Services Data Set Intermediate Database                
#>  4         393 Community Services Data Set post-deadline extract XML Schema     
#>  5         394 Community Services Data Set pre-deadline extract XML Schema      
#>  6         391 Community Services Data Set XML Schema                           
#>  7         248 Diagnostic Imaging Data Set XML Schema                           
#>  8         239 dm+d XML transformation tool                                     
#>  9        1859 Electronic Prescribing and Medicines Administration Data Sets XM…
#> 10        1819 Emergency Care Data Set XML Schema                               
#> # ℹ 63 more rows
```

Please see `vignette("trud")` for further information and getting
started.

## Citing trud

If you find trud useful, please consider citing it. Citation details are
available [here](https://rmgpanw.github.io/trud/authors.html#citation).

## Community guidelines

Feedback, bug reports, and feature requests are welcome; file issues or
seek support [here](https://github.com/rmgpanw/trud/issues). If you
would like to contribute to the package, please see our [contributing
guidelines](https://rmgpanw.github.io/trud/CONTRIBUTING.html).

Please note that this package is released with a [Contributor Code of
Conduct](https://rmgpanw.github.io/trud/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
