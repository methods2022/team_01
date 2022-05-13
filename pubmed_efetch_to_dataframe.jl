using DataFrames
using CSV

function analyze_df(input_file, output_file)

    output_file = open(output_file, "w")
    print(output_file, "PMID|OWN|DCOM|TI|AU|PT|PL|TA|MH|OT\n")

    pubmed_dict = Dict()
    id = 0
    for line in readlines(input_file)

        pmid_capture = match(r"PMID- (\d+)", line)
        if pmid_capture != nothing
            id = pmid_capture[1]
            pubmed_dict[id] = Dict()

            pubmed_dict[id]["OWN"] = "N/A"
            pubmed_dict[id]["DCOM"] = "N/A"
            pubmed_dict[id]["TI"] = "N/A"
            pubmed_dict[id]["AU"] = "N/A"
            pubmed_dict[id]["PT"] = "N/A"
            pubmed_dict[id]["PL"] = "N/A"
            pubmed_dict[id]["TA"] = "N/A"
            pubmed_dict[id]["MH"] = "N/A"
            pubmed_dict[id]["OT"] = "N/A"
            #fill in values
        end

        pmid_capture = match(r"OWN - (\w+)", line)
        if pmid_capture != nothing
            pubmed_dict[id]["OWN"] = pmid_capture[1]
        end

        pmid_capture = match(r"DCOM- (\d+)", line)
        if pmid_capture != nothing
            pubmed_dict[id]["DCOM"] = pmid_capture[1]
        end
        
        pmid_capture = match(r"TI  - (.+)", line)
        if pmid_capture != nothing
            pubmed_dict[id]["TI"] = pmid_capture[1]
        end

        pmid_capture = match(r"AU - (.+)", line)
        if pmid_capture != nothing
            if pubmed_dict[id]["AU"] == "N/A"
                pubmed_dict[id]["AU"] = [pmid_capture[1]]
            else
                push!(pubmed_dict[id]["AU"], pmid_capture[1])
            end
        end

        pmid_capture = match(r"PT  - (.+)", line)
        if pmid_capture != nothing
            pubmed_dict[id]["PT"] = pmid_capture[1]
        end

        pmid_capture = match(r"PL  - (.+)", line)
        if pmid_capture != nothing
            pubmed_dict[id]["PL"] = pmid_capture[1]
        end

        pmid_capture = match(r"TA  - (.+)", line)
        if pmid_capture != nothing
            pubmed_dict[id]["TA"] = pmid_capture[1]
        end

        pmid_capture = match(r"MH  - (.+)", line)
        if pmid_capture != nothing
            if pubmed_dict[id]["MH"] == "N/A"
                pubmed_dict[id]["MH"] = [pmid_capture[1]]
            else
                push!(pubmed_dict[id]["MH"], pmid_capture[1])
            end
        end
        
        pmid_capture = match(r"OT  - (.+)", line)
        if pmid_capture != nothing
            if pubmed_dict[id]["OT"] == "N/A"
                pubmed_dict[id]["OT"] = [pmid_capture[1]]
            else
                push!(pubmed_dict[id]["OT"], pmid_capture[1])
            end
        end
    end

    for pub in keys(pubmed_dict)
        print(output_file, "$(pub)|$(pubmed_dict[pub]["OWN"])|$(pubmed_dict[pub]["DCOM"])|$(pubmed_dict[pub]["TI"])|$(pubmed_dict[pub]["AU"])|$(pubmed_dict[pub]["PT"])|$(pubmed_dict[pub]["PL"])|$(pubmed_dict[pub]["TA"])|$(pubmed_dict[pub]["MH"])|$(pubmed_dict[pub]["OT"])\n")
    end
        
end

#Format: "[search]_studies.txt", "[search]_dataframe.txt"
analyze_df("covid_efetch_output_180000.txt", "covid_dataframe_180000.txt")
