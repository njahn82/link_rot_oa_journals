#' url status code checker
#' 
#' @param u url
#' 
#' @import dplyr::bind_cols, dplyr::bind_rows, httr::GET, httr::http_status
#' 
#' @example jn_status("https://libreas.eu")
jn_status <- function(u) {
  req <- httr::GET(u)
  out <- httr::http_status(req)
  dplyr::bind_cols(url = u, dplyr::bind_rows(out))
}
