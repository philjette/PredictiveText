Predictive Text: Coursera Data Science Capstone 
========================================================
author: Philippe Jette
date: 10/19/2018
autosize: true

First Slide
========================================================

Thanks for checking out my project! This deck represents the culmincation of my Coursera Data Science specialization, which I'm ashamed to admit took me 3 years of on-and-off work to complete. 

The idea was simply to create a basic predictive text algo, which suggests the most likely upcoming word as you type a sentence. 

You can go straight to the application here: https://philjette.shinyapps.io/WordPrediction/

Data and preparation
========================================================

The text data comes from an english language corpus of blog, news, and twitter data located here: http://www.corpora.heliohost.org/aboutcorpus.html. Given the size of the corpus, (over 4 million lines combined), a 10% random sample was used.

Furthermore, I kept only the top 80% most frequently occuring n-grams. This didn't seem to affect prediction performance, while reducing memory requirements.

Furthmore, clean-up and tokenization tasks were performed
- Convert all text to lower case
- Remove numbers
- Remove punctuation
- Removed Twitter characters and profanity


Development of the predictive model 
========================================================
The model algorithm works as follows:

- Don't do anything until some valid text is input.
- Take the word (if only 1 word entered) or the last 2 words (if more than 2 words entered).
- Search the 3-grams data for a match and predict the next word if a match is found.
- If a match isn't found with the 3-grams, take only the last input word and search the 2-grams and predict if found.

Note that prediction is based on frequency of occurence of the n-gram. We can produce a list by frequency (from most to least likely). But for this mmodel, we only
grab the most frequently occuring n-gram. 


Future development
========================================================

In the future I'd like to go to a 4-gram (rather than the current 3-gram), in order to utilize the last 3 words (rather than the last 2). With the current method, some results are a bit wonky.

Thanks for reading and enjoy the app here: https://philjette.shinyapps.io/WordPrediction/




