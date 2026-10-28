#' Classification metrics from a confusion table
#'
#' Calculates sensitivity, specificity, and accuracy from a 2 x 2 confusion table.
#' Rows and columns are assumed to follow the layout `[1,1]` = TN, `[1,2]` = FP,
#' `[2,1]` = FN, `[2,2]` = TP.
#'
#' @param confusion_table A 2 x 2 matrix or table in the layout described above.
#' @return A named list with `sensitivity`, `specificity`, and `accuracy`.
#' @export
calculate_metrics <- function(confusion_table) {
  TN <- confusion_table[1, 1]
  FP <- confusion_table[1, 2]
  FN <- confusion_table[2, 1]
  TP <- confusion_table[2, 2]
  
  sensitivity <- TP / (TP + FN)
  specificity <- TN / (TN + FP)
  accuracy <- (TP + TN) / sum(confusion_table)
  
  list(
    sensitivity = sensitivity,
    specificity = specificity,
    accuracy = accuracy
  )
}
