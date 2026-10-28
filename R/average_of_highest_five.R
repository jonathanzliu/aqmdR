#' Average of the highest values
#'
#' Calculates the mean of the `n` highest values in a numeric vector. Missing
#' values are ignored.
#'
#' @param numbers A numeric vector.
#' @param n Number of highest values to average. Default 5.
#' @return The mean of the `n` highest values, or `NA` if there are fewer than `n`
#'   non-missing values.
#' @export
average_of_highest_five <- function(numbers, n = 5) {
  numbers <- sort(numbers[!is.na(numbers)], decreasing = TRUE)

  if (length(numbers) < n) {
    return(NA_real_)
  }

  mean(numbers[seq_len(n)])
}
