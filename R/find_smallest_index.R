#' Index of the first element greater than a value
#'
#' Returns the smallest index at which `vector` is greater than `input_number`.
#'
#' @param input_number A numeric value to compare against.
#' @param vector A numeric vector.
#' @return The smallest matching index, or `NA` if no element is greater.
#' @export
find_smallest_index <- function(input_number, vector) {
  # Find indices where the elements are greater than the input number
  indices <- which(vector > input_number)
  
  # Return the smallest index
  if (length(indices) > 0) {
    return(min(indices))
  } else {
    return(NA)  # Return NA if no such index exists
  }
}
