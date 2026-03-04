#' @title Convert Gridded Emissions to SF Object
#'
#' @description
#' Transforms a list of gridded emission matrices into a spatial features (sf) object.
#' It maps emission values from specified grid coordinates (IX, IY) onto a
#' spatial grid, optionally cropping it to the South Coast Air Basin.
#'
#' @param sum_emissions A list of numeric matrices, where each matrix represents
#'   emission values for a specific pollutant. The names of the list elements
#'   should be the pollutant names. Each matrix is indexed by `IX` (row index)
#'   and `IY` (column index) corresponding to the `aqmdR::sc_grid`.
#' @param basin_only A logical value. If `TRUE` (default), the `sc_grid` is
#'   cropped to the extent of the `south_coast` object before assigning emissions.
#' @return An `sf` object where each row represents a grid cell from `sc_grid`
#'   and includes columns for each pollutant's emission value, along with
#'   the original grid attributes and geometry.
#' @importFrom dplyr left_join
#' @importFrom sf st_crop st_set_geometry st_as_sf
#' @importFrom magrittr %>%
#' @export
#' 
grid_to_sf <- function(sum_emissions, basin_only = TRUE) {
  
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
    j    
    for(j in 1:length(pollutant)) {
      
      df <- sum_emissions[[pollutant[j]]]
      grid[[pollutant[j]]][i] <- df[x,y]
      
      
    }
    
  }
  
  grid <- left_join(grid, sc_grid) %>% 
    st_as_sf()
  
  return(grid)
  
}


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
j    
    for(j in 1:length(pollutant)) {
      
      df <- sum_emissions[[pollutant[j]]]
      grid[[pollutant[j]]][i] <- df[x,y]
      
      
    }
    
  }
  
  grid <- left_join(grid, sc_grid) %>% 
    st_as_sf()
  
  return(grid)
  
}
