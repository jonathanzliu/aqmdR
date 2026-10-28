#' Push a file to a remote host with scp
#'
#' Copies a local file to a remote host using the system `scp` command.
#'
#' @param local_file Path to the local file.
#' @param remote_user Remote user name.
#' @param remote_host Remote host name.
#' @param remote_path Destination directory on the remote host.
#' @return The exit status of `scp`, returned invisibly by `system2()`.
#' @export
push_file_ssh <- function(local_file, remote_user, remote_host, remote_path) {
  remote_target <- paste0(remote_user, "@", remote_host, ":", remote_path)
  system2("scp", c(local_file, remote_target))
}
