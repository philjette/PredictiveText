library(dplyr)
library(quanteda)

fun.corpus = function(x) {
  unlist(corpus_reshape(corpus(x), 'sentences'))
}

# Tokenization and regex based cleanup using Quanteda
fun.tokenize = function(x, ngramSize = 1) {
  
  tolower(
    quanteda::tokens(x,
                       remove_numbers = T,
                       remove_punct = T,
                       remove_separators = T,
                       remove_twitter = T,
                       ngrams = ngramSize,
                       concatenator = " "
    ) 
  )
}

# Parse tokens from input text ####

fun.input = function(x) {
  
  # If empty input, put both words empty
  if(x == "") {
    input1 = data_frame(word = "")
    input2 = data_frame(word = "")
  }
  # Tokenize with same functions as training data
  if(length(x) ==1) {
    y = data_frame(word = fun.tokenize(corpus(x)))
    
  }
  # If only one word, put first word empty
  if (nrow(y) == 1) {
    input1 = data_frame(word = "")
    input2 = y
    
    # Get last 2 words    
  }   else if (nrow(y) >= 1) {
    input1 = tail(y, 2)[1, ]
    input2 = tail(y, 1)
  }
  
  #  Return data frame of inputs 
  inputs = data_frame(words = unlist(rbind(input1,input2)))
  return(inputs)
}

# Predict using backoff algorithm ####

fun.predict = function(x, y, n = 100) {
  
  # Don't do anything until input provided
  #for the 3-gram we combine word 1 and word 2 into a single field 
 if(paste(x,y) %in% freq3$combined) {
    prediction = freq3 %>%
      filter(combined %in% paste(x,y)) %>%
      select(NextWord, freq)
    
    # Predict using 2-gram model
  }   else if(y %in% freq2$word1) {
    prediction = freq2 %>%
      filter(word1 %in% y) %>%
      select(NextWord, freq)
    
    # If no prediction found before, predict giving just the top 1-gram words
  }   else{
    prediction = freq1 %>%
      select(NextWord, freq)
  }
  
  # Return predicted word in a data frame
  return(prediction[1:n, ])
}