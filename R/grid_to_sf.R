#' @title Grid to SF;
#' @description Turns a 156x102 array -- usually emissions summed from CMAQ output -- into a sf object to be used for mapping/plotting. Uses a simple loop to add in emissions data into a template (`aqmdR::sc_grid`), and returns the resulting object with a `geometry` field. Output files are typically `.mat` files, which require the package `R.matlab` to read into R.
#' @param sum_emissions Summed emissions in a 156x102 grid, generated, for example from the function `sum_pt_emissions`
#' @param pollutant Pollutant of interest
#' @import sf

grid_to_sf <- function(sum_emissions, pollutant) {
  
  df <- sum_emissions
  
  IX <- nrow(df)
  IY <- ncol(df)
  
  grid <- aqmdR::sc_grid
  
  for(k in length(pollutant)) {
    
    grid[pollutant[k]] <- 999
    
    for(i in 1:IX) {
      
      for(j in 1:IY) {

        grid[[pollutant[k]]][(which(grid$IY == j & grid$IX == i))] <- df[i,j]
        
      }
      
    }
  }
  
  return(grid)
  
}

