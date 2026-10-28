#' Read a University of Wyoming sounding table
#'
#' Parses the fixed-width `TEXT:LIST` block returned by the University of Wyoming
#' sounding website into a data frame.
#'
#' @param table_text A character vector of lines containing the sounding table.
#' @return A data frame with columns PRES, HGHT, TEMP, DWPT, RELH, MIXR, DRCT, SKNT, THTA, THTE, THTV.
#' @export
read_sounding_table <- function(table_text) {
  # Open a text connection
  text_conn <- textConnection(table_text)
  
  # Define column widths (adjust as needed)
  col_widths <- c(8, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7)
  
  # Read the table
  sounding_df <- utils::read.fwf(text_conn, 
                          widths = col_widths, 
                          skip = 3, 
                          fill = TRUE,
                          stringsAsFactors = FALSE) 
  
  # Close the connection
  close(text_conn)
  
  # Name the columns
  colnames(sounding_df) <- c("PRES", "HGHT", "TEMP", "DWPT", "RELH", 
                             "MIXR", "DRCT", "SKNT", "THTA", "THTE", "THTV")
  
  sounding_df <- sounding_df[-c(1,2),]
  
  # Return the data frame
  return(sounding_df)
}
