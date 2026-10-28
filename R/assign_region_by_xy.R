#' Assign region by x and y location
#'
#' Joins each row to the region whose bounding box contains its x and y
#' coordinates. A point that falls in more than one box is repeated once per
#' matching region.
#'
#' @param df A data frame with numeric columns `x` and `y`.
#' @param region_lookup_table A data frame with columns `xmin`, `xmax`, `ymin`,
#'   `ymax`, and the region column(s) to add.
#' @return `df` with the region columns added and the bounding-box columns removed.
#' @importFrom dplyr join_by select
#' @export
assign_region_by_xy <- function(df, region_lookup_table) {
  df %>%
    left_join(
      region_lookup_table,
      by = join_by(
        x >= xmin,
        x <= xmax,
        y >= ymin,
        y <= ymax
      ),
      relationship = "many-to-many"
    ) %>%
    select(-xmin, -xmax, -ymin, -ymax)
}
