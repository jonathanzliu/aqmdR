% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sum_pt_emissions.R
\name{sum_pt_emissions}
\alias{sum_pt_emissions}
\title{Sum point source emissions}
\usage{
sum_pt_emissions(cmaq_ncdf, nox = F, sox = F, voc = F, grid = F)
}
\arguments{
\item{cmaq_ncdf}{grid file with 4km x 4km resolution over the South Coast Air Basin domain}

\item{nox}{boolean, TRUE if you want NOx emissions summed}

\item{sox}{boolean, TRUE if you want SOx emissions summed}

\item{voc}{boolean, TRUE if you want VOC emissions summed}
}
\description{
function to input CMAQ-generated 24-hour point-source emissions data, and output list of summed 156x102 (South Coast Air Basin grid) arrays with summed emissions for NOx, SOx, and VOC emissions
}
