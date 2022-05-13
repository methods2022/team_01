using HTTP
using DataFrames
using CSV

function dataframe_search(input_file, output_file)
    df = CSV.File(input_file, header=1, footerskip=0, delim="|") |> DataFrame
    count_df = combine(groupby(df, :PM), nrow => :N)
	 
	 # before sorting
	 # println(sleep_count_df)

	 # sort by count
	 sort!(count_df, (:PM), rev=(false))
	 
	 # after sorting
	 print(output_file, count_df)
end

input_file = "myocarditis_not_covid_date_dataframe.txt"


output_file_name = "myocarditis_not_covid_pubmed_date.txt"
output_file = open(output_file_name, "w")
print(output_file, "*** COUNTS ***\n")
    
#ncbi_mesh_search(pubmed_query, year_dict)
dataframe_search(input_file, output_file)

close(output_file)