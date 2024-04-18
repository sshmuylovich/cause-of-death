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

model <- lm(Area ~ Gender + Year + Nationality, data = model_data)

#### Save model ####
saveRDS(
  model,
  file = "models/model.rds"
)

