## Team 1 README 


### Project Title: Exploration of the Intersection of Covid, Myocarditis, and Vaccination in the Published Literature

Amongst the many comorbidities that are associated with Covid-19, myocarditis – while not the most common – is one of the most critical. Establishing the trends in past research – on both myocarditis and Covid-19 – will help guide future research agendas. Our primary goal was to identify gaps in research on myocarditis in the context of Covid-19, as well as places where research to date is poor. We used Julia and the PubMed api to elucidate date, publication type, MeSH term, and free-text trends in Covid-19 publications — particularly as they pertain to myocarditis. Based on our findings, we propose that further research be done in exploring the relationship between myocarditis and Covid-19 in young males. 

### Together these scripts run an exploratory analysis of the PubMed records on Covid-19 and myocarditis


### Retrieveing records
- file information

### SA1
- file information

### SA2
- file information

### SA3
- file information

### SA4
- file information

### SA5
Julia files for running the word clouds and text mining on the titles:
- Team_1_gadam_titles.jl: Creates a dataframe of titles; runs text mining and tf/idf; creates a document with sorted terms by number of appearances (tfidf_egems_doc_file.txt) and a histogram of term prevalence 
- Team_1_gadam_title_analysis.jl: Creates word clouds from the titles of each datase and saves them as SVG files.

R scripts to run text mining on the abstracts:
- Medline.R: Retrieves XML files from PubMed for each search strategy and parses them to just the abstracts
- TM.R: Runs text-mining code on abstracts for each dataset and produces tables of the ranked terms based on TF/IDF (Covid_abstracts_top_terms.csv, Myo_and_covid_abstracts_top_terms.csv, myocarditis_abstracts_top_terms.csv)

