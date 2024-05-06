
<!-- README.md is generated from README.Rmd. Please edit that file -->

# trud <a href="https://rmgpanw.github.io/trud/"><img src="man/figures/logo.png" align="right" height="138"/></a>

<!-- badges: start -->

[![pkgdown](https://github.com/rmgpanw/trud/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/rmgpanw/trud/actions/workflows/pkgdown.yaml)
[![Codecov test
coverage](https://codecov.io/gh/rmgpanw/trud/branch/main/graph/badge.svg)](https://app.codecov.io/gh/rmgpanw/trud?branch=main)

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

You will also need to:

- [Sign up for an
  account](https://isd.digital.nhs.uk/trud/users/guest/filters/0/account/form)
  with NHS TRUD
- Set your API key (shown on your account information page) as an
  environmental variable named `TRUD_API_KEY`. The best way to do this
  is by placing your API key in a [`.Renviron`
  file](https://rstats.wtf/r-startup.html#renviron).

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
get_item_metadata(1760) |>
  purrr::map_at("releases", \(release) purrr::map(release, names))
#> $apiVersion
#> [1] "1"
#> 
#> $releases
#> $releases$CHC_JSON_v1.0.2.zip
#>  [1] "id"                                 "name"                              
#>  [3] "releaseDate"                        "archiveFileUrl"                    
#>  [5] "archiveFileName"                    "archiveFileSizeBytes"              
#>  [7] "archiveFileSha256"                  "archiveFileLastModifiedTimestamp"  
#>  [9] "checksumFileUrl"                    "checksumFileName"                  
#> [11] "checksumFileSizeBytes"              "checksumFileLastModifiedTimestamp" 
#> [13] "signatureFileUrl"                   "signatureFileName"                 
#> [15] "signatureFileSizeBytes"             "signatureFileLastModifiedTimestamp"
#> [17] "publicKeyFileUrl"                   "publicKeyFileName"                 
#> [19] "publicKeyFileSizeBytes"             "publicKeyId"                       
#> 
#> 
#> $httpStatus
#> [1] 200
#> 
#> $message
#> [1] "OK"
```

Download an item:

``` r
# by default this will be downloaded to `tempdir()`
x <- download_item(1760)
#> ⠙ Downloading archive file for TRUD item 1760...
#> ✔ Downloading archive file for TRUD item 1760... [126ms]
#> 
#> ℹ Successfully downloaded `CHC_JSON_v1.0.2.zip` to '/var/folders/3_/pbrb8ydn6_q…
#> ✔ Successfully downloaded `CHC_JSON_v1.0.2.zip` to '/var/folders/3_/pbrb8ydn6_q…
#> 
unzip(x, list = TRUE)
#>                                             Name Length                Date
#> 1        JSON_CHC_V1_0_2_Simple_Schema_v1.1.json  14224 2022-01-27 12:01:00
#> 2 JSON_CHC_V1_0_2_Simple_Schema_SAMPLE_DATA.json   5492 2022-01-27 14:23:00
#> 3          CHC Production Log - JSON SIMPLE.xlsx  21520 2022-01-27 14:33:00
```
