#### Preamble ####
# Purpose: Downloads and saves the data from MOMA's collection GitHub Repository.
# Author: Sima Shmuylovich
# Date: 18 April 2024
# Contact: sima.shmuylovich@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install tidyverse and readr packages.


#### Workspace setup ####
library(tidyverse)
library(readr)

#### Download data ####
urlfile <- "https://media.githubusercontent.com/media/MuseumofModernArt/collection/main/Artworks.csv"
mydata <- read_csv(url(urlfile))

#### Save data ####
write_csv(raw_data, "data/raw_data/raw_data.csv")
