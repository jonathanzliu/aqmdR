#' Convert an English number word to a number
#'
#' Converts the words "zero" through "twenty-four" to integers. Unmatched
#' words return -1.
#'
#' @param x A character vector of number words.
#' @return A numeric vector of integers, with -1 for unmatched words.
#' @export
word_to_num <- function(x) {
  numNames <- c("zero", "one", "two", "three", "four", "five", 
                "six", "seven", "eight", "nine", "ten", "eleven", 
                "twelve", "thirteen", "fourteen", "fifteen", 
                "sixteen", "seventeen", "eighteen", "nineteen", 
                "twenty", "twenty-one", "twenty-two", "twenty-three", "twenty-four")
  match(tolower(x), numNames, nomatch = 0) - 1  # subtracts 1 from numeric equivalents to align with R's zero-based indexing
}
