source('prediction.R')

library(readr)
library(caTools)
library(tidyr)
library(quanteda)

# Read and prepare data ####

# Read in data
blogsRaw = read_lines('../WordPrediction_Corpus/en_US/en_US.blogs.txt')
newsRaw = read_lines('../WordPrediction_Corpus/en_US/en_US.news.txt')
twitterRaw = readLines('../WordPrediction_Corpus/en_US/en_US.twitter.txt') # Not working with readr because of an "embedded null"

#remove raw files to save mem
rm(blogsRaw, newsRaw, twitterRaw)

combinedRaw = c(blogsRaw, newsRaw, twitterRaw)

# Sample and combine data. We;ll take a large sample here and only keep the most frequently occuring n-grams  
set.seed(1220)
n = 1/100
combined = sample(combinedRaw, length(combinedRaw) * n)

#remove raw files to save mem
rm(combinedRaw)

# Split into train and validation sets
split = sample.split(combined, 0.8)
train = subset(combined, split == T)
valid = subset(combined, split == F)

# Transfer to quanteda corpus format and segment into sentences (prediction.R)
train <- corpus(train)
train <- unlist(corpus_reshape(train, 'sentence'))


# Tokenize (prediction.R)
train1 = fun.tokenize(train)
train2 = fun.tokenize(train, 2)
train3 = fun.tokenize(train, 3)

# create Frequency tables
fun.frequency = function(x, minCount = 1) {
  x = x %>%
    group_by(NextWord) %>%
    summarize(count = n()) %>%
    filter(count >= minCount)
  x = x %>% 
    mutate(freq = count / sum(x$count)) %>% 
    select(-count) %>%
    arrange(desc(freq))
}

dfTrain1 = data_frame(NextWord = train1)
dfTrain1 = fun.frequency(dfTrain1)

dfTrain2 = data_frame(NextWord = train2)
dfTrain2 = fun.frequency(dfTrain2) %>%
  separate(NextWord, c('word1', 'NextWord'), " ")

dfTrain3 = data_frame(NextWord = train3)
dfTrain3 = fun.frequency(dfTrain3) %>%
  separate(NextWord, c('word1', 'word2', 'NextWord'), " ")

# get rid of profanity
dirtySeven = c('fuck', 'cunt', 'cocksucker', 'motherfucker')
dfTrain1 = filter(dfTrain1, !NextWord %in% dirtySeven)
dfTrain2 = filter(dfTrain2, !word1 %in% dirtySeven &!NextWord %in% dirtySeven)
dfTrain3 = filter(dfTrain3, !word1 %in% dirtySeven & !word2 %in% dirtySeven & !NextWord %in% dirtySeven)

#to facilitate finding 2-grams, I'll comine word 1 and word 2 into a single field
dfTrain3$combined <- paste(dfTrain3$word1, dfTrain3$word2)

#we also want to make the data a bit leaner. Take the top 80% of n-grams for prediction and toss the rest
dfTrain1<-dfTrain1[order(-dfTrain1$freq),]
dfTrain1<-dfTrain1[1:round(.8*nrow(dfTrain1)),]
dfTrain2<-dfTrain2[order(-dfTrain2$freq),]
dfTrain2<-dfTrain2[1:round(.8*nrow(dfTrain2)),]
dfTrain3<-dfTrain3[order(-dfTrain3$freq),]
dfTrain3<-dfTrain3[1:round(.8*nrow(dfTrain3)),]

# Save Data ####
saveRDS(dfTrain1, file = 'data/dfTrain1.rds')
saveRDS(dfTrain2, file = 'data/dfTrain2.rds')
saveRDS(dfTrain3, file = 'data/dfTrain3.rds')