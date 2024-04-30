
<!-- README.md is generated from README.Rmd. Please edit that file -->

# trud <a href="https://rmgpanw.github.io/trud/"><img src="man/figures/logo.png" align="right" height="138"/></a>

<!-- badges: start -->
<!-- badges: end -->

The goal of trud is to provide a convenient R interface to the [NHS TRUD
API](https://isd.digital.nhs.uk/trud/users/guest/filters/0/api).

## Installation

You can install the development version of trud from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rmgpanw/trud")
```

## Examples

Retrieve available endpoints:

``` r
library(trud)

trud_items()
#> # A tibble: 68 × 2
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
#>  9        1819 Emergency Care Data Set XML Schema                          
#> 10         263 eViewer application                                         
#> # ℹ 58 more rows
```

Get metadata for an item:

``` r
# default is to retrieve metadata for the latest release only
get_item_metadata(1799)
#> $apiVersion
#> [1] "1"
#> 
#> $releases
#> # A tibble: 28 × 20
#>    id      name  releaseDate archiveFileUrl archiveFileName archiveFileSizeBytes
#>    <chr>   <chr> <chr>       <chr>          <chr>                          <int>
#>  1 uk_sct… Rele… 2024-04-17  https://isd.d… uk_sct2mo_38.0…            547373910
#>  2 uk_sct… Rele… 2024-03-20  https://isd.d… uk_sct2mo_37.6…            541961449
#>  3 uk_sct… Rele… 2024-02-21  https://isd.d… uk_sct2mo_37.5…            541678075
#>  4 uk_sct… Rele… 2024-01-24  https://isd.d… uk_sct2mo_37.4…            541270677
#>  5 uk_sct… Rele… 2023-12-22  https://isd.d… uk_sct2mo_37.3…            541060019
#>  6 uk_sct… Rele… 2023-11-29  https://isd.d… uk_sct2mo_37.2…            539925981
#>  7 uk_sct… Rele… 2023-11-01  https://isd.d… uk_sct2mo_37.1…            539238944
#>  8 uk_sct… Rele… 2023-10-04  https://isd.d… uk_sct2mo_37.0…            538818704
#>  9 uk_sct… Rele… 2023-09-06  https://isd.d… uk_sct2mo_36.5…            533585124
#> 10 uk_sct… Rele… 2023-08-09  https://isd.d… uk_sct2mo_36.4…            533079368
#> # ℹ 18 more rows
#> # ℹ 14 more variables: archiveFileSha256 <chr>,
#> #   archiveFileLastModifiedTimestamp <chr>, checksumFileUrl <chr>,
#> #   checksumFileName <chr>, checksumFileSizeBytes <int>,
#> #   checksumFileLastModifiedTimestamp <chr>, signatureFileUrl <chr>,
#> #   signatureFileName <chr>, signatureFileSizeBytes <int>,
#> #   signatureFileLastModifiedTimestamp <chr>, publicKeyFileUrl <chr>, …
#> 
#> $httpStatus
#> [1] 200
#> 
#> $message
#> [1] "OK"
```

Download an item:

``` r
# by default this will be downloaded to the current working directory
if (FALSE) {
  download_item(1799)
}
```
