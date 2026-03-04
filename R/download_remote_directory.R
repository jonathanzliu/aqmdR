download_remote_directory <- function(host = "ezen1", username = "jliu", directory_path, destination_folder = ".") {
  scp_command <- paste0(
    "scp -r ",
    username, "@", host, ":",
    directory_path,
    " ",
    destination_folder
  )
  system(scp_command)
}
