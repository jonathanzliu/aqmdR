#' Read AERMOD PLOT output
#'
#' Reads an AERMOD PLOT output file and converts the UTM easting and northing
#' columns to longitude and latitude.
#'
#' @param file_path Path to the AERMOD PLOT output file.
#' @param utm_zone UTM zone of the X and Y coordinates. Default 11.
#' @param hemisphere `"N"` or `"S"`. Default `"N"`.
#' @return A data frame with the AERMOD columns plus `longitude` and `latitude`.
#' @export
read_aermod_plot <- function(file_path, utm_zone = 11, hemisphere = "N") {
  headers <- c("X", "Y", "AVERAGE CONC", "ZELEV", "ZHILL", "ZFLAG", "AVE", "GRP", "DATE")

  # 6 (info) + 1 (text headers) + 1 (underscores) lines
  data <- readr::read_table(file_path, skip = 8, col_names = headers, show_col_types = FALSE)

  coords <- oce::utm2lonlat(easting = data$X,
                            northing = data$Y,
                            zone = utm_zone,
                            hemisphere = hemisphere)

  data$longitude <- coords$longitude
  data$latitude <- coords$latitude

  return(data)
}
