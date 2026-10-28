#' Geometric mean
#'
#' Computes the geometric mean of a numeric vector as `exp(mean(log(x)))`.
#'
#' @param x A numeric vector. Negative values trigger a warning.
#' @param na.rm Logical. Should missing values be removed? Default `FALSE`.
#' @return A single numeric value.
#' @export
geo_mean <- function(x, na.rm = FALSE) {
  if (na.rm) {
    x <- na.omit(x)
  }
  if (any(x < 0)) {
    warning("Geometric mean is typically for non-negative numbers. Negative values found.")
  }
  exp(mean(log(x)))
}
