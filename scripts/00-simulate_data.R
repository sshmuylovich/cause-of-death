#### Preamble ####
# Purpose: Simulates a dataset of artwork at MOMA with the following variables:
#     ObjectID, Title, Artist, Nationality, Gender, Year, Height, Width, and Area
# Author: Sima Shmuylovich
# Date: 18 April 2024
# Contact: sima.shmuylovich@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install tidyverse and randomNames packages.
# Other Information: Code is appropriately styled using styler

#### Workspace setup ####
library(tidyverse)
library(randomNames)

#### Simulate data ####
set.seed(853)

num_obs <- 1000

id <- c(1:1000)

chars <- c(0:9, letters, LETTERS)

title <- replicate(num_obs, paste(sample(chars, 10, replace = TRUE), collapse = ""))

artist <- randomNames(n = num_obs)

nationality_options <- c(
  "Austrian", "French", "Unknown", "American",
  "German", "Dutch", "Italian", "Swedish",
  "Multiple Nationalities", "British", "Japanese", "Argentine",
  "Brazilian", "Swiss", "Luxembourger", "Spanish",
  "Iranian", "Canadian", "Finnish", "Danish",
  "Belgian", "Nationality unknown", "Russian", "Czech",
  "Moroccan", "Colombian", "Australian", "Slovenian",
  "NA", "Hungarian", "Chilean", "Mexican",
  "Latvian", "Polish", "Greek", "Israeli",
  "Czechoslovakian", "Croatian", "Norwegian", "Georgian",
  "Ukrainian", "Yugoslav", "Cuban", "Romanian",
  "Venezuelan", "Thai", "Icelandic", "Serbian",
  "Guatemalan", "Puerto Rican", "Uruguayan", "Indian",
  "Costa Rican", "Ethiopian", "Kuwaiti", "Haitian",
  "South African", "Zimbabwean", "Ecuadorian", "Portuguese",
  "Peruvian", "Azerbaijani", "Native American", "Malian",
  "Irish", "Cambodian", "Turkish", "Bosnian",
  "Chinese", "Scottish", "Korean", "Canadian Inuit",
  "Estonian", "Pakistani", "Bulgarian", "Bolivian",
  "Panamanian", "Taiwanese", "Paraguayan", "Nicaraguan",
  "Tunisian", "Sudanese", "Tanzanian", "Senegalese",
  "Bahamian", "Congolese", "New Zealander", "Lebanese",
  "Kenyan", "Nigerian", "Egyptian", "Albanian",
  "Namibian", "Slovak", "Ghanaian", "Afghan",
  "Kyrgyz", "Lithuanian", "Ugandan", "Cameroonian",
  "Welsh", "Malaysian", "Catalan", "South Korean",
  "Algerian", "Palestinian", "Vietnamese", "Macedonian",
  "Filipino", "Bangladeshi", "Burkinabé", "Beninese",
  "Sierra Leonean", "Ivorian", "Sri Lankan", "Emirati",
  "Singaporean", "Salvadoran", "Iraqi", "Mozambican",
  "Syrian", "Trinidad and Tobagonian", "Indonesian", "Nepali",
  "West African"
)

gender_options <- c("male", "female")

year <- sample(1500:2023, size = num_obs, replace = TRUE)

height <- round(runif(n = num_obs, min = 0.01, max = 2000), 2)

width <- round(runif(n = num_obs, min = 0.01, max = 2000), 2)

simulation_data <- tibble(
  id = id,
  title = title,
  artist = artist,
  nationality = sample(nationality_options, size = num_obs, replace = TRUE),
  gender = sample(gender_options, size = num_obs, replace = TRUE),
  year = year,
  height = height,
  width = width,
  area = height * width
)
