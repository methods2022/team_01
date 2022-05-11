
using DataFrames
using CSV
using TextAnalysis
using WordCloud

# create dataframe from input file
input_file = open("/gpfs/data/biol1555/projects2022/team01/covid_dataframe.txt", "r")
df = CSV.File(input_file, header = 1, footerskip = 0, delim = "|") |> DataFrame
titles = df[:, ["TI"]]
CSV.write("covid_titles.txt", titles)

#=covid and myocarditis
    wc = wordcloud(
    processtext(open("/gpfs/data/biol1555/projects2022/team01/covid_myocarditis_titles.txt"), stopwords=WordCloud.stopwords_en),
    colors = :Set1_5,
    angles = (0, 90),
    maxfontsize = 131.2,
    density = 0.55) |> generate!
    paint(wc, "titlecloud_cov_myo.svg")


#prevax
    wc2 = wordcloud(
    processtext(open("prevax_titles.txt"), stopwords=WordCloud.stopwords_en),
    colors = :Set1_5,
    angles = (0, 90),
    maxfontsize = 131.2,
    density = 0.55) |> generate!
    paint(wc2, "titlecloud_prevax.svg")


#postvax
    wc3 = wordcloud(
    processtext(open("vax_titles.txt"), stopwords=WordCloud.stopwords_en),
    colors = :Set1_5,
    angles = (0, 90),
    maxfontsize = 131.2,
    density = 0.55) |> generate!
    paint(wc3, "titlecloud_postvax.svg")
    
#myocarditis
    wc3 = wordcloud(
    processtext(open("myocarditis_titles.txt"), stopwords=WordCloud.stopwords_en),
    colors = :Set1_5,
    angles = (0, 90),
    maxfontsize = 131.2,
    density = 0.55) |> generate!
    paint(wc3, "titlecloud_myocarditis.svg")=#

#covid
wc3 = wordcloud(
    processtext(open("covid_titles.txt"), stopwords=WordCloud.stopwords_en),
    colors = :Set1_5,
    angles = (0, 90),
    maxfontsize = 131.2,
    density = 0.55) |> generate!
    paint(wc3, "titlecloud_covid.svg")