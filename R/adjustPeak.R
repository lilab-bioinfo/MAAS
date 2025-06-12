#' Adjust Peak Intensities Based on CNV Data
#'
#' @param pp Peak matrix with cells in columns.
#' @param cc CNV matrix with cells in columns.
#' @param overlapRegion DataFrame of overlapping regions
#' @param eta Adjustment factor (default=0.5)
#' @return Adjusted peak matrix
#' @export
adjustPeak <- function(pp, cc, overlapRegion, eta = 0.5) {
  .Call('_MAAS_adjustPeak', PACKAGE = 'MAAS', pp, cc, overlapRegion, eta)
}
