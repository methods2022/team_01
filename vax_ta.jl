#import relevant packages
using DataFrames
using CSV

# create function to extract relevant factors for post vaccination studies and pre vaccination
# TI, PT, PL, TA, DCOM, OT <-- title, publication type, place of publication, title abbreviation, date completed

#create function to extract title abbreviation (of journal name) field for vax and prevax studies

function extract_ta(input_file1, input_file2, output_file1, output_file2)

    input_file1 = open(input_file1, "r")
    input_file2 = open(input_file2, "r")

    output_file1 = open(output_file1, "w")
    output_file2 = open(output_file2, "w")
    print(output_file1, "TA|N\n")
    print(output_file2, "TA|N\n")

    vax_ta_dict = Dict()

    #skip header using line_count
    line_count = 1
    
    for line in readlines(input_file1)

        #skip first line
        if line_count == 1
            line_count = 2
            continue
        end
        
        field = split(line, "|")
        pmid = field[1]
        own = field[2]
        dcom = field[3]
        ti = field[4]
        au = field[5]
        pt = field[6]
        pl = field[7]
        ta = field[8] #<==
        mh = field[9]
        ot = field[10]

        if !haskey(vax_ta_dict, ta)
            vax_ta_dict[ta] = 1
        else
            vax_ta_dict[ta] += 1
        end

    end

    prevax_ta_dict = Dict()
    #line count variable, "lc"
    lc = 1

    for line in readlines(input_file2)

         #skip first line
         if lc == 1
            lc = 2
            continue
        end
        
        field = split(line, "|")
        pmid = field[1]
        own = field[2]
        dcom = field[3]
        ti = field[4]
        au = field[5]
        pt = field[6] 
        pl = field[7]
        ta = field[8] #<-- 
        mh = field[9]
        ot = field[10]

        if !haskey(prevax_ta_dict, ta)
            prevax_ta_dict[ta] = 1
        else
            prevax_ta_dict[ta] += 1
        end

    end

    for ta in keys(vax_ta_dict)
        print(output_file1, "$ta|$(vax_ta_dict[ta])\n")
    end

    for ta in keys(prevax_ta_dict)
        print(output_file2, "$ta|$(prevax_ta_dict[ta])\n")
    end

end

function dataframe_search(input_file, output_file)
    df = CSV.File(input_file, header=1, footerskip=0, delim="|") |> DataFrame
    
    count_df = combine(groupby(df, :TA), :N => :N)
	 
	 sort!(count_df, (:N), rev=(true))

     println(count_df)

     CSV.write(output_file, count_df)
     
end

extract_ta("vax_data.txt", "prevax_data.txt", "vax_ta.txt", "prevax_ta.txt")
dataframe_search("vax_ta.txt", "vax_ta_df.txt")
dataframe_search("prevax_ta.txt", "prevax_ta_df.txt")



