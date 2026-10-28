#' Parse units and descriptions for ICARTT variable names
#'
#' Searches ICARTT metadata text for each variable name and extracts its unit and
#' description. Variables not found return `NA`.
#'
#' @param text A character string containing the ICARTT variable metadata.
#' @param variable_names A character vector of variable names to look up.
#' @return A data frame with columns `Variable`, `Unit`, and `Description`.
#' @export
parse_using_variable_names_flexible <- function(text, variable_names) {
  # Initialize empty vectors to store the variable names, units, and descriptions
  units <- c()
  descriptions <- c()
  
  # Loop over each variable name in your vector
  for (variable in variable_names) {
    # Find the position of the variable name in the text
    # Adjust the pattern to allow for 2, 3, or more parts in the description
    pattern <- paste0(gsub("([][{}()+*^$|\\\\?.])", "\\\\\\1", variable), "\\s*,\\s*([^,]+)\\s*,\\s*([^,]+)(?:\\s*,\\s*([^,]+))?")
    match <- regexpr(pattern, text, perl = TRUE)
    
    if (match[1] != -1) { # If a match is found
      # Extract the matched text (the unit and the description)
      match_text <- regmatches(text, match)
      
      # Split the matched text into parts to get the unit and the description
      split_match <- unlist(strsplit(match_text, ",\\s*"))
      
      # The first element will be the variable name (skip it), next is unit, then description
      units <- c(units, split_match[2])  # Unit is the second part
      
      # Combine the rest as description (since there can be multiple parts)
      description_parts <- split_match[3:length(split_match)]
      descriptions <- c(descriptions, paste(description_parts, collapse = ", "))  # Handle multiple parts of description
    } else {
      # If the variable name isn't found, append NA for unit and description
      units <- c(units, NA)
      descriptions <- c(descriptions, NA)
    }
  }
  
  # Combine the variable names, units, and descriptions into a data frame
  result <- data.frame(
    Variable = variable_names,
    Unit = units,
    Description = descriptions,
    stringsAsFactors = FALSE
  )
  
  return(result)
}
