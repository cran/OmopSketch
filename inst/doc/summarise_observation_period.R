## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----warning=FALSE------------------------------------------------------------
library(dplyr)
library(OmopSketch)
library(omock)

# Connect to mock database
cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(cdm = cdm)

summarisedResult

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(
  cdm = cdm,
  estimates = c("mean", "sd", "q05", "q95")
)

summarisedResult |>
  filter(variable_name == "Duration in days") |>
  select(group_level, variable_name, estimate_name, estimate_value)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(
  cdm = cdm,
  estimates = c("mean", "sd", "q05", "q95"), 
  byOrdinal = FALSE
)

summarisedResult |>
  filter(variable_name == "Duration in days") |>
  distinct(group_name, group_level)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(
  cdm = cdm,
  estimates = c("mean", "sd", "q05", "q95"), 
  missingData = TRUE
)

summarisedResult |>
  filter(variable_name == "Column name") |>
  select(group_level, variable_name, estimate_name, estimate_value)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(
  cdm = cdm,
  estimates = "mean", 
  missingData = FALSE, 
  quality = TRUE
)

summarisedResult |>
  select(group_level, variable_name, variable_level, estimate_name, estimate_value)

## ----warning=FALSE, eval=FALSE------------------------------------------------
# summarisedResult <- summariseObservationPeriod(
#   cdm = cdm,
#   estimates = c("mean", "sd", "q05", "q95"),
#   sex = TRUE,
#   ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf)),
# )

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(
  cdm = cdm,
  estimates = c("mean", "sd", "q05", "q95"),
  sex = TRUE
)

summarisedResult |>
  tableObservationPeriod(type = "gt")

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(cdm = cdm)

plotObservationPeriod(
  result = summarisedResult,
  variableName = "Number subjects",
  plotType = "barplot"
)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(cdm = cdm, sex = TRUE)

plotObservationPeriod(
  result = summarisedResult,
  variableName = "Duration in days",
  plotType = "boxplot",
  facet = "sex"
)

summarisedResult <- summariseObservationPeriod(
  cdm = cdm,
  sex = TRUE,
  ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf))
)

plotObservationPeriod(
  result = summarisedResult,
  colour = "sex",
  facet = "age_group"
)

## -----------------------------------------------------------------------------
cdmDisconnect(cdm = cdm)

