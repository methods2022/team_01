using DataFrames
using CSV

function analyze_df(input_file, output_file)

    output_file = open(output_file, "w")
    print(output_file, "PMID|DCOM|DP|REC|ACC|PM\n")

    pubmed_dict = Dict()
    id = 0
    for line in readlines(input_file)

        pmid_capture = match(r"PMID- (\d+)", line)
        if pmid_capture != nothing
            id = pmid_capture[1]
            pubmed_dict[id] = Dict()

            pubmed_dict[id]["DCOM"] = "N/A"
            pubmed_dict[id]["DP"] = "N/A"
            pubmed_dict[id]["REC"] = "N/A"
            pubmed_dict[id]["ACC"] = "N/A"
            pubmed_dict[id]["PM"] = "N/A"
            #fill in values
        end

        pmid_capture = match(r"DCOM- (\d+)", line)
        if pmid_capture != nothing
            pubmed_dict[id]["DCOM"] = pmid_capture[1]
        end
        
        pmid_capture = match(r"DP  - (.+)", line)
        if pmid_capture != nothing
            pubmed_dict[id]["DP"] = pmid_capture[1]
        end

        pmid_capture = match(r"PHST- (\d{4}\/\d{2}\/\d{2}) \d{2}:\d{2} \[received\]", line)
        if pmid_capture != nothing
            pubmed_dict[id]["REC"] = pmid_capture[1]
        end
        
        pmid_capture = match(r"PHST- (\d{4}\/\d{2}\/\d{2}) \d{2}:\d{2} \[accepted\]", line)
        if pmid_capture != nothing
            pubmed_dict[id]["ACC"] = pmid_capture[1]
        end
        
        pmid_capture = match(r"PHST- (\d{4}\/\d{2}\/\d{2}) \d{2}:\d{2} \[pubmed\]", line)
        if pmid_capture != nothing
            pubmed_dict[id]["PM"] = pmid_capture[1]
        end
        
    end

    for pub in keys(pubmed_dict)
        print(output_file, "$(pub)|$(pubmed_dict[pub]["DCOM"])|$(pubmed_dict[pub]["DP"])|$(pubmed_dict[pub]["REC"])|$(pubmed_dict[pub]["ACC"])|$(pubmed_dict[pub]["PM"])\n")
    end
        
    # for result_line in split(search_result, "\n")
    #     pmid_capture = match(r"<Id>(\d+)<\/Id>", result_line)
    #     if pmid_capture != nothing
    #         push!(pmid_set, pmid_capture[1])
    #     end
    #     # # load file into DataFrame
	#     # b_df = CSV.File(input_file, header=1, footerskip=0, delim="|") |> DataFrame

	#     # # get sleep hour counts	 
	#     # sleep_count_df = combine(groupby(b_df, :sleep_label), nrow => :N)
    # end
end

#Format: "[search]_studies.txt", "[search]_dataframe.txt"
analyze_df("myocarditis_not_covid_efetch_output.txt", "myocarditis_not_covid_date_dataframe.txt")
