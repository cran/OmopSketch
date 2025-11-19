## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----warning=FALSE------------------------------------------------------------
library(omock)
library(OmopSketch)
library(dplyr)
library(visOmopResults)

cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

cdm

## -----------------------------------------------------------------------------
summarisedResult <- summariseTrend(
  cdm = cdm,
  event = c("condition_occurrence", "drug_exposure"),
  episode = "observation_period",
  interval = "years",
)

summarisedResult |>
  glimpse()

## -----------------------------------------------------------------------------
summarisedResult |>
  addSettings(settingsColumn = "type") |>
  glimpse()

## -----------------------------------------------------------------------------
summarisedResult <- summariseTrend(
  cdm = cdm,
  event = "condition_occurrence",
  output = c("record", "person"),
  interval = "years"
)

summarisedResult |>
  select(group_level, variable_name, additional_level, estimate_name, estimate_value)

## -----------------------------------------------------------------------------
summarisedResult <- summariseTrend(
  cdm = cdm,
  episode = "observation_period",
  output = "person-days",
  interval = "years"
)

summarisedResult |>
  select(group_level, variable_name, additional_level, estimate_name, estimate_value)

## -----------------------------------------------------------------------------
summarisedResult <- summariseTrend(
  cdm = cdm,
  event = "visit_occurrence",
  output = "person-days",
  interval = "years"
)
summarisedResult

## -----------------------------------------------------------------------------
summarisedResult <- summariseTrend(
  cdm = cdm,
  event = "condition_occurrence",
  output = "age",
  interval = "years"
)

summarisedResult |>
  select(variable_name, additional_level, estimate_name, estimate_value)

## -----------------------------------------------------------------------------
summarisedResult <- summariseTrend(
  cdm = cdm,
  event = "condition_occurrence",
  output = "sex",
  interval = "years"
)
summarisedResult |>
  select(variable_name, additional_level, estimate_name, estimate_value)

## -----------------------------------------------------------------------------
summarisedResult <- summariseTrend(
  cdm = cdm,
  event = "condition_occurrence",
  interval = "quarters",
  output = "record"
)

summarisedResult |>
  select(additional_level, estimate_value)

## -----------------------------------------------------------------------------
summarisedResult <- summariseTrend(
  cdm = cdm,
  event = "condition_occurrence",
  interval = "years",
  output = c("record", "age", "sex"),
  ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf)),
  sex = TRUE
)

summarisedResult |>
  select(variable_name, strata_level, estimate_name, estimate_value)

## -----------------------------------------------------------------------------
summarisedResult <- summariseTrend(
  cdm = cdm,
  event = "condition_occurrence",
  interval = "overall",
  output = "record",
  inObservation = TRUE
)

summarisedResult |>
  select(variable_name, strata_name, strata_level, estimate_name, estimate_value)

## -----------------------------------------------------------------------------
summarisedResult <- summariseTrend(
  cdm = cdm,
  event = "drug_exposure",
  dateRange = as.Date(c("1990-01-01", "2010-01-01"))
)

summarisedResult |>
  settings() |>
  glimpse()

## -----------------------------------------------------------------------------
result <- summariseTrend(
  cdm = cdm,
  event = "condition_occurrence",
  episode = "drug_exposure",
  output = "age",
  interval = "years"
)
tableTrend(result = result)

## -----------------------------------------------------------------------------
result <- summariseTrend(
  cdm = cdm,
  event = "measurement", 
  interval = "quarters",
  sex = TRUE, 
  ageGroup = list(c(0, 17), c(18, Inf)),
  dateRange = as.Date(c("2010-01-01", "2019-12-31"))
)

plotTrend(
  result = result,
  colour = "sex",
  facet = "age_group"
)

## -----------------------------------------------------------------------------
result <- summariseTrend(cdm,
  event = "measurement",
  interval = "quarters",
  output = c("sex", "record"),
  dateRange = as.Date(c("2010-01-01", "2019-12-31"))
)
plotTrend(
  result = result,
  output = "sex"
)

## -----------------------------------------------------------------------------
result <- summariseTrend(cdm,
  event = "measurement",
  interval = "quarters",
  sex = TRUE,
  inObservation = TRUE,
  dateRange = as.Date(c("2010-01-01", "2019-12-31"))
)
plotTrend(
  result = result,
  facet = omop_table ~ sex,
  colour = "in_observation"
)

## -----------------------------------------------------------------------------
cdmDisconnect(cdm = cdm)

