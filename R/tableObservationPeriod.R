#' Create a visual table from a summariseObservationPeriod() result.
#' @param result A summarised_result object.
#' @param  type Type of formatting output table. See `visOmopResults::tableType()` for allowed options. Default is `"gt"`.
#' @return A formatted table object with the summarised data.
#' @export
#' @examples
#' \donttest{
#' cdm <- mockOmopSketch(numberIndividuals = 100)
#'
#' result <- summariseObservationPeriod(observationPeriod = cdm$observation_period)
#'
#' tableObservationPeriod(result = result)
#'
#' PatientProfiles::mockDisconnect(cdm = cdm)
#' }
tableObservationPeriod <- function(result,
                                   type = "gt") {
  # initial checks
  rlang::check_installed("visOmopResults")
  omopgenerics::validateResultArgument(result)
  omopgenerics::assertChoice(type, visOmopResults::tableType())

  # subset to result_type of interest
  result <- result |>
    omopgenerics::filterSettings(
      .data$result_type == "summarise_observation_period"
    )

  # check if it is empty
  if (nrow(result) == 0) {
    warnEmpty("summarise_observation_period")
    return(emptyTable(type))
  }

  header <- c("cdm_name")

  result |>
    dplyr::filter(is.na(.data$variable_level)) |> # to remove density
    formatColumn("variable_name") |>
    # Arrange by observation period ordinal
    dplyr::mutate(order = dplyr::coalesce(as.numeric(stringr::str_extract(.data$group_level, "\\d+")), 0)) |>
    dplyr::arrange(.data$order) |>
    dplyr::select(-"order") |>
    visOmopResults::visOmopTable(
      estimateName = c(
        "N" = "<count>",
        "mean (sd)" = "<mean> (<sd>)",
        "median [Q25 - Q75]" = "<median> [<q25> - <q75>]"
      ),
      header = header,
      groupColumn = omopgenerics::strataColumns(result),
      hide = c(
        "result_id", "estimate_type", "strata_name", "variable_level"
      ),
      type = type,
      .options = list(keepNotFormatted = FALSE) # to consider removing this? If
      # the user adds some custom estimates they are not going to be displayed in
    )
}
