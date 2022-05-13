using HTTP
using DataFrames
using CSV

function ncbi_mesh_search(pubmed_query, dictionary)
    println("searching for articles with query $pubmed_query")
    
    base_search_query = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
    
    query_dict = Dict()
    query_dict["api_key"] = "07f792b30274cc35456509b19926b73c1e08"
    query_dict["db"] = "pubmed"
    query_dict["term"] = pubmed_query
    query_dict["retmax"] = 10000

    search_result = String(HTTP.post(base_search_query, body = HTTP.escapeuri(query_dict)))

    pmid_set = Set()
    for result_line in split(search_result, "\n")
        pmid_capture = match(r"<Id>(\d+)<\/Id>", result_line)
        if pmid_capture != nothing
            push!(pmid_set, pmid_capture[1])
        end
    end

    id_string = join(collect(pmid_set), ",")

    base_fetch_query = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
    query_dict["api_key"] = "07f792b30274cc35456509b19926b73c1e08"
    query_dict["db"] = "pubmed"
    query_dict["id"] = id_string
    query_dict["rettype"] = "medline"
    query_dict["retmode"] = "text"

    fetch_result = String(HTTP.post(base_fetch_query, body = HTTP.escapeuri(query_dict)))

    for fetch_line in split(fetch_result, "\n")
        mesh_capture = match(r"DP  - (\d{4})", fetch_line)
        if mesh_capture != nothing
            year = mesh_capture[1]
            if !haskey(dictionary, year)
                dictionary[year] = 1
            else
                dictionary[year] += 1
            end
        end
    end
end

function dataframe_search(input_file, output_file)
    df = CSV.File(input_file, header=1, footerskip=0, delim="|") |> DataFrame
    count_df = combine(groupby(df, :DP), nrow => :N)
	 
	 # before sorting
	 # println(sleep_count_df)

	 # sort by count
	 sort!(count_df, (:N), rev=(true))
	 
	 # after sorting
	 print(output_file, count_df)
end

input_file = "covid_myocarditis_date_dataframe.txt"


output_file_name = "covid_myocarditis_date_count.txt"
output_file = open(output_file_name, "w")
print(output_file, "*** COUNTS ***\n")
    
year_dict = Dict()
pubmed_query = "(\"COVID-19\"[OT] OR \"COVID-19\"[MH]) AND (\"Myocarditis\"[OT] OR \"Myocarditis\"[MH])"
#ncbi_mesh_search(pubmed_query, year_dict)
dataframe_search(input_file, output_file)

close(output_file)