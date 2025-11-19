## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----warning=FALSE------------------------------------------------------------
library(OmopSketch)
library(dplyr)
library(omock)

cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

cdm

## ----warning=FALSE------------------------------------------------------------
summariseConceptIdCounts(cdm = cdm, omopTableName = "drug_exposure") |>
  select(group_level, variable_name, variable_level, estimate_name, estimate_value, additional_name, additional_level) |>
  glimpse()

## ----warning=FALSE------------------------------------------------------------
summariseConceptIdCounts(
  cdm = cdm,
  omopTableName = "drug_exposure",
  countBy = c("record", "person")
) |>
  select(variable_name, estimate_name, estimate_value)

## ----warning=FALSE------------------------------------------------------------
summariseConceptIdCounts(
  cdm = cdm,
  omopTableName = "condition_occurrence",
  countBy = "person",
  interval = "years",
  sex = TRUE,
  ageGroup = list("<=50" = c(0, 50), ">50" = c(51, Inf))
) |>
  select(group_level, strata_level, variable_name, estimate_name, additional_level) |>
  glimpse()

## -----------------------------------------------------------------------------
summarisedResult <- summariseConceptIdCounts(
  cdm = cdm,
  omopTableName = "condition_occurrence",
  dateRange = as.Date(c("1990-01-01", "2010-01-01"))
)
summarisedResult |>
  settings() |>
  glimpse()

## -----------------------------------------------------------------------------
summariseConceptIdCounts(
  cdm = cdm,
  omopTableName = "condition_occurrence",
  sample = 50
) |>
  select(group_level, variable_name, estimate_name) |>
  glimpse()

## ----warning=FALSE------------------------------------------------------------
result <- summariseConceptIdCounts(
  cdm = cdm,
  omopTableName = "measurement",
  countBy = "record"
)
tableConceptIdCounts(result = result, type = "reactable")

## -----------------------------------------------------------------------------
tableConceptIdCounts(result = result, type = "datatable")

## -----------------------------------------------------------------------------
tableConceptIdCounts(result = result, display = "overall")

## -----------------------------------------------------------------------------
tableConceptIdCounts(result = result, display = "standard")

## -----------------------------------------------------------------------------
tableConceptIdCounts(result = result, display = "source")

## -----------------------------------------------------------------------------
tableConceptIdCounts(result = result, display = "missing source")

## -----------------------------------------------------------------------------
tableConceptIdCounts(result = result, display = "missing standard")

## ----warning=FALSE------------------------------------------------------------
result <- summariseConceptIdCounts(
  cdm = cdm,
  omopTableName = "drug_exposure",
  countBy = "record"
)
tableTopConceptCounts(result = result, type = "gt")

## -----------------------------------------------------------------------------
tableTopConceptCounts(result = result, top = 5)

## ----warning=FALSE------------------------------------------------------------
result <- summariseConceptIdCounts(
  cdm = cdm,
  omopTableName = "drug_exposure",
  countBy = c("record", "person")
)
tableTopConceptCounts(result = result, countBy = "person")

## -----------------------------------------------------------------------------
cdmDisconnect(cdm = cdm)

