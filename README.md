
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
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/grand-total/trud)](https://CRAN.R-project.org/package=trud)
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

`trud` enables seamless, programmatic retrieval and updating of NHS TRUD
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
with NHS TRUD and set up your API key as described in
`vignette("trud")`.

## Getting Started

### Understanding TRUD Subscriptions

**Important**: NHS TRUD operates on a subscription model. After creating
your account, you must individually subscribe to each item you want to
access through the [NHS TRUD
website](https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/1).

### Recommended Workflow

**Step 1**: Check what you’re already subscribed to:

``` r
library(trud)

# See items you can currently access
get_subscribed_metadata()
#>  ■■■■■■■■■■■■■■■■■■■■■■■■          77% |  ETA:  1s
#> # A tibble: 17 × 3
#>    item_number item_name                                            metadata    
#>          <int> <chr>                                                <list>      
#>  1         394 Community Services Data Set pre-deadline extract XM… <named list>
#>  2         239 dm+d XML transformation tool                         <named list>
#>  3         263 eViewer application                                  <named list>
#>  4         398 Global Trade Item Number to OPCS-4 code cross refer… <named list>
#>  5        1760 NHS Continuing Health Care (CHC) Data Set - JSON Sc… <named list>
#>  6         719 NHS Continuing Health Care (CHC) Data Set - XML Sch… <named list>
#>  7           9 NHS Data Migration                                   <named list>
#>  8         258 NHS ICD-10 5th Edition data files                    <named list>
#>  9           8 NHS Read Browser                                     <named list>
#> 10          19 NHS UK Read Codes Clinical Terms Version 3           <named list>
#> 11         255 NHS UK Read Codes Clinical Terms Version 3, Cross M… <named list>
#> 12          24 NHSBSA dm+d                                          <named list>
#> 13         264 OPCS-4 eVersion book                                 <named list>
#> 14         659 Primary Care Domain reference sets                   <named list>
#> 15         101 SNOMED CT UK Clinical Edition, RF2: Full, Snapshot … <named list>
#> 16          98 SNOMED CT UK Data Migration Workbench                <named list>
#> 17        1799 SNOMED CT UK Monolith Edition, RF2: Snapshot         <named list>
```

**Step 2**: Browse all available items (note: subscription required for
access):

``` r
# List all available TRUD items
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

**Step 3**: Subscribe to additional items you need via the [NHS TRUD
website](https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/1),
then access them:

``` r
# After subscribing to an item (e.g., item 394), you can:

# Get metadata
metadata <- get_item_metadata(394)

# Download the item
file_path <- download_item(394, directory = tempdir())
```

## Available functionality

The main functions provided by `trud` are:

- `get_subscribed_metadata()`: Shows items you can currently access
- `trud_items()`: Lists all available items
- `get_item_metadata()`: Retrieves metadata for a specific item
- `download_item()`: Downloads files for a specific item

Please see `vignette("trud")` for further information and getting
started.

## Citing trud

If you find `trud` useful, please consider citing it. Citation details
are available
[here](https://rmgpanw.github.io/trud/authors.html#citation).

## Community guidelines

Feedback, bug reports, and feature requests are welcome; file issues or
seek support [here](https://github.com/rmgpanw/trud/issues). If you
would like to contribute to the package, please see our [contributing
guidelines](https://rmgpanw.github.io/trud/CONTRIBUTING.html).

Please note that this package is released with a [Contributor Code of
Conduct](https://rmgpanw.github.io/trud/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
