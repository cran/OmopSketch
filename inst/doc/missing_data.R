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
result_missingData <- summariseMissingData(cdm,
  omopTableName = "observation_period")

result_missingData |> glimpse()

## ----warning=FALSE, eval = FALSE----------------------------------------------
# result_missingData <- summariseMissingData(cdm = cdm,
#                                            omopTableName = c("observation_period", "visit_occurrence", "condition_occurrence", "drug_exposure", "procedure_occurrence","device_exposure", "measurement", "observation", "death"))
# 

## ----warning=FALSE, eval = FALSE----------------------------------------------
# result_missingData <- summariseMissingData(cdm = cdm,
#                                            omopTableName = c("observation_period", "visit_occurrence", "condition_occurrence", "drug_exposure", "procedure_occurrence","device_exposure", "measurement", "observation", "death"),
#                                            sex = TRUE)
# 

## ----warning=FALSE, eval = FALSE----------------------------------------------
# result_missingData <- summariseMissingData(cdm = cdm,
#                                            omopTableName = c("observation_period", "visit_occurrence", "condition_occurrence", "drug_exposure", "procedure_occurrence","device_exposure", "measurement", "observation", "death"),
#                                            ageGroup = list(c(0, 17), c(18, 64), c(65, 150)))
# 

## ----warning=FALSE, eval = FALSE----------------------------------------------
# result_missingData <- summariseMissingData(cdm = cdm,
#                                            omopTableName = c("observation_period", "visit_occurrence", "condition_occurrence", "drug_exposure", "procedure_occurrence","device_exposure", "measurement", "observation", "death"),
#                                            interval = "years",
#                                            dateRange = as.Date(c("2012-01-01", "2019-01-01")))
# 
# 

## ----warning=FALSE, eval = FALSE----------------------------------------------
# result_missingData <- summariseMissingData(cdm = cdm,
#                                            omopTableName = c("observation_period", "visit_occurrence", "condition_occurrence", "drug_exposure", "procedure_occurrence","device_exposure", "measurement", "observation", "death"),
#                                            col = c("observation_period_start_date",
#                                                    "observation_period_end_date"))
# 

## ----warning=FALSE, eval = FALSE----------------------------------------------
# result_missingData <- summariseMissingData(cdm = cdm,
#                                            omopTableName = c("observation_period", "visit_occurrence", "condition_occurrence", "drug_exposure", "procedure_occurrence","device_exposure", "measurement", "observation", "death"),
#                                            sample = 1000)
# 

## ----warning = FALSE----------------------------------------------------------
result_missingData <- summariseMissingData(cdm,
  omopTableName = c("condition_occurrence", "drug_exposure", "procedure_occurrence"),
  sex = TRUE,
  ageGroup = list(c(0, 17), c(18, 64), c(65, 150)),
  interval = "years",
  dateRange = as.Date(c("2012-01-01", "2019-01-01")),
  sample = 100000
)
result_missingData |> tableMissingData()

## ----warning = FALSE----------------------------------------------------------
result_missingData |> tableMissingData(type = "flextable")

## ----warning=FALSE------------------------------------------------------------
PatientProfiles::mockDisconnect(cdm = cdm)

