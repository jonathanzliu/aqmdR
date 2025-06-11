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
  intersection <- st_intersects(points, grid)
  
  grid <- aqmdR::sc_grid
  
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

