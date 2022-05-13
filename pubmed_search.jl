using HTTP

output_name = "covid_efetch_output_180000.txt"
output_file = open(output_name, "a")
    
function ncbi_mesh_search(pubmed_query, api_key)
#file name for output
    # define base URL
    base_search_query = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
    # define query dictionary to send to the URL
    query_dict = Dict()
    query_dict["api_key"] = api_key
    query_dict["db"] = "pubmed"
    query_dict["term"] = pubmed_query
    query_dict["retmax"] = 300000
    # send query to esearch
    search_result = String(HTTP.post(base_search_query, body=HTTP.escapeuri(query_dict)))
    #print(search_result)
    # instantiate pmid_set
    pmid_set = Set()

    # parse through each result line
    for result_line in split(search_result, "\n")
        pmid_capture = match(r"<Id>(\d+)<\/Id>", result_line)
        if pmid_capture != nothing
            push!(pmid_set, pmid_capture[1])
        end
    end
  return(pmid_set)
  # convert set to a comma list
end

function efetch(pmid_set, start)
  println(length(pmid_set))
  id_string = join(collect(pmid_set), ",")

    # update query dictionary for fetch query
    base_fetch_query = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
    query_dict = Dict()
    query_dict["db"] = "pubmed"
    query_dict["api_key"] = api_key
    query_dict["id"] = id_string
    query_dict["rettype"] = "medline"
    query_dict["retstart"] = start
    query_dict["retmode"] = "text"
    # send query dictionary to efetch
    fetch_result = String(HTTP.post(base_fetch_query, body=HTTP.escapeuri(query_dict)))
    print(output_file,"START: $start\n")
    print(output_file,"$fetch_result")
  
end

api_key = "07f792b30274cc35456509b19926b73c1e08"
pubmed_query = "\"COVID-19\"[OT] OR \"COVID-19\"[MH]" 

try
pmid_set = ncbi_mesh_search(pubmed_query, api_key)
efetch(pmid_set, "200000")
return("Attempting search")
catch e
    if isa(e, LoadError)
        sleep(2)
    end
end

close(output_file)

