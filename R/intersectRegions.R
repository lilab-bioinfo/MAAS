#' Find Intersecting Genomic Regions
#'
#' @param peaks Character vector of peak regions (format "chr:start-end")
#' @param cnvs Character vector of CNV regions (format "chr:start-end")
#' @return DataFrame of overlapping regions
#' @export
intersectRegions <- function(peaks, cnvs) {
  .Call('_MAAS_intersectRegions', PACKAGE = 'MAAS', peaks, cnvs)
}
