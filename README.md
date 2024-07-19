
<!-- README.md is generated from README.Rmd. Please edit that file -->

# trud <a href="https://rmgpanw.github.io/trud/"><img src="man/figures/logo.png" align="right" height="138"/></a>

<!-- badges: start -->

[![pkgdown](https://github.com/rmgpanw/trud/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/rmgpanw/trud/actions/workflows/pkgdown.yaml)
[![Codecov test
coverage](https://codecov.io/gh/rmgpanw/trud/branch/main/graph/badge.svg)](https://app.codecov.io/gh/rmgpanw/trud?branch=main)
[![R-CMD-check](https://github.com/rmgpanw/trud/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/rmgpanw/trud/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of `trud` is to provide a convenient R interface to the [NHS
TRUD API](https://isd.digital.nhs.uk/trud/users/guest/filters/0/api).

## Installation

You can install this package from CRAN:

``` r
install.packages("trud")
```

Or you can install the development version of `trud` from
[GitHub](https://github.com/rmgpanw/trud) with:

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

Retrieve available endpoints[^1]:

``` r
library(trud)

trud_items()
#> # A tibble: 71 × 2
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
#> # ℹ 61 more rows
```

Get metadata for an item:

``` r
get_item_metadata(394) |>
  purrr::map_at("releases", \(release) purrr::map(release, names))
#> $apiVersion
#> [1] "1"
#> 
#> $releases
#> $releases$CSDS_Provpredextract_1.6.6_20221115000001.zip
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
#> $releases$DMDSSCHEMAS_1.5.21_20200805000001
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

Get metadata for all subscribed items:

``` r
get_subscribed_metadata()
#>  ■■■■■■■■■■■■                      37% |  ETA:  3s
#> # A tibble: 16 × 3
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
#> 14         101 SNOMED CT UK Clinical Edition, RF2: Full, Snapshot … <named list>
#> 15          98 SNOMED CT UK Data Migration Workbench                <named list>
#> 16        1799 SNOMED CT UK Monolith Edition, RF2: Snapshot         <named list>
```

Download an item:

``` r
# by default the latest release will be downloaded to the current working directory
x <- download_item(394, directory = tempdir())
#> ⠙ Downloading archive file for TRUD item 394...
#> ✔ Successfully downloaded `CSDS_Provpredextract_1.6.6_20221115000001.zip` to '/…
#> 
unzip(x, list = TRUE)
#>                                                   Name Length
#> 1           CSDS_ProvPreExtract__V1_6_6_SAMPLE_XML.xml   7887
#> 2              CSDS_ProvPreExtract__V1_6_6_FinalV1.XSD  75650
#> 3 CSDS ProvPreDExtract v1.6.6 Production Log v0.1.xlsx  32216
#>                  Date
#> 1 2022-11-15 12:48:00
#> 2 2022-10-31 11:36:00
#> 3 2022-11-15 11:57:00
```

[^1]: Item numbers can also be found in the URLs of releases pages,
    between `items` and `releases`. For example, the URL for the
    [Community Services Data Set pre-deadline extract XML
    Schema](https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/1/items/394/releases)
    releases page is
    `https://isd.digital.nhs.uk/trud/users/guest/filters/0/categories/1/items/394/releases`
    and the item number is `394`.
