## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(CDMConnector)
if (Sys.getenv("EUNOMIA_DATA_FOLDER") == "") Sys.setenv("EUNOMIA_DATA_FOLDER" = tempdir())
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))) dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
if (!eunomia_is_available()) downloadEunomiaData()

## ----warning=FALSE------------------------------------------------------------
library(dplyr)
library(CDMConnector)
library(DBI)
library(duckdb)
library(OmopSketch)

# Connect to Eunomia database
con <- DBI::dbConnect(duckdb::duckdb(), CDMConnector::eunomia_dir())
cdm <- CDMConnector::cdmFromCon(
  con = con, cdmSchema = "main", writeSchema = "main"
)

cdm 

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summarisePopulationCharacteristics(cdm)

summarisedResult |> glimpse()

## ----warning=FALSE------------------------------------------------------------
summarisedResult |>
  tablePopulationCharacteristics(type = "flextable")

## ----warning=FALSE------------------------------------------------------------
summarisePopulationCharacteristics(cdm,
                                   studyPeriod = c("1950-01-01", "1999-12-31")) |>
  tablePopulationCharacteristics()

## ----warning=FALSE------------------------------------------------------------
summarisePopulationCharacteristics(cdm,
                                   studyPeriod = c("1950-01-01", NA)) |>
  tablePopulationCharacteristics()

## ----warning=FALSE------------------------------------------------------------
summarisePopulationCharacteristics(cdm,
                                   sex = TRUE,
                                   ageGroup = list("<60" = c(0,59), ">=60" = c(60, Inf))) |>
  tablePopulationCharacteristics()

