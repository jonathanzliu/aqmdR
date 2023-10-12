#' @title South Coast Air Basin
#' @description sf object of the South Coast Air Basin
#' @format A data frame with 1 rows and 1 variables:
#' \describe{
#'   \item{\code{geometry}}{list Polygon geometry} 
#'}
#' @details
"south_coast"

#' @title AB617 Communities
#' @description Boundaries of six vulnerable communities identified in A.B. 617 targeted for environmental remediation and environmental justice-related support.
#' @format A data frame with 6 rows and 2 variables:
#' \describe{
#'   \item{\code{Name}}{character Community name}
#'   \item{\code{geometry}}{list Polygon geometry} 
#'}
#' @details
"ab617"

#' @title South Coast Grid
#' @description 4 km by 4 km grid of the South Coast Air Basin bounding box. 
#' @format A data frame with 15912 rows and 6 variables:
#' \describe{
#'   \item{\code{Id}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{IY}}{integer Y coordinate}
#'   \item{\code{IX}}{integer X coordinate}
#'   \item{\code{Am2}}{integer Area}
#'   \item{\code{IJ}}{integer Point number}
#'   \item{\code{geometry}}{list Polygon geometry} 
#'}
#' @details 156x102 grid, matching the output from CMAQ. Does not contain any air quality data, but is to be used as a "mask" to append geospatial information to CMAQ output. 
"sc_grid"
