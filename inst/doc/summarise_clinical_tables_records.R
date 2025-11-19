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

cdm

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(
  cdm = cdm, 
  omopTableName = "condition_occurrence"
)

summarisedResult

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(
  cdm = cdm,
  omopTableName = "condition_occurrence",
  recordsPerPerson = c("mean", "sd", "q05", "q95")
)

summarisedResult |>
  filter(variable_name == "records_per_person") |>
  select(variable_name, estimate_name, estimate_value)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(
  cdm = cdm,
  omopTableName = "condition_occurrence",
  recordsPerPerson = NULL, 
  conceptSummary = FALSE,
  missing = FALSE,
  quality = TRUE
)

summarisedResult |>
  select(variable_name, estimate_name, estimate_value) 

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(
  cdm = cdm,
  omopTableName = "drug_exposure",
  recordsPerPerson = NULL, 
  conceptSummary = TRUE,
  missing = FALSE,
  quality = FALSE
)

summarisedResult |>
  select(variable_name, variable_level, estimate_name, estimate_value) 

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(
  cdm = cdm,
  omopTableName = "condition_occurrence",
  recordsPerPerson = NULL, 
  conceptSummary = FALSE,
  missing = TRUE,
  quality = FALSE
)

summarisedResult |>
  select(variable_name, variable_level, estimate_name, estimate_value) 

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(
  cdm = cdm,
  omopTableName = "condition_occurrence",
  recordsPerPerson = c("mean", "sd", "q05", "q95"),
  quality = TRUE,
  conceptSummary = TRUE,
  sex = TRUE,
  ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf))
)

summarisedResult |>
  select(variable_name, strata_level, estimate_name, estimate_value) 

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(
  cdm = cdm,
  omopTableName = c("visit_occurrence", "drug_exposure"),
  recordsPerPerson = c("mean", "sd"),
  quality = FALSE,
  conceptSummary = FALSE,
  missingData = FALSE
)

summarisedResult |>
  select(group_level, variable_name, estimate_name, estimate_value)

## -----------------------------------------------------------------------------

summarisedResult <- summariseClinicalRecords(
  cdm = cdm, 
  omopTableName ="drug_exposure",
  dateRange = as.Date(c("1990-01-01", "2010-01-01"))
) 

summarisedResult |>
  settings() |>
  glimpse()

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(cdm,
  omopTableName = "condition_occurrence",
  recordsPerPerson = c("mean", "sd", "q05", "q95"),
  quality = TRUE, 
  conceptSummary = TRUE,
  sex = TRUE
)

tableClinicalRecords(result = summarisedResult, type = "gt")

## -----------------------------------------------------------------------------
cdmDisconnect(cdm = cdm)

