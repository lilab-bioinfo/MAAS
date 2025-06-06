.onLoad <- function(libname, pkgname) {
  required_pkgs <- c("clusterSim", "parallelDist", "fpc", "clValid")
  missing_pkgs <- required_pkgs[!required_pkgs %in% installed.packages()]

  if (length(missing_pkgs)) {
    msg <- paste0(
      "The following packages are required but not installed:\n",
      paste(missing_pkgs, collapse = ", "),
      "\nInstall them with: install.packages(c(",
      paste0("'", missing_pkgs, "'", collapse = ", "),
      "))"
    )
    packageStartupMessage(msg)
  }
}
