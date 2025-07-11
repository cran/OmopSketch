## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----warning=FALSE------------------------------------------------------------
library(dplyr)
library(OmopSketch)

# Connect to mock database
cdm <- mockOmopSketch()

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(cdm, "condition_occurrence")

summarisedResult |> print()

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(cdm,
  "condition_occurrence",
  recordsPerPerson = c("mean", "sd", "q05", "q95")
)

summarisedResult |>
  filter(variable_name == "records_per_person") |>
  select(variable_name, estimate_name, estimate_value)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(cdm,
  "condition_occurrence",
  recordsPerPerson = c("mean", "sd", "q05", "q95"),
  inObservation = TRUE,
  standardConcept = TRUE,
  sourceVocabulary = TRUE,
  domainId = TRUE,
  typeConcept = TRUE
)

summarisedResult |>
  select(variable_name, estimate_name, estimate_value) |>
  glimpse()

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(cdm,
  "condition_occurrence",
  recordsPerPerson = c("mean", "sd", "q05", "q95"),
  inObservation = TRUE,
  standardConcept = TRUE,
  sourceVocabulary = TRUE,
  domainId = TRUE,
  typeConcept = TRUE,
  sex = TRUE,
  ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf))
)

summarisedResult |>
  select(variable_name, strata_level, estimate_name, estimate_value) |>
  glimpse()

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(cdm,
  c("observation_period", "drug_exposure"),
  recordsPerPerson = c("mean", "sd"),
  inObservation = FALSE,
  standardConcept = FALSE,
  sourceVocabulary = FALSE,
  domainId = FALSE,
  typeConcept = FALSE
)

summarisedResult |>
  select(group_level, variable_name, estimate_name, estimate_value) |>
  glimpse()

## -----------------------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(cdm, "drug_exposure",
  dateRange = as.Date(c("1990-01-01", "2010-01-01"))) 

summarisedResult |>
  omopgenerics::settings()|>
  glimpse()

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseClinicalRecords(cdm,
  "condition_occurrence",
  recordsPerPerson = c("mean", "sd", "q05", "q95"),
  inObservation = TRUE,
  standardConcept = TRUE,
  sourceVocabulary = TRUE,
  domainId = TRUE,
  typeConcept = TRUE,
  sex = TRUE
)

summarisedResult |>
  tableClinicalRecords()

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseRecordCount(cdm, "drug_exposure", interval = "years")

summarisedResult |> tableRecordCount(type = "gt")


## ----warning=FALSE------------------------------------------------------------
summariseRecordCount(cdm, "drug_exposure", interval = "quarters") |>
  plotRecordCount()

## ----warning=FALSE------------------------------------------------------------
summariseRecordCount(cdm, "drug_exposure",
  interval = "months",
  sex = TRUE,
  ageGroup = list(
    "<30" = c(0, 29),
    ">=30" = c(30, Inf)
  )
) |>
  plotRecordCount()

## ----warning=FALSE------------------------------------------------------------
summariseRecordCount(cdm, "drug_exposure",
  interval = "months",
  sex = TRUE,
  ageGroup = list(
    "0-29" = c(0, 29),
    "30-Inf" = c(30, Inf)
  )
) |>
  visOmopResults::tidyColumns()

## ----warning=FALSE------------------------------------------------------------
summariseRecordCount(cdm, "drug_exposure",
  interval = "months",
  sex = TRUE,
  ageGroup = list(
    "0-29" = c(0, 29),
    "30-Inf" = c(30, Inf)
  )
) |>
  plotRecordCount(facet = omop_table ~ age_group, colour = "sex")

## -----------------------------------------------------------------------------
summariseRecordCount(cdm, "drug_exposure",
  interval = "years",
  sex = TRUE, 
  dateRange = as.Date(c("1990-01-01", "2010-01-01"))) |>
  tableRecordCount(type = "gt")


## ----warning=FALSE------------------------------------------------------------
PatientProfiles::mockDisconnect(cdm = cdm)

