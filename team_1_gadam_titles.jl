using DataFrames
using CSV
using TextAnalysis
using WordCloud
using StatsPlots

input_file = "covid_myocarditis_dataframe.txt"
cps = Corpus([])
    for line in eachline(input_file)
        line_part_array = split(line, "|")
        title = line_part_array[4] 
        string_doc = StringDocument(title)
        push!(cps,string_doc)
    end

    remove_corrupt_utf8!(cps)
    remove_case!(cps)
    prepare!(cps, strip_punctuation | strip_articles | strip_pronouns | strip_numbers | strip_non_letters | strip_stopwords)
    stem!(cps)
    update_lexicon!(cps)
    #println(lexicon(cps))
    m = DocumentTermMatrix(cps)
    tfidf_m = tf_idf(m)
    #println(tfidf_m)
    feature_array = collect(keys(cps.lexicon))

    #Use Excel to create a table from lexicon with top 25 most common terms

    #create histograms of term frequency before and after tfidf

    egems_metamap_lex_file = open("egems_metamap_lex_file.txt", "w")
    lex_dict=cps.lexicon
    for (k,v) in lex_dict
    write(egems_metamap_lex_file, "$v\t$k\n")
    #println("$v\t$k")
    end
    close(egems_metamap_lex_file)

   
    import SparseArrays: findnz
    tfidf_egems_doc_file = open("tfidf_egems_doc_file.txt", "w")
    egems_doc_file = open("egems_doc_file.txt", "w")
    
    
    tfidf_vec = []
    for i in 1:(size(tfidf_m)[1])
        abs = findnz(tfidf_m[i,:])
        word_id = join(abs[1],",")
        word_count = join(abs[2],",")
        write(tfidf_egems_doc_file, "$word_id\n")
        write(tfidf_egems_doc_file, "$word_count\n")
        append!(tfidf_vec,abs[2])
    end

    close(egems_doc_file)
    
    ht = histogram(tfidf_vec, title="TF-IDF Counts",legend=false)
    savefig(ht,"tfidf_histogram.png")


  

  #do this for pre & post vax datasets

