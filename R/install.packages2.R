#' @title Install an R package and its dependencies remotely and then locally
#'
#' @description This function installs an R package and all its dependencies.
#'   It is used when there is a firewall screening or blocking files on the host computer, but not on a remote server.
#'   It first checks CRAN for the latest version and its recursive dependencies.
#'   Then, it downloads the package tarballs to a remote server using `wget`
#'   via `plink`, copies them back to the local machine using `pscp`,
#'   and finally installs them locally from source.
#'
#' @param pkg A character string specifying the name of the package to install.
#' @param server A character string specifying the remote server hostname or IP address.
#' @param remote_dir A character string specifying the directory on the remote server
#'   where packages should be downloaded and stored temporarily.
#' @param username A character string specifying the username for SSH access to the remote server.
#' @param password A character string specifying the password for SSH access to the remote server.
#'
#' @return `invisible(NULL)` if all packages and their dependencies are already
#'   installed, or if the installation process completes successfully. The function
#'   is called for its side effects (package installation).
#'
#' @details This function relies on `plink` and `pscp` being available in the
#'   system's PATH for Windows, or standard `ssh` and `scp` for Unix-like systems
#'   (though the current implementation explicitly uses `plink` and `pscp` via
#'   `cmd_ssh` and `cmd_scp`). It performs the following steps:
#'   1. Retrieves the latest package version and its recursive dependencies from CRAN.
#'   2. Identifies which of these packages are not already installed locally.
#'   3. Constructs the CRAN download URLs for the required package tarballs.
#'   4. Downloads these tarballs to the remote server using `plink` and `wget`.
#'   5. Copies the downloaded tarballs from the remote server to the local machine using `pscp`.
#'   6. Installs the copied packages locally from source, respecting dependencies.
#'   7. Cleans up by removing the downloaded tarball files from the local working directory.



install_package2 <- function(pkg, 
                             server,
                             remote_dir,
                             username,
                             password
                             ) {
  # 1. Get latest package version from CRAN
  available <- available.packages(repos = "https://cran.r-project.org")
  if (!pkg %in% rownames(available)) {
    stop(paste("Package", pkg, "not found on CRAN"))
  }
  version <- available[pkg, "Version"]
  pkg_file <- paste0(pkg, "_", version, ".tar.gz")
  cran_url <- paste0("https://cran.r-project.org/src/contrib/", pkg_file)
  
  # 2. Get recursive dependencies
  deps <- tools::package_dependencies(pkg, recursive = TRUE)
  all_pkgs <- unique(c(pkg, unlist(deps)))
  
  # 4. Remove packages that are already installed locally
  installed <- rownames(installed.packages())
  pkgs_to_install <- setdiff(all_pkgs, installed)
  
  if (length(pkgs_to_install) == 0) {
    message("All packages and dependencies are already installed.")
    return(invisible(NULL))
  }
  

  # 5. Build list of tarball URLs
  tarballs <- sapply(pkgs_to_install, function(p) {
    ver <- available[p, "Version"]
    paste0(p, "_", ver, ".tar.gz")
  }, USE.NAMES = TRUE)
  
  urls <- paste0("https://cran.r-project.org/src/contrib/", tarballs)
  
  # 6. Download all tarballs on the server using plink
  for(i in seq_along(urls)) {
    
    message(paste0("Downloading ", urls[i]))
    pkg_file <- tarballs[i]
    cran_url <- urls[i]
    cmd_ssh <- sprintf(
      'plink -pw "%s" %s@%s "mkdir -p %s && cd %s && wget -q %s"',
      password, username, server, remote_dir, remote_dir, cran_url
    )
    system(cmd_ssh)
  }
  
  # 7. Copy all tarballs back to local directory using pscp
  message("Copying packages to local directory...")
  for(pkg_file in tarballs) {
    cmd_scp <- sprintf(
      'pscp -pw "%s" %s@%s:%s/%s .',
      password, username, server, remote_dir, pkg_file
    )
    system(cmd_scp)
  }
  
  # 8. Install all packages locally in reverse order
  message("Installing packages locally with dependencies...")
  install.packages(rev(tarballs), repos = NULL, type = "source", dependencies = TRUE)
  
  # 9. Delete the tarballs from the working directory
  message("Removing local files")
  lapply(tarballs, file.remove)
  
  message("All packages installed successfully.")
}
 
