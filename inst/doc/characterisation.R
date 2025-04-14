## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(CDMConnector)
CDMConnector::requireEunomia()

## ----warning=FALSE------------------------------------------------------------
library(dplyr)
library(DBI)
library(duckdb)
library(OmopSketch)


# Connect to Eunomia database
con <- DBI::dbConnect(duckdb::duckdb(), CDMConnector::eunomiaDir())
cdm <- CDMConnector::cdmFromCon(
  con = con, cdmSchema = "main", writeSchema = "main", cdmName = "Eunomia"
)

cdm

## ----warning=FALSE------------------------------------------------------------
snapshot <- summariseOmopSnapshot(cdm)
snapshot |>
  tableOmopSnapshot()

## ----warning=FALSE------------------------------------------------------------
tableName <- c(
  "observation_period", "visit_occurrence", "condition_occurrence", "drug_exposure", "procedure_occurrence",
  "device_exposure", "measurement", "observation", "death"
)

dateRange <- as.Date(c("2012-01-01", NA))

sex <- TRUE

ageGroup <- list(c(0, 59), c(60, Inf))

interval <- "years"

## ----warning=FALSE------------------------------------------------------------
result_missingData <- summariseMissingData(cdm,
  omopTableName = tableName,
  sex = sex,
  ageGroup = ageGroup,
  interval = interval,
  dateRange = dateRange
)
result_missingData |> glimpse()

## ----warning=FALSE------------------------------------------------------------
result_clinicalRecords <- summariseClinicalRecords(cdm,
  omopTableName = tableName,
  sex = sex,
  ageGroup = ageGroup,
  dateRange = dateRange
)
result_clinicalRecords |> tableClinicalRecords()

## ----warning=FALSE------------------------------------------------------------
result_recordCounts <- summariseRecordCount(cdm,
  tableName,
  sex = sex,
  ageGroup = ageGroup,
  interval = interval,
  dateRange = dateRange
)
result_recordCounts |>
  filter(group_level %in% c("drug_exposure", "condition_occurrence")) |>
  plotRecordCount(
    colour = "omop_table",
    facet = c("sex", "age_group")
  )

## ----warning=FALSE------------------------------------------------------------
result_conceptIdCount <- OmopSketch::summariseConceptIdCounts(cdm,
  omopTableName = tableName,
  sex = sex,
  ageGroup = ageGroup,
  interval = interval,
  dateRange = dateRange
)
result_conceptIdCount |> glimpse()

## ----warning=FALSE------------------------------------------------------------

result_inObservation <-summariseInObservation(cdm$observation_period,
                                              output = c("record","person-days"),
                                              interval = interval,
                                              sex = sex,
                                              ageGroup = ageGroup,
                                              dateRange = dateRange) 

result_inObservation |>    
  filter(variable_name == "Number person-days") |>
  plotInObservation(colour = "sex", 
                    facet = "age_group")


result_inObservation |>
  filter(variable_name == "Number person-days") |>
  plotInObservation(
    colour = "sex",
    facet = "age_group"
  )

## ----warning=FALSE------------------------------------------------------------
result_observationPeriod <- summariseObservationPeriod(cdm$observation_period,
  sex = sex,
  ageGroup = ageGroup,
  dateRange = dateRange
)

result_observationPeriod |>
  plotObservationPeriod(
    variableName = "Duration in days",
    plotType = "boxplot",
    colour = "sex",
    facet = "age_group"
  )

## ----warning=FALSE------------------------------------------------------------
PatientProfiles::mockDisconnect(cdm = cdm)

