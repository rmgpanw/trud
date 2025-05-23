# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

library(testthat)
library(trud)

test_check("trud")

# # To get code coverage report when TRUD api key unavailable
# withr::with_envvar(c("PKG_CHECK" = "true", "TRUD_API_KEY" = "true"), {
#   x <- covr::report()
# })
