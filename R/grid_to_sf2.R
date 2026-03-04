grid_to_sf2 <- function(sum_emissions, basin_only = TRUE) {
  
  grid <- aqmdR::sc_grid
  
  if(basin_only) {
    grid <- grid %>% 
      st_crop(south_coast) 
  }
  
  grid <- grid %>% 
    st_set_geometry(NULL)
  
  pollutant <- names(sum_emissions)
  
  IX <- nrow(sum_emissions[[1]])
  IY <- ncol(sum_emissions[[1]])
  
  for(l in 1:length(pollutant)) {
    grid[pollutant[l]] <- NA
    
  }
  
  for(i in 1:nrow(grid)) {
    
    row <- grid[i,]
    x <- row$IX
    y <- row$IY
    
    for(j in 1:length(pollutant)) {
      
      df <- sum_emissions[[pollutant[j]]]
      grid[[pollutant[j]]][i] <- df[x,y]
      
      
    }
    
  }
  
  grid <- left_join(grid, sc_grid) %>% 
    st_as_sf()
  
  return(grid)
  
}
