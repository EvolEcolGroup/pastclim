% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vrt_get_meta.R
\name{vrt_get_meta}
\alias{vrt_get_meta}
\title{Get metadata from vrt}
\usage{
vrt_get_meta(vrt_path)
}
\arguments{
\item{vrt_path}{path to the XML file defining the vrt dataset}
}
\value{
list of three elements: vector \code{description} and \code{time_bp} defining
each band, and a boolean \code{time_bp} show determining whether times should be
given as time_bp when labelling bands by \code{terra}.
}
\description{
This function extract metadata information from a vrt. It returns the
description for the whole dataset (needed to set the varname in the raster)
and time information for each band. It first checks that the vrt dataset has
a metadata element with key "pastclim_time_bp" set to TRUE. If that is the
case, for each band, it extract the metadata with key "time" and returns them
as numeric (i.e. converting them from character). Note that an error is
returned if there are duplicated time elements for any of the bands (whilst
duplicated elements are valid in the XML schema for VRT, they do not make
sense for the time axis).
}
\keyword{internal}
