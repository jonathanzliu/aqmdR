#' Category label for an MSC code
#'
#' Maps a CARB Method for Surveying Categories (MSC) code to its category name.
#'
#' @param code A numeric MSC code.
#' @return A character string with the category name, or `"Unknown Category"` for codes not in the table.
#' @export
get_category <- function(code) {
  if (code %in% c(10, 20, 30, 40, 50, 52, 60, 99)) {
    return("Fuel Combustion")
  } else if (code %in% c(110, 120, 130, 140, 199)) {
    return("Waste Disposal")
  } else if (code %in% c(210, 220, 230, 240, 250, 299)) {
    return("Cleaning and Surface Coatings")
  } else if (code %in% c(310, 320, 330, 399)) {
    return("Petroleum Production and Marketing")
  } else if (code %in% c(410, 420, 430, 440, 450, 460, 470, 499)) {
    return("Industrial Processes")
  } else if (code %in% c(510, 520, 530, 540)) {
    return("Solvent Evaporation")
  } else if (code %in% c(610, 620, 630, 640, 645, 650, 660, 670, 690, 699)) {
    return("Miscellaneous Processes")
  } else if (code %in% c(710, 722, 723, 724, 725, 726, 727, 728, 750, 775, 780)) {
    return("On-Road Motor Vehicles")
  } else if (code %in% c(810, 820, 833, 835, 840, 850, 860, 861, 870, 890)) {
    return("Other Mobile Sources")
  } else {
    return("Unknown Category")
  }
}
