% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/is_region_series.R
\name{is_region_series}
\alias{is_region_series}
\title{Check the object is a valid region series}
\usage{
is_region_series(x, strict = FALSE)
}
\arguments{
\item{x}{a \code{terra::SpatRasterDataset} representing a time series of
regional reconstructions obtained from \code{region_series}.}

\item{strict}{a boolean defining whether to preform a thorough test (see
description above for details).}
}
\description{
A region series is a \code{terra::SpatRasterDataset} for which each
subdataset is a variable, and all variables have the same number of 
time steps.
}
\details{
The standard test only checks that each SpatRaster has the same number of
layers. The more thorough test (obtainedwith strict=TRUE) actually checks
that all time steps are identical by comparing the result of 
\code{terra::time} applied to each variable
}