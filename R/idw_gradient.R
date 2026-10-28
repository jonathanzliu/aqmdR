#' Inverse distance weighting with CMAQ gradient scaling
#'
#' Interpolates observed monitor values to new locations using inverse distance
#' weighting (IDW). Monitor values are first scaled by the ratio of the CMAQ value at
#' the target grid cell to the CMAQ value at each monitor.
#'
#' Inputs must follow the layout used in the original analysis: `data` has `Xcell` and
#' `Ycell` columns and the pollutant columns; `newdata` and `cmaq` have `IX` and `IY`
#' grid indices. Columns are matched by name.
#'
#' @param data An `sf` object of observed monitor values.
#' @param newdata An `sf` object of locations to interpolate to.
#' @param idp Inverse distance power. Default 2.
#' @param pollutant Character vector of pollutant column names.
#' @param time Logical. If `TRUE`, interpolate separately for each `time_unit` value.
#' @param grid Logical. If `TRUE`, average CMAQ values over the 3 x 3 block around each cell.
#' @param time_unit Name of the time column used when `time = TRUE`. Default `"Quarter"`.
#' @param cmaq An `sf` object of CMAQ output by grid cell.
#' @return A data frame of interpolated values, one row per location.
#' @importFrom dplyr mutate mutate_at rename rename_with select filter pull summarize_all all_of contains left_join
#' @importFrom data.table rbindlist %between%
#' @importFrom stringr str_remove_all
#' @export
idw_gradient <- function(data, newdata, idp = 2, pollutant, time = TRUE, grid = FALSE, time_unit = "Quarter", cmaq) {
  
  # function to do inverse distance weighing 
calculate_idw <- function(nd_row, dt) {
    
    df <- dt %>%
      mutate(  # calculate distance between cell and monitoring sites
        distance = st_distance(nd_row, dt) %>% as.vector(), 
        inv_dist = 1 / distance^(idp),
        idw = inv_dist / sum(inv_dist)
      ) %>% 
      rename(IX = Xcell, IY = Ycell) %>% 
      left_join(cmaq %>% # append CMAQ data to the observed data to prepare to multiply
                  select(IX, IY, all_of(time_unit), all_of(pollutant)) %>% 
                  st_set_geometry(NULL) %>% 
                  rename_with(~paste0(.x, "_mod"), contains(c("PBW", "PM25", pollutant)))) 
    
    # loop through the pollutants to adjust for the gradient calculations
    for(j in 1:length(pollutant)) {
      
      target <- pollutant[j] # pollutant to be altered
      target_mod <- paste0(target, "_mod") # new column name
      
      target_value <- df %>% # observed value of all FRM stations
        pull(all_of(target))
      
      target_mod_value <- df %>%  # modeled value at the grid cells of each FRM station
        pull(all_of(target_mod))
      
      target_nd_row <- nd_row %>%  # modeled value at the target grid cell
        pull(all_of(target))
      
      newvalue <- target_value*target_nd_row / target_mod_value # scaling the FRM value by (1) modeled value at FRM and (2) modeled value at target grid cell
      
      df[,target] <- newvalue # replace observed data with gradient-scaled values
      
    }
    

    df <- df %>% 
      mutate_at(pollutant, ~.x*idw)  %>% # multiply pollutants by the inverse distance weight
      select(all_of(pollutant)) %>%   # remove all columns except for pollutants
      st_set_geometry(NULL) %>%  # remove spatial data
      apply(2, sum) %>%  # sum together the species to get the total PM2.5
      t() %>% # more data cleaning
      as.data.frame() 
    
    names(df) <- paste0(names(df), "_idw") # rename column to distinguish that it is calculated from IDW
     
    return(df)
    
  }
  
  
  # calculate distance, filter by quarter (if necesary)
  if(time) {
    
    # identifying time sections
    time_section <- unique(newdata[[time_unit]])
    
    # dividing by quarter
    time_dv <- lapply(time_section, \(ts) {
      
      # filtering out time
      data_t <- data %>%
        filter(get(time_unit) == ts)
      
      newdata_t <- newdata %>% 
        filter(get(time_unit) == ts)
      
      # Create a function to calculate distance and perform inverse distance weighting
     
      
      # Apply the function row-wise using lapply
      data_t_distance_list <- lapply(1:nrow(newdata_t), function(i) {
        
        nd_row <- newdata_t[i,] # isolate the individual row
        
        if(grid) {
          
          ix <- nd_row$IX
          iy <- nd_row$IY
          
          nd_block <- newdata_t %>%
            st_set_geometry(NULL) %>% 
            filter(IX %between% c(ix-1, ix+1), IY %between% c(iy-1, iy+1)) %>% 
            select(all_of(pollutant)) %>% 
            summarize_all(mean)
          
          for(j in 1:length(pollutant)) {
            nd_row[,pollutant[j]] <- nd_block[,pollutant[j]]
            
          }
            
            

        }
        
        
        row_idw <- calculate_idw(nd_row, dt = data_t) # calculate gradient-adjusted value at row
        
        nd_row2 <- cbind(nd_row, row_idw)  # add
        
        pm_sum <- nd_row2 %>% 
          select(contains(names(row_idw))) %>% 
          st_set_geometry(NULL) %>% 
          sum()
        
        nd_row3 <- nd_row2 %>%  # multiply estimated values by gradient
          mutate(PM25b = pm_sum) %>% 
          select(!all_of(pollutant))
        
        names(nd_row3) <- names(nd_row3) %>% 
          str_remove_all("_idw")
        
        return(nd_row3)
        }) %>% 
        rbindlist()
    }) %>% 
      rbindlist() %>% 
      st_as_sf()
    
    
  } else {
    
    data_t <- data 
    
    newdata_t <- newdata 
    
    # Apply the function row-wise using lapply
    time_dv <- lapply(1:nrow(newdata_t), function(i) {
      
      nd_row <- newdata_t[i,]
      
      row_idw <- calculate_idw(nd_row, dt = data_t)
      
      nd_row2 <- cbind(nd_row, row_idw) 
      
      pm_sum <- nd_row2 %>% 
        select(contains(names(row_idw))) %>% 
        st_set_geometry(NULL) %>% 
        sum()
      
      nd_row3 <- nd_row2 %>%  # multiply estimated values by gradient
        mutate(PM25b = pm_sum) %>% 
        select(!all_of(pollutant))
      
      names(nd_row3) <- names(nd_row3) %>% 
        str_remove_all("_idw")
      
      return(nd_row3)
    }) %>% 
      rbindlist() %>% 
      st_as_sf()

  }
  

  return(time_dv)  
  
}
