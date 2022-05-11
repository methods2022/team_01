
#populate files with study info using collected pmids
function populate_vax(dataset, vax, vax_info)

    #open input files
    input_file = open(dataset, "r")
    input_file1 = open(vax, "r")
    #open output file
    output_file1 = open(vax_info, "w")
    #header with field data
    print(output_file1, "PMID|OWN|DCOM|TI|AU|PT|PL|TA|MH|OT\n")

    #create default id_match "N/A" as variable outside of for loop
    id_match = "N/A"
    #line_count to skip header
    line_count = 1
    #array to grab PMIDs from sorted studies
    array = []

    for id in readlines(input_file1)
        id_match = split(id, ",")
        push!(array, id_match[1])
        #println("$(id_match[1])")
    end

    #println("$array")

    #joins array PMIDs into one string
    array_string = join(array, "|")

    #for loop to read COVID-myocarditis dataset file line-by-line and match with study PMIDs
        for line in readlines(input_file)
            if line_count == 1
                line_count = 2
                continue
            end
            #splits line by delimiter, only need field one for PMID variable
                field = split(line, "|")
                pmid = field[1]
            #conditional block checks if IDs occur in the string; if yes, it writes entire
            #line to output file 
                find = findfirst(pmid, array_string)
                if find != nothing
                write(output_file1, "$line\n")
                println("match")
            end
        end
end

#calls populate_vax function to populate entire study info using PMIDs
#sorted previously in preprocess.jl. Creates vax_data and prevax_data text files.
populate_vax("covid_myocarditis_dataframe.txt", "vax.txt", "vax_data.txt")
populate_vax("covid_myocarditis_dataframe.txt", "prevax.txt", "prevax_data.txt")

