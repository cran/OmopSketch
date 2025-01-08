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
library(CodelistGenerator)

# Connect to Eunomia database
con <- DBI::dbConnect(duckdb::duckdb(), CDMConnector::eunomia_dir())
cdm <- CDMConnector::cdmFromCon(
  con = con, cdmSchema = "main", writeSchema = "main"
)

cdm 

## ----warning=FALSE------------------------------------------------------------
acetaminophen <- getCandidateCodes(
  cdm = cdm,
  keywords = "acetaminophen",
  domains = "Drug",
  includeDescendants = TRUE
) |>
  dplyr::pull("concept_id")

sinusitis <- getCandidateCodes(
  cdm = cdm,
  keywords = "sinusitis",
  domains = "Condition",
  includeDescendants = TRUE
) |>
  dplyr::pull("concept_id")


## ----warning=FALSE------------------------------------------------------------
summariseConceptSetCounts(cdm,
                       conceptSet = list("acetaminophen" = acetaminophen,                          
                                        "sinusitis" = sinusitis)) |>   
  select(group_level, variable_name, variable_level, estimate_name, estimate_value) |>   
  glimpse() 

## ----warning=FALSE------------------------------------------------------------
summariseConceptSetCounts(cdm, 
                       conceptSet = list("acetaminophen" = acetaminophen, 
                                        "sinusitis" = sinusitis), 
                       countBy = c("record","person")) |>
  select(group_level, variable_name, estimate_name) |>
  distinct() |>
  arrange(group_level, variable_name)


## ----warning=FALSE------------------------------------------------------------
summariseConceptSetCounts(cdm, 
                       conceptSet = list("acetaminophen" = acetaminophen,
                                        "sinusitis" = sinusitis),
                       countBy = "record") |>
  select(group_level, variable_name, estimate_name) |>
  distinct() |>
  arrange(group_level, variable_name) 

## ----warning=FALSE------------------------------------------------------------
summariseConceptSetCounts(cdm,
                       conceptSet = list("acetaminophen" = acetaminophen,
                                        "sinusitis" = sinusitis),
                       countBy = "person",
                       interval = "years",
                       sex  = TRUE,  
                       ageGroup = list("<=50" = c(0,50), ">50" = c(51,Inf))) |>   
  select(group_level, strata_level, variable_name, estimate_name) |>   glimpse() 

## ----warning=FALSE------------------------------------------------------------
summariseConceptSetCounts(cdm, 
                       conceptSet = list("sinusitis" = sinusitis), 
                       countBy = "person") |> 
  plotConceptSetCounts()


## ----warning=FALSE------------------------------------------------------------
summariseConceptSetCounts(cdm, 
                       conceptSet = list("sinusitis" = sinusitis),
                       countBy = c("person","record")) |>
  filter(variable_name == "Number subjects") |>
  plotConceptSetCounts()

## ----warning=FALSE------------------------------------------------------------
summariseConceptSetCounts(cdm, 
                       conceptSet = list("sinusitis" = sinusitis),
                       countBy = c("person"),
                       sex = TRUE, 
                       ageGroup = list("<=50" = c(0,50), ">50" = c(51, Inf))) |>
  visOmopResults::tidyColumns()

summariseConceptSetCounts(cdm, 
                       conceptSet = list("sinusitis" = sinusitis),
                       countBy = c("person"),
                       sex = TRUE, 
                       ageGroup = list("<=50" = c(0,50), ">50" = c(51, Inf))) |>
  plotConceptSetCounts(facet = "sex", colour = "age_group")

