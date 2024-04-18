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
raw_data <- read_csv("data/raw_data/raw_data.csv")

# Select columns for analysis
cleaned_data <- raw_data %>%
  # Select Interested Variables
  dplyr::select(ObjectID, Title, Artist, Nationality, Gender, Date, Classification, OnView, "Depth (cm)", "Height (cm)", "Width (cm)") %>%
  # Clean Title and Artist by replacing NA values with "Unknown"
  mutate(
    Title = coalesce(Title, "Unknown"),
    Artist = coalesce(Artist, "Unknown")
  ) %>%
  # Clean Nationality
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
  # Clean Gender
  mutate(
    Gender = str_extract_all(Gender, "\\(([^)]+)\\)"), # Extracts text within each pair of parentheses
    Gender = lapply(Gender, unique), # Apply unique to remove duplicates
    Gender = sapply(Gender, paste, collapse = ", "), # Join them into a single string
    Gender = ifelse(str_count(Gender, "\\(") > 1, "multiple artists", gsub("[()]", "", Gender)),
    Gender = gsub("[()]", "", Gender),
    Gender = ifelse(Gender == "", "unknown", Gender),
    Gender = ifelse(Gender == "NA", "unknown", Gender),
    Gender = coalesce(Gender, "unknown")
  ) %>%
  # Clean Date
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
  rename(
    Year = Date
  ) %>%
  # Add Year Buckets
  mutate(
    YearBucket = case_when(
      Year <= 1700 ~ "1700 or earlier",
      Year > 1700 & Year <= 1750 ~ "1701-1750",
      Year > 1750 & Year <= 1800 ~ "1751-1800",
      Year > 1800 & Year <= 1850 ~ "1801-1850",
      Year > 1850 & Year <= 1900 ~ "1851-1900",
      Year > 1900 & Year <= 1950 ~ "1901-1950",
      Year > 1950 & Year <= 2000 ~ "1951-2000",
      Year > 2000 ~ "2001-Present"
    ),
    YearBucket = factor(
      YearBucket,
      levels = c(
        "1700 or earlier",
        "1701-1750",
        "1751-1800",
        "1801-1850",
        "1851-1900",
        "1901-1950",
        "1951-2000",
        "2001-Present"
      )
    )
  ) %>%
  # Clean Classification by replacing NA values with "Unknown"
  mutate(
    Classification = coalesce(Classification, "Unknown"),
  ) %>%
  # Clean OnView by replacing NA values with "Unknown"
  mutate(
    OnView = coalesce(OnView, "Unknown"),
    OnViewBinary = if_else(OnView != "Uknown", 1, 0),
  ) %>%
  # Remove 3D-Objects
  rename(
    Depth = "Depth (cm)",
  ) %>%
  mutate(Depth = coalesce(OnView, "Unknown")) %>%
  filter(
    Depth == "Unknown"
  ) %>%
  # Clean Height and Width
  # Get rid of Height and Width NA values so Area can be calculated
  filter(if_any(everything(), ~ !is.na(.))) %>%
  rename(
    Height = "Height (cm)",
    Width = "Width (cm)"
  ) %>%
  filter(
    Height > 0 & Width > 0
  ) %>%
  # Calculate Area
  mutate(
    Area = Height * Width
  ) %>%
  select(ObjectID, Title, Artist, Nationality, Gender, Year, YearBucket, Classification, OnView, OnViewBinary, Height, Width, Area)

#### Save data ####
write_csv(cleaned_data, "data/analysis_data/analysis_data.csv")

# Cannot save as parquet do to C++ compiler compatability error, included code that would be used otherwise
# write_parquet(cleaned_data, "data/analysis_data/analysis_data.parquet")
