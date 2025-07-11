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
  estimates = c("mean", "sd", "q05", "q95")
)

summarisedResult |>
  filter(variable_name == "Duration in days") |>
  select(group_level, variable_name, estimate_name, estimate_value)

## ----warning=FALSE, eval=FALSE------------------------------------------------
# summarisedResult <- summariseObservationPeriod(cdm$observation_period,
#   estimates = c("mean", "sd", "q05", "q95"),
#   sex = TRUE,
#   ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf)),
#   dateRange = as.Date(c("1970-01-01", "2010-01-01"))
# )
# 

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(cdm$observation_period,
  estimates = c("mean", "sd", "q05", "q95"),
  sex = TRUE
)

summarisedResult |>
  tableObservationPeriod()

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(cdm$observation_period)

plotObservationPeriod(summarisedResult,
  variableName = "Number subjects",
  plotType = "barplot"
)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseObservationPeriod(cdm$observation_period,
  sex = TRUE
)
plotObservationPeriod(summarisedResult,
  variableName = "Duration in days",
  plotType = "boxplot",
  facet = "sex"
)

summarisedResult <- summariseObservationPeriod(cdm$observation_period,
  sex = TRUE,
  ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf))
)
plotObservationPeriod(summarisedResult,
  colour = "sex",
  facet = "age_group"
)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period,
  interval = "years"
)

summarisedResult |>
  select(variable_name, estimate_name, estimate_value, additional_name, additional_level)

## ----warning=FALSE, eval = FALSE----------------------------------------------
# summarisedResult <- summariseInObservation(cdm$observation_period,
#   interval = "months"
# )
# 

## ----warning=FALSE------------------------------------------------------------

summarisedResult <- summariseInObservation(cdm$observation_period, 
                                           output = c("record", "person-days"))                                        


summarisedResult |>
  select(variable_name, estimate_name, estimate_value, additional_name, additional_level)

## ----warning=FALSE, eval = FALSE----------------------------------------------
# 
# summarisedResult <- summariseInObservation(cdm$observation_period,
#                                            output = c("record", "person-days"),
#                                            interval = "quarters",
#                                            sex = TRUE,
#                                            ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf)),
#                                            dateRange = as.Date(c("1970-01-01", "2010-01-01")))
# 
# 
# summarisedResult |>
#   select(strata_level, variable_name, estimate_name, estimate_value, additional_name, additional_level)

## -----------------------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period, 
                                           output = c("person"),
                                           interval = "years",
                                           sex = TRUE, 
                                           ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf)), 
                                           )                                        


summarisedResult |>
  select(strata_level, variable_name, estimate_name, estimate_value, additional_name, additional_level)

## -----------------------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period, 
                                           output = c("sex"),
                                           interval = "years",
                                           sex = TRUE, 
                                           ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf)), 
                                           )                                        


summarisedResult |>
  select(strata_level, variable_name, estimate_name, estimate_value, additional_name, additional_level)

## -----------------------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period, 
                                           output = c("age"),
                                           interval = "years",
                                           ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf)), 
                                           )                                        


summarisedResult |>
  select(strata_level, variable_name, estimate_name, estimate_value, additional_name, additional_level)

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period, 
                                           output = c("person", "person-days", "sex"),
                                           sex = TRUE)

summarisedResult |>
  tableInObservation(type = "gt")

## ----warning=FALSE------------------------------------------------------------
summarisedResult <- summariseInObservation(cdm$observation_period,
  interval = "years"
)
plotInObservation(summarisedResult)

## ----warning=FALSE------------------------------------------------------------

summarisedResult <- summariseInObservation(cdm$observation_period, 
                       interval = "years",
                       output = c("record", "age"),
                       sex = TRUE,
                       ageGroup = list("<35" = c(0, 34), ">=35" = c(35, Inf))) 
plotInObservation(summarisedResult |> 
  filter(variable_name == "Median age in observation"),
  colour = "sex", 
  facet = "age_group")
  


## ----warning=FALSE------------------------------------------------------------
PatientProfiles::mockDisconnect(cdm = cdm)

