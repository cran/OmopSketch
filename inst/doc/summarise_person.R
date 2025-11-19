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

## -----------------------------------------------------------------------------
result <- summarisePerson(cdm = cdm)

result |> 
  glimpse()

## ----warning=FALSE------------------------------------------------------------
tablePerson(result = result, type = "gt")

## -----------------------------------------------------------------------------
cdmDisconnect(cdm = cdm)

