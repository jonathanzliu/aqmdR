#' Click an element, retrying until it exists
#'
#' Repeatedly looks for an element by XPath and clicks it, pausing between
#' attempts, until the click succeeds or `max_attempts` is reached.
#'
#' @param driver A RSelenium remote driver object.
#' @param xpath XPath of the element to click.
#' @param max_attempts Maximum number of attempts. Default 10.
#' @param wait Seconds to wait between attempts. Default 1.
#' @return `TRUE` if the click succeeded, `FALSE` if every attempt failed.
#' @export
clickElementWithRetry <- function(driver, xpath, max_attempts = 10, wait = 1) {
  for (attempt in seq_len(max_attempts)) {
    clicked <- tryCatch({
      driver$findElement(using = "xpath", value = xpath)$clickElement()
      TRUE
    }, error = function(e) FALSE)

    if (clicked) {
      return(TRUE)
    }

    Sys.sleep(wait)
  }

  FALSE
}
