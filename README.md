## Team 1 README 


### Project Title: Exploration of the Intersection of Covid, Myocarditis, and Vaccination in the Published Literature

Amongst the many comorbidities that are associated with Covid-19, myocarditis – while not the most common – is one of the most critical. Establishing the trends in past research – on both myocarditis and Covid-19 – will help guide future research agendas. Our primary goal was to identify gaps in research on myocarditis in the context of Covid-19, as well as places where research to date is poor. We used Julia and the PubMed api to elucidate date, publication type, MeSH term, and free-text trends in Covid-19 publications — particularly as they pertain to myocarditis. Based on our findings, we propose that further research be done in exploring the relationship between myocarditis and Covid-19 in young males. 

### Together these scripts run an exploratory analysis of the PubMed records on Covid-19 and myocarditis.


### Retrieve records from PubMed
- Julia file for running PubMed search:
- pubmed_search.jl: uses PubMed esearch utility to identify resulting publications for a given search term. The PMIDs are then used to submit an efetch request to retrieve publication details. The efetch output is saved for further analysis.
- Julia file for converting efetch output to dataframe
- pubmed_efetch_to_dataframe.jl: indexes through provided efetch output file and identifies lines of interest to add to dictionary. These are then formatted into a dataframe and outputted


### SA1
- Julia file for identifying comorbidities that co-occur with COVID-19 and myocarditis:
covid_comorbidities.jl: creates two text files (covid_comorbidities_counts.txt and covid_myo_comorbidities_counts.txt), each of which contains a table of the MH (MeSH Header) and OT (Other Terms) terms from the COVID-19 data frame – covid_dataframe.txt – as well as the COVID-19 and Myocarditis dataframe   covid_myocarditis_dataframe.txt. 

### SA2
Each category has an accompanying file titled “<category>_efetch_output.txt”. Larger searches may be followed by a retstart value. These files can then be read into “pubmed_efetch_to_dataframe.jl”, outputting “<category>_dataframe.txt”. Similarly, larger searches may be followed by a retstart value.
- The “counts” folder contains all basic counts. These are generated from “pubmed_counts.jl”.
- The “date” folder contains files related to dates. There is a separate “pubmed_efetch_to_date_dataframe.jl” file that generates dataframes with date-specific terms. The folder contains the subsequent date dataframe results. It also contains date counts files and other relevant files.
turnaround_calculator.jl: calculates publication turnaround for the specified subset of data
- The “covid” folder includes files used to generate the larger COVID-19 dataframe. This requires several dataframes that are combined to form a larger one to due the large number of results.

### SA3
Julia files for sorting COVID and myocarditis dataset by vaccination status:
- preprocess.jl: creates two text files (prevax.txt and vax.txt) which contain a list of PubMed IDs (PMIDs) of putative pre-vaccination studies and vaccination studies using vaccination MeSH terms to sort studies from the Covid-19 and Myocarditis dataframe. Requires “covid_myocarditis_dataframe.txt” to run, but can be done with any dataframe.
- vax_study_info.jl: uses prevax.txt and vax.txt to populate files prevax_data.txt and vax_data.txt with complete study information (i.e., all PubMed field descriptions labeled in the header line of the dataframes). Each line contains the field description data for each PMID in the input files to finalize sorting of the pre-vaccination and vaccination datasets. 
- Julia files for extracting PubMed field descriptions from sorted subsets:
- vax_pub_type.jl: extracts publication type (labeled as “PT” in header and on PubMed) for the input files prevax_data.txt and vax_data.txt, which contain sorted study data. Output files "vax_pt.txt” and "prevax_pt.txt" are made containing publication types with respective counts for each publication type for both data subsets. This uses the function ”extract_pt()”, “dataframe_search()” is used to create sorted data frames of the pre-vaccination and vaccination publication type data from "vax_pt.txt” and "prevax_pt.txt".
- Vax_pl.jl: extracts publication location (labeled as “PL” in header and on PubMed) for the input files prevax_data.txt and vax_data.txt using function ”extract_pl()”, . Output files "vax_pl.txt” and "prevax_pl.txt" are made containing publication locations with respective counts for each publication location for both data subsets. “dataframe_search()” is used to create sorted data frames of the pre-vaccination and vaccination publication type data from "vax_pl.txt” and "prevax_pl.txt".
- vax_ta.jl: extracts publication title abbreviation of journal name (labeled as “TA” in header and on PubMed) for the input files prevax_data.txt and vax_data.txt using function ”extract_ta()”, . Output files "vax_ta.txt” and "prevax_ta.txt" are made containing title abbreviations with respective counts for each TA for both data subsets. “dataframe_search()” is used to create sorted data frames of the pre-vaccination and vaccination title abbreviation data from "vax_ta.txt” and "prevax_ta.txt".
- vax_dcom.jl: extracts publication date completed information (i.e., the YYYYMM data from the DCOM field; the entire field is formatted as YYYYMMDD, which represents the year, month, and day of when the study records processing was completed) for the input files prevax_data.txt and vax_data.txt using function ”extract_dcom()”, . Output files "vax_dcom.txt” and "prevax_dcom.txt" are made containing DCOM data with respective counts for each DCOM for both data subsets. “dataframe_search()” is used to create sorted data frames of the pre-vaccination and vaccination DCOM data from "vax_dcom.txt” and "prevax_dcom.txt".
Julia file to perform analysis of treatment/diagnostic tools MeSH terms:
- vax_treatments_terms.jl: performs analysis of input files prevax_data.txt and vax_data.txt datasets to collect counts of treatment terms for each set. Prints the data to the output files "vax_treatments.txt" and "prevax_treatments.txt". Data frames are created using the output files sorted by count ("prevax_treatments_df.txt" and "vax_treatments_df.txt").
### SA4
Julia files for determining counts for age and sex related terms. 
- age_counts_1.jl: creates a table/output file that has counts for age group terms (Adult, Child, Adolescent and Infant) and sex related terms (Male and Female) in the Covid-19 data frame covid_dataframe.txt as well as the Covid-19 and Myocarditis dataframe   covid_myocarditis_dataframe.txt. 

### SA5
Julia files for running the word clouds and text mining on the titles:
- Team_1_gadam_titles.jl: Creates a dataframe of titles; runs text mining and tf/idf; creates a document with sorted terms by number of appearances (tfidf_egems_doc_file.txt) and a histogram of term prevalence 
- Team_1_gadam_title_analysis.jl: Creates word clouds from the titles of each datase and saves them as SVG files.

R scripts to run text mining on the abstracts:
- Medline.R: Retrieves XML files from PubMed for each search strategy and parses them to just the abstracts
- TM.R: Runs text-mining code on abstracts for each dataset and produces tables of the ranked terms based on TF/IDF (Covid_abstracts_top_terms.csv, Myo_and_covid_abstracts_top_terms.csv, myocarditis_abstracts_top_terms.csv)

