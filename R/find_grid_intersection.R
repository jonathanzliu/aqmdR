#' @title Find grid intersection;
#'
#' @description This function finds the intersection between points and a grid, assigning a grid ID to each point.
#'
#' @param points An sf object representing point locations.
#' @param grid An sf object representing the grid. Defaults to `sc_grid`.
#'
#' @importFrom sf st_intersects
#' @importFrom dplyr %>%
#'
#' @return An sf object with a new column `grid_id` representing the ID of the intersecting grid cell.
#' @export
#' 

find_grid_intersection <- function(points, grid) {
  
  grid <- aqmdR::sc_grid
  intersection <- st_intersects(points, grid)
  
  points$grid_id <- NA
  
  for (i in seq_along(intersection)) {
    if (length(intersection[[i]]) > 0) {
      points$grid_id[i] <- intersection[[i]][1]
    }
  }
  
  points_filtered <- points %>%
    filter(!is.na(grid_id)) %>% 
    mutate(
      IX = sapply(.$grid_id, \(x) return(sc_grid[x,]$IX)),
      IY = sapply(.$grid_id, \(x) return(sc_grid[x,]$IY)),
    )
  
  points_filtered <- points %>%
    filter(!is.na(grid_id))
  
  return(points_filtered)
}

