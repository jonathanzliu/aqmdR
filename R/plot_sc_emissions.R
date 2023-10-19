#' @title Plot emissions in the South Coast Air Basin
#' @description Wrapper around ggplot to plot pollutions in a 4km x 4km grid of the South Coast Air Basin
#' @param sc_df sf object with of summed emissions
#' @param pollutant Character. Pollutant (or any field) to be plotted.
#' @param units Character. Unit of the emissions measurements. Default is kg/day.
#' @param sum_emission boolean. If TRUE, display the sum of emissions (in tons/day) as a subtitle of the plot
#' @param save_plot boolean. If TRUE, save a copy of the plot
#' @param plot_name Character. File name for the plot to save to (requires `save_plot` to be TRUE)
#' @import sf
#' @import ggplot2
#' @import basemapR
#' @export

plot_grid <- function(sc_df, pollutant, units = "kg/day", sum_emission = T, plot_max = 0, save_plot = F, plot_name = NA) {

  sc_df <- sc_df[sc_df[[pollutant]] != 0,] %>% 
    st_crop(sc_bbox)
  
  p_title <- paste("South Coast", pollutant, "Emissions")
    
  p <- ggplot(data = sc_df) +
    base_map(bbox = aqmdR::sc_bbox, basemap = "positron", increase_zoom = 2) +
    geom_sf(color = NA, aes(fill = .data[[pollutant]])) +
    theme_void() +
    # theme(legend.position = "bottom", legend.direction = "horizontal") +
    scale_fill_viridis_c(option = "turbo") +
    labs(fill = paste0(pollutant, " (", units, ")")) +
    ggtitle(p_title)
  
  if(plot_max > 0) {
    
    p <- p +
      scale_fill_viridis_c(option = "turbo", limits = c(0, max))
    
  }
  
  if(sum_emission) {
    
    emission_sum <- (sum(sc_df[[pollutant]])*2.2/2000) %>% round(digits = 1)
    p_subtitle <- paste0("Total: ", emission_sum, " tons/day")
    
    p <- p +
      ggtitle(p_title, subtitle = p_subtitle)
    
  }
  
  if(save_plot) {
    
    ggsave(p, filename = paste0(plot_name, ".png"), width = 6.5, height = 6, dpi = 500)
    
  }
  
  return(p)
}

