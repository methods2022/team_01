library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("syuzhet")
library("ggplot2")
library("dplyr")
library(tidyr)
library(broom)
library(table1) 
library(stringr)
library(ggplot2)
library(kableExtra)
library(tidytext)
library(tidyverse)
library(topicmodels)
library(forcats)
library(reshape2)

myo_abstracts.count <- myo_df %>% 
  unnest_tokens(word, abstract) %>% 
  anti_join(stop_words)%>%
  count(pmid, word, sort = TRUE) %>%
  ungroup()

#count terms
int_dtm <- myo_abstracts.count %>%
  cast_dtm(pmid, word, n) 

#create a topic map
int_lda <- LDA(int_dtm, k = 30, control = list(seed = 1234))
int_lda_tidy <- tidy(int_lda)
int_gamma <- tidy(int_lda, matrix = "gamma")

int_terms <- int_lda_tidy %>%
  group_by(topic) %>%
  arrange(topic, -beta)

#find the top terms for each topic
top_int_terms <- int_lda_tidy %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

write.table(top_int_terms, file = "myo_and_covid_abstracts_top_terms.csv")

