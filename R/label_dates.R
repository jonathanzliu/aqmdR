#' Label dates by weekday and occurrence within the month
#'
#' For each date, returns its weekday and a label such as `"Mon.2"`, where the
#' number is the occurrence of that weekday in the given year and month.
#'
#' @param dates A vector coercible to `Date`.
#' @return A data frame with columns `Date` (character), `day_of_week`, and `label`.
#' @importFrom dplyr mutate group_by row_number ungroup rename select
#' @export
label_dates <- function(dates) {
  # Create a data frame to store the dates
  df <- data.frame(dates = as.Date(dates))
  
  # Process the dates
  df <- df %>%
    mutate(
      day_of_week = lubridate::wday(dates, label = TRUE), # Get day of the week as a label
      day_of_month = lubridate::day(dates)                # Get day of the month
    ) %>%
    group_by(year = lubridate::year(dates), month = lubridate::month(dates), day_of_week) %>%
    mutate(occurrence_in_month = row_number()) %>%
    ungroup() %>%
    mutate(label = paste(day_of_week, occurrence_in_month, sep = ".")) %>%  # Create label
    rename(Date = dates) %>% 
    mutate(Date = as.character(Date)) %>% 
    select(Date, day_of_week, label)
    
  # Return the resulting data frame
  return(df)
}
