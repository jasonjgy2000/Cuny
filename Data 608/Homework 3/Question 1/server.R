#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)

# Define server logic required to draw a histogram
df <- read.csv('https://raw.githubusercontent.com/jasonjgy2000/Cuny/master/Data%20608/Homework%203/Data/cleaned-cdc-mortality-1999-2010-2.csv',stringsAsFactors = FALSE)
plotData <- df %>% filter(Year == 2010)
#creating Cause of Death dataset to populate select control
selectOptions <- plotData %>% distinct(ICD.Chapter) %>% arrange(ICD.Chapter)

shinyServer(function(input, output) {
  
  output$plot <- renderPlotly({
    plotData <- plotData %>% filter(ICD.Chapter == input$cod)
    
    if(input$order == "asc")
    {
      plotData$State <- factor(plotData$State, levels = unique(plotData$State)[order(plotData$Crude.Rate, decreasing = FALSE)])
    }
    else
    {
      plotData$State <- factor(plotData$State, levels = unique(plotData$State)[order(plotData$Crude.Rate, decreasing = TRUE)])
    }
    
    x <- list(
      title = "Crude Rate"
    )
    
    plot_ly(plotData ,x = ~Crude.Rate ,y = ~State) %>% layout(autosize = F, width = 900, height = 800) %>% layout(title= input$cod, xaxis = x)
    #plot_ly(plotData ,x = ~State ,y = ~Deaths)
  })
  
  output$caseSelect <- renderUI({
    selectInput("cod", "Select Cause of Death:",
               as.list(selectOptions$ICD.Chapter), selected='Neoplasms')
  })
  # 
  # output$text <- renderText({
  #   print(input$cod)
  # })
  # 
  # output$text1 <- renderText({
  #   print(input$order)
  # })
})
