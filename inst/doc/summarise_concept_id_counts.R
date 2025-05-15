## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)


## ----warning=FALSE------------------------------------------------------------
library(duckdb)
library(OmopSketch)
library(dplyr)


cdm <- mockOmopSketch()

cdm

## ----warning=FALSE------------------------------------------------------------
summariseConceptIdCounts(cdm, omopTableName = "drug_exposure") |>
  select(group_level, variable_name, variable_level, estimate_name, estimate_value, additional_name, additional_level) |>
  glimpse()

## ----warning=FALSE------------------------------------------------------------
summariseConceptIdCounts(cdm,
  omopTableName = "drug_exposure",
  countBy = c("record", "person")
) |>
  select( variable_name, estimate_name, estimate_value) 

## ----warning=FALSE------------------------------------------------------------
summariseConceptIdCounts(cdm,
  omopTableName = "condition_occurrence",
  countBy = "person",
  interval = "years",
  sex = TRUE,
  ageGroup = list("<=50" = c(0, 50), ">50" = c(51, Inf))
) |>
  select(group_level, strata_level, variable_name, estimate_name, additional_level) |>
  glimpse()

## -----------------------------------------------------------------------------
summarisedResult <- summariseConceptIdCounts(cdm,
                                             omopTableName = "condition_occurrence",
                                             dateRange = as.Date(c("1990-01-01", "2010-01-01"))) 
summarisedResult |>
  omopgenerics::settings()|>
  glimpse()

## -----------------------------------------------------------------------------
summariseConceptIdCounts(cdm,
                         omopTableName = "condition_occurrence",
                         sample = 50) |>
  select(group_level, variable_name, estimate_name) |>
  glimpse()


## ----warning=FALSE------------------------------------------------------------
result <- summariseConceptIdCounts(cdm,
  omopTableName = "measurement",
  countBy = "record"
) 
tableConceptIdCounts(result, type = "reactable")

## -----------------------------------------------------------------------------
tableConceptIdCounts(result, type = "datatable")

## -----------------------------------------------------------------------------
tableConceptIdCounts(result, display = "overall")


## -----------------------------------------------------------------------------
tableConceptIdCounts(result, display = "standard")


## -----------------------------------------------------------------------------
tableConceptIdCounts(result, display = "source")


## -----------------------------------------------------------------------------
tableConceptIdCounts(result, display = "missing source")


## -----------------------------------------------------------------------------
tableConceptIdCounts(result, display = "missing standard")


