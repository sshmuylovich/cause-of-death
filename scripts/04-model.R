#### Preamble ####
# Purpose: Models Gender, Nationality, and Year for Artwork Area data obtained from the Museum of Modern Art's GitHub repo 'collection'.
# Author: Sima Shmuylovich
# Date: 18 April 2024
# Contact: sima.shmuylovich@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install tidyverse, rstanarm, and modelsummary packages. 
# Pre-requisites: Run 01-download_data.R and 02-data_cleaning.R 
# Other Information: Code is appropriately styled using styler


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(modelsummary)

#### Read data ####
model_data <- read_csv("data/analysis_data/analysis_data.csv")

### Model data ####
set.seed(853)

gender_model <- stan_glm(
  formula = Area ~ Gender,  
  data = model_data,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)

year_model <- stan_glm(
  formula = Area ~ Year,  
  data = model_data,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)

nationality_model <- stan_glm(
  formula = Area ~ Nationality,  
  data = model_data,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)

#### Save model ####
saveRDS(
  gender_model,
  file = "models/gender_model.rds"
)

saveRDS(
  year_model,
  file = "models/year_model.rds"
)

saveRDS(
  nationality_model,
  file = "models/nationality_model.rds"
)
