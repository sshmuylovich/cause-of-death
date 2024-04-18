#### Preamble ####
# Purpose: This is a Shiny web application about MoMA Artwork Size.
# Author: Sima Shmuylovich
# Date: 18 April 2024
# Contact: sima.shmuylovich@mail.utoronto.ca
# License: MIT
# Pre-requisites: 00-simulate_data.R, 01-download_data.R, 02-data_cleaning.R and 03-test_data.R
# Other Information: Code is appropriately styled using styler

if(!require(shiny)){install.packages('shiny', dependencies = TRUE)}
if(!require(DT)){install.packages('DT', dependencies = TRUE)}
if(!require(ggplot2)){install.packages('ggplot2', dependencies = TRUE)}
if(!require(tidyverse)){install.packages('tidyverse', dependencies = TRUE)}
if(!require(dplyr)){install.packages('dplyr', dependencies = TRUE)}
library(shiny)
library(DT)
library(ggplot2)
library(tidyverse)
library(dplyr)

data <- read_csv("../data/analysis_data/analysis_data.csv")
model <- readRDS("../models/model.rds")

ui <- fluidPage(
  titlePanel("Museum of Modern Art Artwork Size Analysis"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "genderSelection",
                  label = "Select Gender for Prediction:",
                  choices = distinct(data, Gender)),
      selectInput(inputId = "nationalitySelection",
                  label = "Select Nationality for Prediction:",
                  choices = distinct(data, Nationality))
    ),
    mainPanel(
      plotOutput("artworkSizePlot"),
      DTOutput("artworkSizeTable")
    )
  )
)


server <- function(input, output) {
  output$artworkSizePlot <- renderPlot({
    observed <- data %>% 
      filter(
        Gender == input$genderSelection,
        Nationality == input$nationalitySelection
      )
    
    req(nrow(observed) >= 1)
    
    future <- data.frame(
      Gender = sample(c(input$genderSelection), size = 2, replace = TRUE),
      Nationality = sample(c(input$nationalitySelection), size = 2, replace = TRUE),
      Year = c(min(observed$Year), max(observed$Year))
    )
    
    predictions <- predict(model, newdata = future)
    
    combined_data <- rbind(data.frame(Year = observed$Year, Area = observed$Area, Type = "Observed"),
                           data.frame(Year = future$Year, Area = predictions, Type = "Predicted"))
    
    ggplot(combined_data, aes(x = Year, y = Area, color = Type, group = Type)) +
      geom_line() +
      geom_point(data = combined_data[combined_data$Type == "Observed", ], shape = 16, size = 2) +
      labs(x = "Year", y = "Artwork Size (sq cm)", title = "Artwork Size Predictions") +
      scale_color_manual(values = c("Observed" = "black", "Predicted" = "red")) +
      theme_minimal() +
      theme(legend.position = "top") + 
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$artworkSizeTable <- renderDT({
    observed <- data %>% 
      filter(
        Gender == input$genderSelection,
        Nationality == input$nationalitySelection
      )
    
    future <- data.frame(
      Gender = sample(c(input$genderSelection), size = 2, replace = TRUE),
      Nationality = sample(c(input$nationalitySelection), size = 2, replace = TRUE),
      Year = c(min(observed$Year), max(observed$Year))
    )
    
    predictions <- predict(model, newdata = future)
    
    data_to_display <- rbind(data.frame(Year = observed$Year, Area = observed$Area, Type = "Observed"),
                           data.frame(Year = future$Year, Area = predictions, Type = "Predicted"))
    
    datatable(data_to_display, options = list(pageLength = 10, scrollX = TRUE))
  })
}
  

shinyApp(ui = ui, server = server)