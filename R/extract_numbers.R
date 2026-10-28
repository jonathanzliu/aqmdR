#' Extract numbers from text
#'
#' Pulls all unsigned integer and decimal numbers out of a string.
#' Negative signs and scientific notation are not handled.
#'
#' @param text A character string.
#' @return A numeric vector of the numbers found in `text`.
#' @export
extract_numbers <- function(text) {
  # Regular expression pattern for numbers
  number_pattern <- "\\d+(\\.\\d+)?"
  
  # Find all matches of the pattern in the text
  matches <- regmatches(text, gregexpr(number_pattern, text))
  
  # Flatten the list of matches to a vector
  numbers <- unlist(matches)
  
  # Convert the extracted strings to numeric (if applicable)
  numbers <- as.numeric(numbers)
  
  return(numbers)
}
