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

combinedRaw = c(blogsRaw, newsRaw, twitterRaw)

#remove raw files to save mem
rm(blogsRaw, newsRaw, twitterRaw)

# Sample and combine data. We;ll take a large sample here and only keep the most frequently occuring n-grams  
set.seed(1220)
n = 1/10
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

freq1 = data_frame(NextWord = train1)
freq1 = fun.frequency(freq1)

freq2 = data_frame(NextWord = train2)
freq2 = fun.frequency(freq2) %>%
  separate(NextWord, c('word1', 'NextWord'), " ")

freq3 = data_frame(NextWord = train3)
freq3 = fun.frequency(freq3) %>%
  separate(NextWord, c('word1', 'word2', 'NextWord'), " ")

# get rid of profanity
dirtySeven = c('fuck', 'cunt', 'cocksucker', 'motherfucker')
freq1 = filter(freq1, !NextWord %in% dirtySeven)
freq2 = filter(freq2, !word1 %in% dirtySeven &!NextWord %in% dirtySeven)
freq3 = filter(freq3, !word1 %in% dirtySeven & !word2 %in% dirtySeven & !NextWord %in% dirtySeven)

#to facilitate finding 2-grams, I'll comine word 1 and word 2 into a single field
freq3$combined <- paste(freq3$word1, freq3$word2)

#we also want to make the data a bit leaner. Take the top 80% of n-grams for prediction and toss the rest
freq1<-freq1[order(-freq1$freq),]
freq1<-freq1[1:round(.8*nrow(freq1)),]
freq2<-freq2[order(-freq2$freq),]
freq2<-freq2[1:round(.8*nrow(freq2)),]
freq3<-freq3[order(-freq3$freq),]
freq3<-freq3[1:round(.8*nrow(freq3)),]

# Save Data ####
saveRDS(freq1, file = 'data/freq1.rds')
saveRDS(freq2, file = 'data/freq2.rds')
saveRDS(freq3, file = 'data/freq3.rds')