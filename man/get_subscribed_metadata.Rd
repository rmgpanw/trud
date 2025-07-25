% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_subscribed_metadata.R
\name{get_subscribed_metadata}
\alias{get_subscribed_metadata}
\title{Get metadata for subscribed NHS TRUD items}
\usage{
get_subscribed_metadata(latest_only = FALSE)
}
\arguments{
\item{latest_only}{If \code{TRUE}, only metadata pertaining to the latest item
release will be retrieved. By default this is set to \code{FALSE}.}
}
\value{
A tibble, with item metadata stored in the list column \code{metadata}.
}
\description{
A convenience wrapper around \code{\link[=trud_items]{trud_items()}} and \code{\link[=get_item_metadata]{get_item_metadata()}},
retrieving metadata for only items that the user is subscribed to.
}
\examples{
\dontshow{if (identical(Sys.getenv("IN_PKGDOWN"), "true")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
get_subscribed_metadata()
\dontshow{\}) # examplesIf}
}
\seealso{
\code{\link[=trud_items]{trud_items()}}, \code{\link[=get_item_metadata]{get_item_metadata()}}
}
