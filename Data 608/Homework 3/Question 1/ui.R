#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Crude Mortality Rate per state based on cause of death"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      uiOutput("caseSelect"),
      
      radioButtons("order", "Sort Order:",
                   c("Assending" = "asc",
                     "Desending" = "desc"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       # plotOutput("distPlot")
      plotlyOutput("plot")
      # h1(textOutput("text")),
      # h1(textOutput("text1"))
    )
  )
))
