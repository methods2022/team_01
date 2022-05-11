#import relevant packages
using DataFrames
using CSV

# create function to extract relevant factors for post vaccination studies and pre vaccination
# TI, PT, PL, TA, DCOM, OT <-- title, publication type, place of publication, title abbreviation, date completed

#create function to extract publication type field for vax and prevax studies
function extract_pt(input_file1, input_file2, output_file1, output_file2)

    #open input files which contain vax and prevax study info
    input_file1 = open(input_file1, "r")
    input_file2 = open(input_file2, "r")

    #open output files to write pub type categories and respective counts
    output_file1 = open(output_file1, "w")
    output_file2 = open(output_file2, "w")
    print(output_file1, "PT|N\n")
    print(output_file2, "PT|N\n")

    #create vax pub type dictionary
    vax_pt_dict = Dict()
    #skip header using line_count
    line_count = 1
    
    #for loop runs through vax study data file to extract pub type field and add 
    #type + counts to vax_pt_dict
    for line in readlines(input_file1)
        #skip first line
        if line_count == 1
            line_count = 2
            continue
        end

        #use delimiter to split into fields, relevant field here indicated by arrow
        field = split(line, "|")
        pmid = field[1]
        own = field[2]
        dcom = field[3]
        ti = field[4]
        au = field[5]
        pt = field[6] #<-- 
        pl = field[7]
        ta = field[8]
        mh = field[9]
        ot = field[10]

        #add pub types and counts to dict for vax studies
        if !haskey(vax_pt_dict, pt)
            vax_pt_dict[pt] = 1
        else
            vax_pt_dict[pt] += 1
        end

    end

    #create prevax pub type dictionary
    prevax_pt_dict = Dict()
    #line count variable, "lc"
    lc = 1
    for line in readlines(input_file2)
        #skip first line
        if lc == 1
            lc = 2
            continue
        end

        #split line by delimiter, grab field six, pt
        field = split(line, "|")
        pmid = field[1]
        own = field[2]
        dcom = field[3]
        ti = field[4]
        au = field[5]
        pt = field[6] #<-- 
        pl = field[7]
        ta = field[8]
        mh = field[9]
        ot = field[10]

        #add pub types and counts to prevax dictionary
        if !haskey(prevax_pt_dict, pt)
            prevax_pt_dict[pt] = 1
        else
            prevax_pt_dict[pt] += 1
        end

    end

    #print publication types and counts for vaccination and pre-vaccination studies
    #using for loops
    for pt in keys(vax_pt_dict)
        print(output_file1, "$pt|$(vax_pt_dict[pt])\n")
    end

    for pt in keys(prevax_pt_dict)
        print(output_file2, "$pt|$(prevax_pt_dict[pt])\n")
    end

end

#function used to create dataframes of publication type data for vaccination and prevaccination studies
function dataframe_search(input_file, output_file)
    df = CSV.File(input_file, header=1, footerskip=0, delim="|") |> DataFrame
    
    count_df = combine(groupby(df, :PT), :N => :N)

	 sort!(count_df, (:N), rev=(true))
	 
     println(count_df)

     CSV.write(output_file, count_df)
     
end

#call functions
extract_pt("vax_data.txt", "prevax_data.txt", "vax_pt.txt", "prevax_pt.txt")
dataframe_search("vax_pt.txt", "vax_pt_df.txt")
dataframe_search("prevax_pt.txt", "prevax_pt_df.txt")



