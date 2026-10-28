#' Calendar table for a year
#'
#' Builds a table with one row per day of the year, giving the month name, the
#' day of the month, and the weekday.
#'
#' @param year A four-digit year.
#' @return A data frame with columns `month`, `day`, and `day.of.week`.
#' @export
generate_calendar <- function(year) {
  all_dates <- seq(as.Date(paste0(year, "-01-01")), as.Date(paste0(year, "-12-31")), by = "day")

  data.frame(
    month = month.name[as.integer(format(all_dates, "%m"))],
    day = as.integer(format(all_dates, "%d")),
    day.of.week = weekdays(all_dates)
  )
}
