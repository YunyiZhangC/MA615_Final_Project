#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(readr)
library(dplyr)
library(tidyverse)
library(kableExtra)
library(wordcloud)
library(htmlwidgets)
library(tm)
library(SnowballC)

data <- read.csv("restaurant_week_2018_final.csv")

datac <- data[,-c(2,3,5,6)]
#datac$average_review <- round(datac$average_review, digit = 3)
datac$restaurant_main_type <- as.character(datac$restaurant_main_type)
datac$description <- as.character(datac$description)

American <- subset(datac, restaurant_main_type == "American")
Italian <- subset(datac, restaurant_main_type == "Italian")
Steakhouse <- subset(datac, restaurant_main_type == "Steakhouse")
French <- subset(datac, restaurant_main_type == "French")

type <- c("American", "Italian", "Steakhouse", "French")

# Define UI for application that draws a histogram
ui <- fluidPage(
    # Application title
    titlePanel("Rating vs Number of reviews"),
    
    sidebarLayout(
        # Sidebar with a slider and selection inputs
        sidebarPanel(
            selectInput("Type", "Choose a Type of Restaurant:",
                        choices = type),
           
            hr(),
            helpText("Data from kaggle---NYC restaurant week 2018")
        ),
        
        # Show Word Cloud
        mainPanel(
            plotOutput("RatingPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # Fill in the spot we created for a plot
    output$RatingPlot <- renderPlot({
        
        # Render a barplot
        ggplot(data = subset(datac, restaurant_main_type == input$Type), aes(subset(datac, restaurant_main_type == input$Type)$average_review), ) +
            geom_histogram( breaks = seq(3.6,5.0,by=0.2), col = "grey", fill = "cyan3") +     scale_x_continuous(breaks=seq(3.6, 5.0, 0.2)) +
            scale_y_continuous(breaks=seq(0, 200, 20))+
            labs( x="Average Rating", y="Count") 
    })
}
    
    
# Run the application 
shinyApp(ui = ui, server = server)
