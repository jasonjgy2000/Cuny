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


df <- read.csv('https://raw.githubusercontent.com/jasonjgy2000/Cuny/master/Data%20608/Homework%203/Data/cleaned-cdc-mortality-1999-2010-2.csv',stringsAsFactors = FALSE)
#creating Cause of Death dataset to populate select control
selectOptions <- df %>% distinct(ICD.Chapter) %>% arrange(ICD.Chapter)
stateOptions <- df %>% distinct(State) %>% arrange(State)


shinyServer(function(input, output) {
  
  output$plot <- renderPlotly({ 
    
    populationData <- df %>% filter(ICD.Chapter == input$cod) %>% group_by(Year,ICD.Chapter) %>% summarise(meanCR = weighted.mean(Crude.Rate,Population)) %>%
      select(Year,meanCR)
    
    stateData <- df%>%  filter(ICD.Chapter == input$cod, State ==input$state) %>% group_by(Year,ICD.Chapter,State) %>% summarise(meanCR = Crude.Rate)%>%
      select(Year,meanCR)
   
    # plot_ly(x = populationData$Year, y =populationData$meanCR, type = 'scatter', mode='lines')
    trace1 <- list(x = populationData$Year, y =populationData$meanCR, 
                   line = list(
                     color = "rgb(255,108,90)", 
                     dash = "solid", 
                     shape = "linear", 
                     width = 2
                   ), 
                   mode = "lines", 
                   name = "National Average", 
                   showlegend = TRUE, 
                   type = "scatter", 
                   uid = "4380ba", 
                   xaxis = "x", 
                   yaxis = "y"
                   )
    trace2 <- list(x = stateData$Year, y =stateData$meanCR, 
                   line = list(
                     color = "rgb(0,210,0)", 
                     dash = "solid", 
                     shape = "linear", 
                     width = 2
                   ), 
                   mode = "lines", 
                   name = "State", 
                   showlegend = TRUE, 
                   type = "scatter", 
                   uid = "4380ba", 
                   xaxis = "x", 
                   yaxis = "y"
    )
    

    p <- plot_ly()
    p <- add_trace(p, x=trace1$x, y=trace1$y,line=trace1$line, mode=trace1$mode, name=trace1$name, showlegend=trace1$showlegend, type=trace1$type, uid=trace1$uid, xaxis=trace1$xaxis, yaxis=trace1$yaxis)
    p <- add_trace(p, x=trace2$x, y=trace2$y,line=trace2$line, mode=trace2$mode, name=trace2$name, showlegend=trace2$showlegend, type=trace2$type, uid=trace2$uid, xaxis=trace2$xaxis, yaxis=trace2$yaxis)
  }) 
  
  output$caseSelect <- renderUI({
    selectInput("cod", "Select Cause of Death:",
               as.list(selectOptions$ICD.Chapter))
  })
  
  output$stateSelect <- renderUI({
    selectInput("state", "Select State:",
                as.list(stateOptions$State))
  })
})
