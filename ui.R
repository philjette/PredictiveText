
library(shiny)
library(shinythemes)

shinyUI(fluidPage(
  
  theme = shinytheme("superhero"),
  

  
  h1(span("Predictive Text: Coursera Data Science Specialization", style = "font-weight: 300"), 
     style = "text-align: center; padding: 20px"),
  br(),

  h2(span("Enter some text!", style = "font-weight: 100"), 
     style = "text-align: center; padding: 5px"),  

  fluidRow(
    column(6, offset = 3,
           textInput("text", label="", value = '', width="100%")
    )
    ),

  h2(span("Predicted next word:", style = "font-weight: 100"), 
     style = "text-align: center; padding: 5px"),   
  
  fluidRow(
    column(6, offset = 3,
          htmlOutput('prediction', width="100%")
    )
  ),
  br()


))