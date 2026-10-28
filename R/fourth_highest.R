#' Fourth highest value
#'
#' Returns the fourth highest distinct value in a vector. Ties are collapsed
#' with `unique()` before ranking, so duplicate values do not count twice.
#'
#' @param numbers A numeric vector.
#' @return The fourth highest unique value, or `NA` if there are fewer than four unique values.
#' @export
fourth_highest <- function(numbers) {
  # Check if input is a vector
  if (!is.vector(numbers)) {
    stop("Input must be a vector.")
  }
  
  # Remove duplicate values
  unique_numbers <- unique(numbers)
  
  # Check if there are at least 4 unique values
  if (length(unique_numbers) < 4) {
    return(NA)
  }
  
  # Sort the numbers in descending order
  sorted_numbers <- sort(unique_numbers, decreasing = TRUE)
  
  # Return the 4th highest value
  return(sorted_numbers[4])
}
