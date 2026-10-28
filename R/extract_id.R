#' Extract a station or detector ID from a file name
#'
#' Finds the first 5 to 8 digit number in a file name.
#'
#' @param file_name A character string, usually a file name.
#' @return The ID as a character string, or `"No ID found"` if none is present.
#' @export
extract_id <- function(file_name) {
  # Use a regular expression to find 6-7 digit numbers
  id <- stringr::str_extract(file_name, "(?<!\\d)\\d{5,8}(?!\\d)")
  
  # Return the ID or a message if not found
  if (is.na(id)) {
    return("No ID found")
  } else {
    return(id)
  }
}
