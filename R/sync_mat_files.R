#' @title Sync files by extension from a remote server
#' @description This function connects to a remote server via SSH, iterates through specified folders, and downloads files matching a given extension to a local destination.
#'
#' @param host A string specifying the remote host address (e.g., "your_server.com").
#' @param user A string specifying the username for SSH authentication.
#' @param remote_base_path A string specifying the base path on the remote server where the folders are located (e.g., "/data/projects").
#' @param folder_names A character vector of folder names within the `remote_base_path` to search for files.
#' @param file_extension A string specifying the file extension to search for (e.g., ".mat", ".csv", ".txt").
#' @param local_dest A string specifying the local directory where files should be downloaded. Defaults to the current working directory.
#'
#' @return Invisibly returns `NULL`. Called for its side effects of downloading files.
#' @importFrom ssh ssh_connect ssh_disconnect ssh_exec_wait scp_download ssh_exec_internal
#' @export

sync_remote_files_by_extension <- function(host, user, remote_base_path, folder_names, file_extension, local_dest = getwd()) {
  
  # Connect to server
  cat("Connecting to", host, "...\n")
  session <- ssh_connect(paste0(user, "@", host))
  on.exit(ssh_disconnect(session))
  
  for (folder in folder_names) {
    remote_dir <- file.path(remote_base_path, folder)
    cat("\nScanning directory:", remote_dir, "\n")
    
    # We use 'find' to get full paths and capture the output into R
    # The pattern is now dynamic based on file_extension
    cmd <- sprintf("find %s -maxdepth 1 -name '*%s'", remote_dir, file_extension)
    
    # Capture the output of the command
    out <- ssh_exec_internal(session, command = cmd)
    raw_char <- rawToChar(out$stdout)
    
    # Clean up the output into a list of file paths
    files_to_download <- unlist(strsplit(raw_char, "\n"))
    
    if (length(files_to_download) == 0 || identical(files_to_download, "")) {
      cat("Warning: No", file_extension, "files found in", folder, "\n")
      next
    }
    
    # Now that we have actual paths in R, we download them
    for (rem_file in files_to_download) {
      cat("Downloading:", basename(rem_file), "...\n")
      
      # verbose = TRUE will show you a progress bar for the actual transfer
      scp_download(session, 
                   files = rem_file, 
                   to = local_dest, 
                   verbose = TRUE)
    }
  }
  
  cat("\n--- All downloads complete ---\n")
}
