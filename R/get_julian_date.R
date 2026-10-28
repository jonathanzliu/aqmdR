#' Julian day of year from a date string
#'
#' Converts a date in `"%m/%d/%Y"` format to its day of the year (1 to 366).
#'
#' @param date_str A character string such as `"03/15/2018"`.
#' @return A numeric Julian day.
#' @export
get_julian_date <- function(date_str) {
  # Convert string to Date object
  date_obj <- as.Date(date_str, format = "%m/%d/%Y")
  
  # Get Julian day of year (1 to 366)
  julian_date <- as.numeric(format(date_obj, "%j"))
  
  return(julian_date)
}
