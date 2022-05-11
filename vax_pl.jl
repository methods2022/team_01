#import relevant packages
using DataFrames
using CSV

# create function to extract relevant factors for post vaccination studies and pre vaccination
# TI, PT, PL, TA, DCOM, OT <-- title, publication type, place of publication, title abbreviation, date completed

#create function to extract publication location (pl) field for vax and prevax studies

function extract_pl(input_file1, input_file2, output_file1, output_file2)

    #open input and output files
    input_file1 = open(input_file1, "r")
    input_file2 = open(input_file2, "r")

    output_file1 = open(output_file1, "w")
    output_file2 = open(output_file2, "w")
    print(output_file1, "PL|N\n")
    print(output_file2, "PL|N\n")

    #create vax publication location dictionary
    vax_pl_dict = Dict()

     #skip header using line_count
     line_count = 1
    
     #read vax study file line by line
    for line in readlines(input_file1)

        #skip first line
        if line_count == 1
            line_count = 2
            continue
        end
        
        #PubMed data element fields, split by pipe delimiter
        field = split(line, "|")
        pmid = field[1]
        own = field[2]
        dcom = field[3]
        ti = field[4]
        au = field[5]
        pt = field[6] 
        pl = field[7] #<-- grab this field for pub location
        ta = field[8]
        mh = field[9]
        ot = field[10]

        #add pub locations and counts to dictionary
        if !haskey(vax_pl_dict, pl)
            vax_pl_dict[pl] = 1
        else
            vax_pl_dict[pl] += 1
        end

    end

    #create prevax study pub location dictionary 
    prevax_pl_dict = Dict()
    #line count variable, "lc"
    lc = 1

    #read prevax study file line by line
    for line in readlines(input_file2)

        #skip first line
        if lc == 1
            lc = 2
            continue
        end
        
        #split fields
        field = split(line, "|")
        pmid = field[1]
        own = field[2]
        dcom = field[3]
        ti = field[4]
        au = field[5]
        pt = field[6] 
        pl = field[7] #<-- grab pub location
        ta = field[8]
        mh = field[9]
        ot = field[10]

        #adds pub locations and counts to prevax dictionary
        if !haskey(prevax_pl_dict, pl)
            prevax_pl_dict[pl] = 1
        else
            prevax_pl_dict[pl] += 1
        end

    end

    #print all locations and counts for prevax and vax studies
    for pl in keys(vax_pl_dict)
        print(output_file1, "$pl|$(vax_pl_dict[pl])\n")
    end

    for pl in keys(prevax_pl_dict)
        print(output_file2, "$pl|$(prevax_pl_dict[pl])\n")
    end

end

#creates dataframes for publication location data
function dataframe_search(input_file, output_file)
    df = CSV.File(input_file, header=1, footerskip=0, delim="|") |> DataFrame
    
    count_df = combine(groupby(df, :PL), :N => :N)

	 sort!(count_df, (:N), rev=(true))
	 
     println(count_df)

     CSV.write(output_file, count_df)
     
end

#call functions
extract_pl("vax_data.txt", "prevax_data.txt", "vax_pl.txt", "prevax_pl.txt")
dataframe_search("vax_pl.txt", "vax_pl_df.txt")
dataframe_search("prevax_pl.txt", "prevax_pl_df.txt")



