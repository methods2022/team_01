using HTTP
using DataFrames
using CSV
using Dates

function dataframe_search(input_file, output_file)
  i = 0
  for line in readlines(input_file)
    if i == 0
      print("HEADER")
      i += 1
    else
      pubmed_date = string(split(line, "|")[6])
      print(output_file, "$(pubmed_date)|")
      rec = string(split(line, "|")[4])
      acc = string(split(line, "|")[5])
      if rec == "N/A" || acc == "N/A"
      print(output_file, "N/A\n")
      else
      rec_date = Date(parse(Int64, rec[1:4]), parse(Int64, rec[6:7]), parse(Int64, rec[9:10]))
      acc_date = Date(parse(Int64, acc[1:4]), parse(Int64, acc[6:7]), parse(Int64, acc[9:10]))

      difference = acc_date - rec_date
	 # after sorting
	 print(output_file,"$(difference)\n")
	 #print(output_file, count_df)
	 end
	 end
	 end
end

input_file = "covid_date_dataframe.txt"


output_file_name = "covid_turnaround.txt"
output_file = open(output_file_name, "w")
print(output_file, "*** COUNTS ***\n")
    
#ncbi_mesh_search(pubmed_query, year_dict)
dataframe_search(input_file, output_file)

close(output_file)