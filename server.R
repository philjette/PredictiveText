source('prediction.R')

library(shiny)

shinyServer(function(input, output) {
  
  # Reactive statement for prediction function when user input changes ####
  prediction =  reactive( {
    
    # Get input
    inputText = input$text
    input1 =  fun.input(inputText)[1, ]
    input2 =  fun.input(inputText)[2, ]
    nSuggestion = 1
    
    # Predict
    prediction = fun.predict(input1, input2, n = nSuggestion)[1,1]
  })
  
  
  output$prediction <- renderText({ 
    if (input$text == "" || input$text == " ") {
      ""
    } else {
      paste("<p align=\"center\"><font size=\"100\", color=\"#cccccc\"><b>", unlist(prediction()), "</b></font></p>")
    }
  })
  
})