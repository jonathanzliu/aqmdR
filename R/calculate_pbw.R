#' Particle-bound water from ammonium, nitrate, and sulfate
#'
#' Calculates particle-bound water (PBW) from ammonium (NH4), nitrate (NO3), and
#' sulfate (SO4) concentrations. Ported from `CalcPBW_marcFeb23.m`; coefficients
#' should be verified against the original source before use.
#'
#' @param df A data frame with numeric columns `NH4`, `NO3`, and `SO4`.
#' @return `df` with the intermediate columns removed and a `PBW` column added.
#' @importFrom dplyr mutate mutate_if select
#' @export
calculate_pbw <- function(df) {
  
  # ported from CalcPBW_marcFeb23.m
  
  # calculate DON
  df2 <- df %>% 
    mutate(DON = NH4 - .29*NO3/SO4,
           DON = ifelse(DON > .375, .375, DON))
  
  # add relative components
  df3 <- df2 %>% 
    mutate(
      nh4fn = .375*SO4 + .29*NO3,
      nh4cap = ifelse(nh4fn > NH4, NH4, nh4fn),
      sna = NO3+SO4+nh4cap,
      ss = SO4/sna,
      nn = NO3/sna,
      aa = nh4cap/sna
    ) %>% 
    mutate_if(is.numeric, as.double) %>% 
    mutate(PBW = ifelse(DON < 0.225,
                         (595.556 -
                            1440.584*ss -
                            1126.488*nn +
                            283.907*(ss^1.5) -
                            13.384*(nn^1.5) -
                            1486.711*(aa^1.5) +
                            764.229*(ss^2) +
                            1501.999*(nn*ss) +
                            451.873*(nn^2) -
                            185.183*(ss^2.5) -
                            375.984*(ss^1.5)*nn -
                            16.895*(ss^3) -
                            65.814*(nn^1.5)*ss +
                            96.825*(nn^2.5) +
                            83.037*(nn^1.5)*(ss^1.5) -
                            4.419*(nn^3) +
                            1720.818*(aa^1.5)*ss +
                            1220.383*(aa^1.5)*nn -
                            311.496*(aa^1.5)*(ss^1.5) +
                            148.771*(aa^1.5)*(nn^1.5) +
                            1151.648*(aa^3)) * sna,
                         (202048.975 -
                            391494.647*ss -
                            390912.147*nn +
                            442.435*(ss^1.5) -
                            155.335*(nn^1.5) -
                            293406.827*(aa^1.5) +
                            189277.519*(ss^2) +
                            377992.610*(nn*ss) +
                            188636.790*(nn^2) -
                            447.123*(ss^2.5) -
                            507.157*(ss^1.5)*nn -
                            12.794*(ss^3) +
                            146.221*(nn^1.5)*ss +
                            217.197*(nn^2.5) +
                            29.981*(nn^1.5)*(ss^1.5) -
                            18.649*(nn^3) +
                            216266.951*(aa^1.5)*ss +
                            215419.876*(aa^1.5)*nn -
                            621.843*(aa^1.5)*(ss^1.5) +
                            239.132*(aa^1.5)*(nn^1.5) +
                            95413.122*(aa^3)) * sna),
           PBW = ifelse(PBW < 0, 0, PBW)
    ) %>%
  select(!c(aa, sna, nn, ss, nh4fn, DON, nh4cap))

  
  return(df3)
}
