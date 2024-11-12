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
acetaminophen <- c(1125315,1127078, 1127433, 19133768, 40229134, 40231925, 40162522)

sinusitis <- c(4294548, 40481087, 4283893, 257012)

## ----warning=FALSE------------------------------------------------------------
summariseConceptCounts(cdm,
                       conceptId = list("acetaminophen" = acetaminophen,                          
                                        "sinusitis" = sinusitis)) |>   
  select(group_level, variable_name, variable_level, estimate_name, estimate_value) |>   
  glimpse() 

## ----warning=FALSE------------------------------------------------------------
summariseConceptCounts(cdm, 
                       conceptId = list("acetaminophen" = acetaminophen, 
                                        "sinusitis" = sinusitis), 
                       countBy = c("record","person")) |>
  select(group_level, variable_name, estimate_name) |>
  distinct() |>
  arrange(group_level, variable_name)


## ----warning=FALSE------------------------------------------------------------
summariseConceptCounts(cdm, 
                       conceptId = list("acetaminophen" = acetaminophen,
                                        "sinusitis" = sinusitis),
                       countBy = "record") |>
  select(group_level, variable_name, estimate_name) |>
  distinct() |>
  arrange(group_level, variable_name) 

## ----warning=FALSE------------------------------------------------------------
summariseConceptCounts(cdm,                         conceptId = list("acetaminophen" = acetaminophen,                                         "sinusitis" = sinusitis),                        countBy = "person",                        year = TRUE,                        sex  = TRUE,                        ageGroup = list("<=50" = c(0,50), ">50" = c(51,Inf))) |>   select(group_level, strata_level, variable_name, estimate_name) |>   glimpse() 

## ----warning=FALSE------------------------------------------------------------
summariseConceptCounts(cdm, 
                       conceptId = list("sinusitis" = sinusitis), 
                       countBy = "person") |> 
  plotConceptCounts()


## ----warning=FALSE------------------------------------------------------------
summariseConceptCounts(cdm, 
                       conceptId = list("sinusitis" = sinusitis),
                       countBy = c("person","record")) |>
  filter(estimate_name == "person_count") |>
  plotConceptCounts()

## ----warning=FALSE------------------------------------------------------------
summariseConceptCounts(cdm, 
                       conceptId = list("sinusitis" = sinusitis),
                       countBy = c("person"),
                       sex = TRUE, 
                       ageGroup = list("<=50" = c(0,50), ">50" = c(51, Inf))) |>
  visOmopResults::tidyColumns()

summariseConceptCounts(cdm, 
                       conceptId = list("sinusitis" = sinusitis),
                       countBy = c("person"),
                       sex = TRUE, 
                       ageGroup = list("<=50" = c(0,50), ">50" = c(51, Inf)))|>
  plotConceptCounts(facet = "sex", colour = "age_group")

