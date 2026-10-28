#' Plot VOC emissions or flux on a leaflet map
#'
#' Draws polygons colored by pollutant value on an interactive leaflet map.
#' Negative emission values are set to zero when `units = "tons/day"`.
#'
#' @param pollutant Pollutant name, without the `_emission` suffix.
#' @param df A data frame containing one column per pollutant, named `<pollutant>_emission`
#'   when `units = "tons/day"`, and an `sf` geometry column.
#' @param units Either `"tons/day"` or any other value for flux (mg/(m2*h)).
#' @return A leaflet map object.
#' @importFrom stringr str_remove_all
#' @import leaflet
#' @export
plot_voc_grid <- function(pollutant = "C6H6", df, units = "tons/day") {
  
  if(units == "tons/day") {
    
    pollutant <- paste(pollutant, "emission", sep = "_")
    
    df[[pollutant]][df[[pollutant]] < 0] <- 0
    
  }
  
  df <- df[pollutant] %>% na.omit()

  names(df)[names(df) == pollutant] <- "value"
  
  color_pal <- viridis::viridis(n = 99, option = "turbo")
  color_scale <- colorNumeric(palette = color_pal, domain = df$value)
  
  EF <- ifelse(units == "tons/day", "Emissions (tons/day)", "Flux (mg/(m2*h))")
  
  legend_title <- paste(pollutant %>% str_remove_all("_emission"), EF)
  
  # Define the base map
  leaflet_map <- leaflet() %>%
    addProviderTiles("CartoDB.Positron") %>%  # You can change the basemap provider if needed
    setView(lng = -118.024, lat = 33.998, zoom = 9) %>%
    addPolygons(
      data = df,
      fillColor = ~color_scale(value),
      fillOpacity = 0.7,
      color = NA,
      # radius = 5,  # You can adjust the radius based on your preference
      popup = paste(ifelse(units == "tons/day", "Emissions: ", "Flux: "), df$value %>% signif(digits = 2), units)
    ) %>%
    addLegend(
      position = "bottomright",
      pal = color_scale,
      values = df[["value"]],
      title = legend_title,
      opacity = 0.7
    ) 
  
  return(leaflet_map)
  
}
