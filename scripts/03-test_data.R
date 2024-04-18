#### Preamble ####
# Purpose: Tests cleaned data to ensure robustness.
# Author: Sima Shmuylovich
# Date: 18 April 2024
# Contact: sima.shmuylovich@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install tidyverse and testthat packages.
# Pre-requisites: Run 01-download_data.R and 02-data_cleaning.R
# Other Information: Code is appropriately styled using styler


#### Workspace setup ####
library(tidyverse)
library(testthat)

#### Test data ####
test_data <- read_csv("../data/analysis_data/analysis_data.csv")

nationality_options <- c("Austrian", "French", "Unknown", "American", "German", "Dutch", "Italian", "Swedish", "Multiple Nationalities", "British", "Japanese", "Argentine", "Brazilian", "Swiss", "Luxembourger", "Spanish", "Iranian", "Canadian", "Finnish", "Danish", "Moroccan", "Colombian", "Australian", "Hungarian", "Belgian", "Slovenian", "Chilean", "Mexican", "Latvian", "Russian", "Polish", "Czech", "Israeli", "Czechoslovakian", "Croatian", "Norwegian", "Georgian", "Ukrainian", "Cuban", "Romanian", "Venezuelan", "Greek", "Thai", "Icelandic", "Guatemalan", "Puerto Rican", "Indian", "Costa Rican", "Uruguayan", "Ethiopian", "Kuwaiti", "Haitian", "South African", "Zimbabwean", "Ecuadorian", "Portuguese", "Serbian", "Peruvian", "Azerbaijani", "Native American", "Malian", "Irish", "Cambodian", "Turkish", "Bosnian", "Chinese", "Scottish", "Korean", "Canadian Inuit", "Estonian", "Pakistani", "Bulgarian", "Bolivian", "Panamanian", "Taiwanese", "Paraguayan", "Nicaraguan", "Tunisian", "Sudanese", "Tanzanian", "Senegalese", "Congolese", "New Zealander", "Lebanese", "Kenyan", "Nigerian", "Egyptian", "Albanian", "Namibian", "Slovak", "Ghanaian", "Lithuanian", "Ugandan", "Cameroonian", "Malaysian", "Catalan", "Bahamian", "South Korean", "Algerian", "Vietnamese", "Macedonian", "Burkinabé", "Beninese", "Sierra Leonean", "Ivorian", "Sri Lankan", "Emirati", "Salvadoran", "Mozambican", "Welsh", "Iraqi", "Syrian", "Trinidad and Tobagonian", "Indonesian", "Nepali", "West African")

gender_options <- c("male", "female", "multiple genders", "unknown", "gender non-conforming", "non-binary", "transgender woman")

classification_options <- c("Architecture", "Mies van der Rohe Archive", "Design", "Illustrated Book", "Print", "Drawing", "Periodical", "Graphic Design", "Multiple", "Installation", "Photograph", "Painting", "Ephemera", "Photography Research/Reference", "Video", "Media", "Publication", "Poster", "Sculpture", "Film", "Work on Paper", "Audio", "Performance", "(not assigned)", "Textile", "Notebook", "Correspondence", "Collage", "Document", "Film (object)", "Frank Lloyd Wright Archive", "Furniture and Interiors", "Digital", "Software", "Moving Image", "Architectural Model", "News Clipping")

test_that("No NULL values", {
  expect_false(any(is.null(test_data$ObjectID)), "ObjectID no NULLS")
  expect_false(any(is.null(test_data$Title)), "Title no NULLS")
  expect_false(any(is.null(test_data$Artist)), "Artist no NULLS")
  expect_false(any(is.null(test_data$Nationality)), "Nationality no NULLS")
  expect_false(any(is.null(test_data$Gender)), "Gender no NULLSs")
  expect_false(any(is.null(test_data$Year)), "Year no NULLS")
  expect_false(any(is.null(test_data$Classification)), "Classification no NULLS")
  expect_false(any(is.null(test_data$Height)), "Height no NULLS")
  expect_false(any(is.null(test_data$Width)), "Width no NULLS")
  expect_false(any(is.null(test_data$Area)), "Area no NULLS")
})

test_that("Expected type", {
  expect(is.numeric(test_data$ObjectID), "ObjectID Numeric")
  expect_type(test_data$Title, "character")
  expect_type(test_data$Artist, "character")
  expect_type(test_data$Nationality, "character")
  expect_type(test_data$Gender, "character")
  expect_type(test_data$Classification, "character")
  expect(is.numeric(test_data$Year), "Year Numeric")
  expect(is.numeric(test_data$Height), "Width Numeric")
  expect(is.numeric(test_data$Width), "Height Numeric")
  expect(is.numeric(test_data$Area), "Area Numeric")
})

test_that("Numeric Variable Non Negative Value Check", {
  expect(all(test_data$Height >= 0), "Height > 0", "Width Non Negative")
  expect(all(test_data$Width >= 0), "Width > 0", "Height Non Negative")
  expect(all(test_data$Area >= 0), "Area > 0", "Area Non Negative")
  expect(all(test_data$Year >= 0), "Year > 0", "Year Non Negative")
})

test_that("Expected Values", {
  expect(all(test_data$Nationality %in% nationality_options), "Nationality as Expected")
  expect(all(test_data$Gender %in% gender_options), "Gender as Expected")
  expect(all(test_data$Classification %in% classification_options), "Classification as Expected")
})
