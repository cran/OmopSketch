## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)


## ----warning=FALSE------------------------------------------------------------
library(dplyr)
library(OmopSketch)

cdm <- mockOmopSketch()

cdm

## -----------------------------------------------------------------------------
result <- databaseCharacteristics(cdm)
omopgenerics::settings(result) |> dplyr::select("result_id", "result_type", "package_name")

## ----eval=FALSE---------------------------------------------------------------
# result <- databaseCharacteristics(cdm, omopTableName = c("drug_exposure", "condition_occurrence"))

## ----eval=FALSE---------------------------------------------------------------
# result <- databaseCharacteristics(cdm, omopTableName = c("drug_exposure", "condition_occurrence"),
#                                   sex = TRUE)

## ----eval=FALSE---------------------------------------------------------------
# result <- databaseCharacteristics(cdm, omopTableName = c("drug_exposure", "condition_occurrence"),
#                                   ageGroup = list(c(0,50), c(51,100)))

## ----eval=FALSE---------------------------------------------------------------
# result <- databaseCharacteristics(cdm,
#                                  interval = "years",
#                                  dateRange = as.Date(c("2010-01-01", "2018-12-31")))

## ----eval=FALSE---------------------------------------------------------------
# result <- databaseCharacteristics(cdm,
#                                   conceptIdCounts = TRUE)

## ----eval=FALSE---------------------------------------------------------------
# shinyCharacteristics(result = result, directory = "path/to/your/shiny")

## ----eval=FALSE---------------------------------------------------------------
# shinyCharacteristics(result = result, directory = "path/to/my/shiny",
#                      title = "Characterisation of my data",
#                      logo = "path/to/my/logo.svg",
#                      theme = "bslib::bs_theme(bootswatch = 'flatly')")

