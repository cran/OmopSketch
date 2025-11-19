## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----warning=FALSE------------------------------------------------------------
library(dplyr)
library(OmopSketch)
library(omock)

cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

cdm

## ----eval = FALSE-------------------------------------------------------------
# result <- databaseCharacteristics(cdm = cdm)

## ----eval=FALSE---------------------------------------------------------------
# result <- databaseCharacteristics(
#   cdm = cdm,
#   omopTableName = c("drug_exposure", "condition_occurrence")
# )

## ----eval=FALSE---------------------------------------------------------------
# result <- databaseCharacteristics(
#   cdm = cdm,
#   omopTableName = c("drug_exposure", "condition_occurrence"),
#   sex = TRUE
# )

## ----eval=FALSE---------------------------------------------------------------
# result <- databaseCharacteristics(
#   cdm = cdm,
#   omopTableName = c("drug_exposure", "condition_occurrence"),
#   ageGroup = list(c(0, 50), c(51, 100))
# )

## ----eval=FALSE---------------------------------------------------------------
# result <- databaseCharacteristics(
#   cdm = cdm,
#   interval = "years",
#   dateRange = as.Date(c("2010-01-01", "2018-12-31"))
# )

## ----eval=FALSE---------------------------------------------------------------
# result <- databaseCharacteristics(
#   cdm = cdm,
#   sample = 1000L
# )
# 
# result <- databaseCharacteristics(
#   cdm = cdm,
#   sample = "my_cohort"
# )

## ----eval=FALSE---------------------------------------------------------------
# result <- databaseCharacteristics(
#   cdm = cdm,
#   conceptIdCounts = TRUE
# )

## ----eval = FALSE-------------------------------------------------------------
# result <- databaseCharacteristics(
#   cdm = cdm,
#   conceptIdCounts = TRUE,
#   inObservation = TRUE
# )

## ----eval=FALSE---------------------------------------------------------------
# shinyCharacteristics(result = result, directory = "path/to/your/shiny")

## ----eval=FALSE---------------------------------------------------------------
# shinyCharacteristics(
#   result = result,
#   directory = "path/to/my/shiny",
#   title = "Characterisation of my data",
#   logo = "path/to/my/logo.svg",
#   theme = "scarlet",
#   background = "path/to/my/background.md"
# )

## -----------------------------------------------------------------------------
cdmDisconnect(cdm = cdm)

