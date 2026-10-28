#' Log in to PeMS
#'
#' Opens the PeMS website with `rvest` and submits the login form.
#'
#' @param username PeMS user name.
#' @param password PeMS password.
#' @return The `rvest` session object used for the login.
#' @export
PeMS_login <- function(username, password) {

  login_url <- "http://pems.dot.ca.gov/"
  session <- rvest::session(login_url)
  login_form <- rvest::html_form(session)

  filled_form <- rvest::set_values(login_form[[1]],
                                   "username" = username,
                                   "password" = password)

  rvest::submit_form(session, filled_form)

  return(session)
}
