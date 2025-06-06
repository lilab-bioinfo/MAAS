#' Multi-omics Association Analysis via Simultaneous NMF
#'
#' @param A1 First data layer matrix (e.g. cell-cell similarities based on chromatin accessibility)
#' @param A2 Second data layer matrix (e.g. cell-cell similarities based on copy numbers)
#' @param A3 Third omics data matrix (e.g. cell-cell similarities based on SNVs)
#' @param dims Vector of latent dimensions to test
#' @return List containing factorization results and parameters
#' @export
MAAS <- function(A1, A2, A3, dims) {
  .Call('_MAAS_MAAS', PACKAGE = 'MAAS', A1, A2, A3, dims)
}
