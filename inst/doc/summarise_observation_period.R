## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----warning=FALSE------------------------------------------------------------
library(dplyr)
library(OmopSketch)

# Connect to mock database
cdm <- mockOmopSketch()

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(cdm$observation_period)

summarisedResult 

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(cdm$observation_period,
                                               estimates =  c("mean", "sd", "q05", "q95"))

summarisedResult |> 
  filter(variable_name == "Duration in days") |>
  select(group_level, variable_name, estimate_name, estimate_value)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(cdm$observation_period,
                                               estimates =  c("mean", "sd", "q05", "q95"),
                                               sex = TRUE,
                                               ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf)), 
                                               dateRange = as.Date(c("1970-01-01", "2010-01-01")))

summarisedResult |> 
  select(group_level, variable_name, strata_level, estimate_name, estimate_value) |> 
  glimpse()

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summarisedResult <- summariseObservationPeriod(cdm$observation_period,
                                               estimates =  c("mean", "sd", "q05", "q95"), 
                                               sex = TRUE)

summarisedResult |> 
  tableObservationPeriod()

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(cdm$observation_period)  

plotObservationPeriod(summarisedResult, 
                      variableName = "Number subjects",
                      plotType = "barplot")


## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(cdm$observation_period,
                           sex = TRUE)  
plotObservationPeriod(summarisedResult,
                      variableName = "Duration in days",
                      plotType = "boxplot",
                      facet = "sex")

summarisedResult <- summariseObservationPeriod(cdm$observation_period,
                           sex = TRUE,
                           ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf))) 
plotObservationPeriod(summarisedResult,
                      colour = "sex", 
                      facet = "age_group")



## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period, 
                                           interval = "years")                                        

summarisedResult |>
  select(variable_name, estimate_name, estimate_value, additional_name, additional_level)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period, 
                                           interval = "months")                                        

summarisedResult |>
  select(variable_name, estimate_name, estimate_value, additional_name, additional_level)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period, 
                                           output = c("records", "person-days"))                                        

summarisedResult |>
  select(variable_name, estimate_name, estimate_value, additional_name, additional_level)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period, 
                                           output = c("records", "person-days"),
                                           interval = "quarters",
                                           sex = TRUE, 
                                           ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf)), 
                                           dateRange = as.Date(c("1970-01-01", "2010-01-01")))                                        

summarisedResult |>
  select(strata_level, variable_name, estimate_name, estimate_value, additional_name, additional_level)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period, 
                       interval = "years")  
plotInObservation(summarisedResult)


## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period, 
                       interval = "years",
                       output = c("records", "person-days"),
                       sex = TRUE,
                       ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf))) 
plotInObservation(summarisedResult |> 
  filter(variable_name == "Number person-days"),
  colour = "sex", 
  facet = "age_group")
  

## ----warning=FALSE------------------------------------------------------------
  PatientProfiles::mockDisconnect(cdm = cdm)

