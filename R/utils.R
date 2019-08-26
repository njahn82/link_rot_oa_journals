#' url status code checker
#' 
#' @param u url
#' 
#' @import dplyr::bind_cols, dplyr::bind_rows, httr::GET, httr::http_status
#' 
#' @example jn_status("https://libreas.eu")
jn_status <- function(u) {
  req <- httr::GET(u, httr::timeout(3))
  out <- httr::http_status(req)
  header_df <- dplyr::bind_cols(url = u, dplyr::bind_rows(out))
  if (is.null(header_df))
    stop
  readr::write_csv(header_df, "data/jn_status.csv", append = TRUE)
}


jn_status_retry <- function(u) {
  req <- httr::RETRY("GET", u)
  out <- httr::http_status(req)
  header_df <- dplyr::bind_cols(url = u, dplyr::bind_rows(out))
  if (is.null(header_df))
    stop
  readr::write_csv(header_df, "data/jn_status_redo.csv", append = TRUE)
}

