#' @title South Coast Air Basin
#' @description sf object of the South Coast Air Basin
#' @format A data frame with 1 rows and 1 variables:
#' \describe{
#'   \item{\code{geometry}}{list Polygon geometry} 
#'}
#' @details Single polygon of South Coast Air Basin boundaries. Excludes Catalina Island.
"south_coast"

#' @title AB617 Communities
#' @description Boundaries of six vulnerable communities identified in A.B. 617 targeted for environmental remediation and environmental justice-related support.
#' @format A data frame with 6 rows and 2 variables:
#' \describe{
#'   \item{\code{Name}}{character Community name}
#'   \item{\code{geometry}}{list Polygon geometry} 
#'}
#' @details Boundaries of vulnerable communities.
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

#' @title Volatile Organic Compound (VOC) molecular weights
#' @description A vector of commonly-used VOC acronyms and their corresponding molecular weights
#' @format A named vector 
#' @details Named vector of VOCs and their molecular weights.
"voc_mw"

#' @title Domain stack
#' @description Matrix used to 
#' @format An object of class `ncdf4`
#' @details To be used when calculating emissions from CMAQ output. The fields `COLPTc_pt` and `ROWPTc_pt` are used after emissions have been summed together and "flattened" from a 2D matrix to a 1D vector.
"ROWPTc_pt"

#' @title Domain stack
#' @description Matrix used to 
#' @format An object of class `ncdf4`
#' @details To be used when calculating emissions from CMAQ output. The fields `COLPTc_pt` and `ROWPTc_pt` are used after emissions have been summed together and "flattened" from a 2D matrix to a 1D vector.
"COLPTc_pt"
