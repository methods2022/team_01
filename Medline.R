library(easyPubMed)
library(dplyr)
library(kableExtra)

setwd("/Volumes/Google Drive/My Drive/Personal/PhD/Classes/PHP 2561/Final project/code/medline")


my_query <- "Covid-19 AND Myocarditis"
my_pubmed_ids <- get_pubmed_ids(my_query)
my_data <- fetch_pubmed_data(my_pubmed_ids, encoding = "ASCII")

df <- table_articles_byAuth(my_data,
                            included_authors = "first",
                            max_chars = 2000,
                            encoding = "ASCII")
myo_df <- tibble(df[c(1,4)])
abstracts <- na.omit(df$abstract)

