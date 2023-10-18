#' @title Sum point source emissions
#' @description function to input CMAQ-generated 24-hour point-source emissions data, and output list of summed 156x102 (South Coast Air Basin grid) arrays with summed emissions for NOx, SOx, and VOC emissions
#' @param cmaq_ncdf grid file with 4km x 4km resolution over the South Coast Air Basin domain
#' @import ncdf4

sum_pt_emissions <- function(cmaq_ncdf) {
  
  ROWPTc <- aqmdR::ROWPTc_pt
  COLPTc <- aqmdR::COLPTc_pt
  
  cmaq <- nc_open(cmaq_ncdf)
  
  print("Summing NOx and SOx emissions")
  
  NOPTc <- ncvar_get(cmaq, "NO")
  NO2PTc <- ncvar_get(cmaq, "NO2")
  SO2PTc <- ncvar_get(cmaq, "SO2")
  SULFPTc <- ncvar_get(cmaq, "SULF")
  
  NOXPTc <- apply(NOPTc + NO2PTc, MARGIN = c(1), FUN = function(x) sum(x * 0.046 * 3600)) %>% 
    as.numeric((.))
  
  SOXPTc <- apply(SULFPTc*.08 + SO2PTc*.064, MARGIN = c(1), FUN = function(x) sum(x*3600)) %>% 
    as.numeric((.))
   
  SOXc <- NOXc <- array(rep(0), dim = c(156, 102))
  
  
  for (i in 1:length(ROWPTc)) {
    NOXc[COLPTc[i], ROWPTc[i]] <- NOXPTc[i] + NOXc[COLPTc[i], ROWPTc[i]]
    SOXc[COLPTc[i], ROWPTc[i]] <- SOXPTc[i] + SOXc[COLPTc[i], ROWPTc[i]]
  }
  
  print("Summing VOC emissions")
  
  voc_mw <- aqmdR::voc_mw
  voc <- names(voc_mw)
  
  voc_emissions <- lapply(voc, \(x) { # sum and consolidate emissions from VOCs
    
    tryCatch(
      {
        df <- ncvar_get(cmaq, x)
        
        GDAY <- array(0, dim = c(156,102))
        PTDAY <- apply(df, MARGIN = c(1), FUN = function(y) sum(y * voc_mw[x]/1000 * 3600))
        for(i in 1:length(ROWPTc)) {
          GDAY[COLPTc[i], ROWPTc[i]] <- PTDAY[i] + GDAY[COLPTc[i], ROWPTc[i]]
          
        } 
        
        return(GDAY)
        
      }, #error handling
      error=function(e) {
        message('An Error Occurred')
        print(e)
      },
      #if a warning occurs, tell me the warning
      warning=function(w) {
        message('A Warning Occurred')
        print(w)
        return(NA)
      }
    )
    
  }) %>% 
    .[sapply(., is.double)] %>% 
    Reduce(`+`, .)
  
  summed_emissions <- list(NOx = NOXc, SOx = SOxc, VOC = voc_emissions)
  
  return(summed_emissions)
}