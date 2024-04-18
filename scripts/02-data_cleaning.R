#### Preamble ####
# Purpose: Cleans the raw data provided in the Museum of Modern Art's GitHub repo 'collection'.
# Author: Sima Shmuylovich
# Date: 18 April 2024
# Contact: sima.shmuylovich@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install tidyverse and dplyr packages.
# Pre-requisites: Run 01-download_data.R # Other Information: Code is appropriately styled using styler

#### Workspace setup ####
library(tidyverse)
library(dplyr)

#### Clean data ####
# Read data
raw_data <- read_csv("data/raw_data/Artworks.csv")

# Select columns for analysis
cleaned_data <- raw_data %>%
  dplyr::select(ObjectID, Title, Artist, Nationality, Gender, Date, "Height (cm)", "Width (cm)") %>%
  mutate(
    Nationality = str_extract_all(Nationality, "\\(([^)]+)\\)"), # Extracts text within each pair of parentheses
    Nationality = lapply(Nationality, unique), # Apply unique to remove duplicates
    Nationality = sapply(Nationality, paste, collapse = ", "), # Join them into a single string
    Nationality = ifelse(str_count(Nationality, "\\(") > 1, "Multiple Nationalities", gsub("[()]", "", Nationality)),
    Nationality = gsub("[()]", "", Nationality),
    Nationality = ifelse(Nationality == "", "Unknown", Nationality),
    Nationality = ifelse(Nationality == "Nationality unknown", "Unknown", Nationality),
    Nationality = ifelse(Nationality == "NA", "Unknown", Nationality),
    Nationality = coalesce(Nationality, "Unknown")
  ) %>%
  mutate(
    Gender = str_extract_all(Gender, "\\(([^)]+)\\)"), # Extracts text within each pair of parentheses
    Gender = lapply(Gender, unique), # Apply unique to remove duplicates
    Gender = sapply(Gender, paste, collapse = ", "), # Join them into a single string
    Gender = ifelse(str_count(Gender, "\\(") > 1, "multiple genders", gsub("[()]", "", Gender)),
    Gender = gsub("[()]", "", Gender),
    Gender = ifelse(Gender == "", "unknown", Gender),
    Gender = ifelse(Gender == "NA", "unknown", Gender),
    Gender = coalesce(Gender, "unknown")
  ) %>%
  filter(
    str_detect(Date, "^\\d{4}$") | # Check for "YYYY"
      str_detect(Date, "^[[:alpha:]]+ \\d{1,2}, \\d{4}$") | # Check for "Month D, YYYY"
      str_detect(Date, "^\\d{4}-\\d{2}$") | # Check for "YYYY-YY"
      str_detect(Date, "^\\d{4}-\\d{4}$") | # Check for "YYYY-YYYY"
      str_detect(Date, "^c\\. ^\\d{4}-\\d{2}$") | # Check for "c. YYYY-YY"
      str_detect(Date, "^c\\. ^\\d{4}-\\d{4}$") | # Check for "c. YYYY-YYYY"
      str_detect(Date, "^c\\. \\d{4}$") | # Check for "c. YYYY"
      str_detect(Date, "^n\\.^d\\.") | # Check for "n.d."
      str_detect(Date, "^Unknown") # Check for "Unknown"
  ) %>%
  mutate(
    Date = gsub("c. ", "", Date),
    Date = case_when(
      str_detect(Date, "^\\d{4}$") ~ sub("^(\\d{4})$", "\\1", Date), # "YYYY"
      str_detect(Date, "^[[:alpha:]]+ \\d{1,2}, \\d{4}$") ~ sub("^([[:alpha:]]+ \\d{1,2}, )(\\d{4})$", "\\2", Date), # "Month D, YYYY"
      str_detect(Date, "\\d{4}-\\d{2}$") ~ sub("^(\\d{2})(\\d{2})-(\\d{2})$", "\\1\\3", Date), # "YYYY-YY"
      str_detect(Date, "\\d{4}-\\d{4}$") ~ sub("^(\\d{4})-(\\d{4})$", "\\2", Date), # "YYYY-YYYY"
      # str_detect(Date, "^c\\. \\d{4}-\\d{2}$") ~ sub("^c\\. (\\d{4})-(\\d{2})$", "\\1\\2", Date), # "c. YYYY-YY"
      # str_detect(Date, "^c\\. \\d{4}-\\d{4}$") ~ sub("^(c\\. )(\\d{4)-(\\d{4})$", "\\3", Date), # "c. YYYY-YYYY"
      str_detect(Date, "^n\\.d\\.$") ~ "Unknown",
      str_detect(Date, "^Unknown$") ~ "Unknown",
      TRUE ~ "Unknown" # Fallback for any formats not covered
    ),
    Date = coalesce(Date, "Unknown"),
  ) %>%
  filter(
    Date != "Unknown"
  ) %>%
  mutate(
    Date = as.integer(Date)
  ) %>%
  rename(
    Year = Date,
  ) %>%
  mutate(
    Title = coalesce(Title, "Unknown"),
    Artist = coalesce(Artist, "Unknown"),
  ) %>%
  filter(across(everything(), ~ !is.na(.))) %>%
  rename(
    Height = "Height (cm)",
    Width = "Width (cm)"
  ) %>%
  filter(
    Height > 0 & Width > 0
  ) %>%
  mutate(
    Area = Height * Width
  )

#### Save data ####
write_csv(cleaned_data, "data/analysis_data/analysis_data.csv")

# Cannot save as parquet do to C++ compiler compatability error, included code that would be used otherwise
# write_parquet(cleaned_data, "data/analysis_data/analysis_data.parquet")
