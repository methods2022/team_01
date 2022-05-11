#grab dcom month and year
#format is YYYYMMDD

#Date Completed is the date processing of the record ends; i.e., 
#MeSH® Headings have been added, quality assurance validations are completed, 
#and the completed record subsequently is distributed to PubMed and licensees. 
#This is contrasted with Date Created, which is the date processing begins.

#import relevant packages
using DataFrames
using CSV

# create function to extract relevant factors for post vaccination studies and pre vaccination
# TI, PT, PL, TA, DCOM, OT <-- title, publication type, place of publication, title abbreviation, date completed

#create function to extract date completed field for vax and prevax studies

function extract_dcom(input_file1, input_file2, output_file1, output_file2)


    input_file1 = open(input_file1, "r")
    input_file2 = open(input_file2, "r")

    output_file1 = open(output_file1, "w")
    output_file2 = open(output_file2, "w")
    print(output_file1, "DCOM|N\n")
    print(output_file2, "DCOM|N\n")

    #create vax dcom dictionaries; includes month and year values based on PubMed
    #field description format for DCOM from Jan. 2020 up until April 2022 according to
    #relevancy to COVID-19 timeline
    vax_dcom_dict = Dict()
    vax_month_dict = Dict()
    vax_month_dict["202001"] = 0
    vax_month_dict["202002"] = 0
    vax_month_dict["202003"] = 0
    vax_month_dict["202004"] = 0
    vax_month_dict["202005"] = 0
    vax_month_dict["202006"] = 0
    vax_month_dict["202007"] = 0
    vax_month_dict["202008"] = 0
    vax_month_dict["202009"] = 0
    vax_month_dict["202010"] = 0
    vax_month_dict["202011"] = 0
    vax_month_dict["202012"] = 0
    vax_month_dict["202101"] = 0
    vax_month_dict["202102"] = 0
    vax_month_dict["202103"] = 0
    vax_month_dict["202104"] = 0
    vax_month_dict["202105"] = 0
    vax_month_dict["202106"] = 0
    vax_month_dict["202107"] = 0
    vax_month_dict["202108"] = 0
    vax_month_dict["202109"] = 0
    vax_month_dict["202110"] = 0
    vax_month_dict["202111"] = 0
    vax_month_dict["202112"] = 0
    vax_month_dict["202201"] = 0
    vax_month_dict["202202"] = 0
    vax_month_dict["202203"] = 0
    vax_month_dict["202204"] = 0
    vax_month_dict["202205"] = 0
    vax_month_dict["202206"] = 0
    vax_month_dict["202207"] = 0
    vax_month_dict["202208"] = 0
    vax_month_dict["202209"] = 0
    vax_month_dict["202210"] = 0
    vax_month_dict["202211"] = 0
    vax_month_dict["202212"] = 0
    vax_month_dict["N/A"] = 0

    linec = 1
    vax_pub_count = 0
    for line in readlines(input_file1)

        if linec == 1
            linec = 2
            continue
        end

        vax_pub_count += 1
        field = split(line, "|")
        pmid = field[1]
        own = field[2]
        dcom = field[3] # <--
        ti = field[4]
        au = field[5]
        pt = field[6] 
        pl = field[7] 
        ta = field[8]
        mh = field[9]
        ot = field[10]

        #if dcom value is available, conditional block grabs year and month values 
        #formatted as YYYYMM and day, formatted as DD. Otherwise, no data available.
        if dcom != "N/A"
        year_month = dcom[1:6]
        day = dcom[7:8]
        else
        year_month = "N/A"
        day = "N/A"
        end

        #keeps record of dates for when dcom added
        if !haskey(vax_dcom_dict, dcom)
            vax_dcom_dict[dcom] = 1
        else
            vax_dcom_dict[dcom] += 1
        end

        #if year and month data was available, add to vax month dict to keep track
        #of timeline of dcom for publications
        if year_month != "N/A"
            vax_month_dict[year_month] += 1
        else
            vax_month_dict["N/A"] += 1
        end


    end

    #create prevax dcom dictionaries; includes month and year values based on PubMed
    #field description format for DCOM from Jan. 2020 up until April 2022 according to
    #relevancy to COVID-19 timeline
    prevax_dcom_dict = Dict()
    prevax_month_dict = Dict()
    prevax_month_dict["202001"] = 0
    prevax_month_dict["202002"] = 0
    prevax_month_dict["202003"] = 0
    prevax_month_dict["202004"] = 0
    prevax_month_dict["202005"] = 0
    prevax_month_dict["202006"] = 0
    prevax_month_dict["202007"] = 0
    prevax_month_dict["202008"] = 0
    prevax_month_dict["202009"] = 0
    prevax_month_dict["202010"] = 0
    prevax_month_dict["202011"] = 0
    prevax_month_dict["202012"] = 0
    prevax_month_dict["202101"] = 0
    prevax_month_dict["202102"] = 0
    prevax_month_dict["202103"] = 0
    prevax_month_dict["202104"] = 0
    prevax_month_dict["202105"] = 0
    prevax_month_dict["202106"] = 0
    prevax_month_dict["202107"] = 0
    prevax_month_dict["202108"] = 0
    prevax_month_dict["202109"] = 0
    prevax_month_dict["202110"] = 0
    prevax_month_dict["202111"] = 0
    prevax_month_dict["202112"] = 0
    prevax_month_dict["202201"] = 0
    prevax_month_dict["202202"] = 0
    prevax_month_dict["202203"] = 0
    prevax_month_dict["202204"] = 0
    prevax_month_dict["202205"] = 0
    prevax_month_dict["202206"] = 0
    prevax_month_dict["202207"] = 0
    prevax_month_dict["202208"] = 0
    prevax_month_dict["202209"] = 0
    prevax_month_dict["202210"] = 0
    prevax_month_dict["202211"] = 0
    prevax_month_dict["202212"] = 0
    prevax_month_dict["N/A"] = 0

    line_count = 1
    prevax_pub_count = 0
    for line in readlines(input_file2)

        if line_count == 1
            line_count = 2
            continue
        end
        prevax_pub_count += 1
        field = split(line, "|")
        pmid = field[1]
        own = field[2]
        dcom = field[3]
        ti = field[4]
        au = field[5]
        pt = field[6] 
        pl = field[7] #<-- 
        ta = field[8]
        mh = field[9]
        ot = field[10]

        if dcom != "N/A"
            year_month = dcom[1:6]
            day = dcom[7:8]
        else
        year_month = "N/A"
        day = "N/A"
        end

        if !haskey(prevax_dcom_dict, dcom)
            prevax_dcom_dict[dcom] = 1
        else
            prevax_dcom_dict[dcom] += 1
        end

        if year_month != "N/A"
            prevax_month_dict[year_month] += 1
        else
            prevax_month_dict["N/A"] += 1
        end

    end

    # for dcom in keys(vax_dcom_dict)
    #     print(output_file1, "$dcom|$(vax_dcom_dict[dcom])\n")
    # end

    # for dcom in keys(prevax_dcom_dict)
    #     print(output_file2, "$dcom|$(prevax_dcom_dict[dcom])\n")
    # end

    #prints dcom values and counts for vax and prevax studies if count does not equal zero
    for my in keys(vax_month_dict)
       
        if vax_month_dict[my] != 0
        print(output_file1, "$my|$(vax_month_dict[my])\n")
        end

        if my == "N/A"
        println("$(vax_month_dict[my])")
        end

    end

    for my in keys(prevax_month_dict)

        if prevax_month_dict[my] != 0
        print(output_file2, "$my|$(prevax_month_dict[my])\n")
        end

        if my == "N/A"
        println("$(prevax_month_dict[my])")
        end

    end

    #println("$vax_pub_count and $prevax_pub_count")

end

#create dataframes for dcom data
function dataframe_search(input_file, output_file)
    df = CSV.File(input_file, header=1, footerskip=0, delim="|") |> DataFrame
    
    count_df = combine(groupby(df, :DCOM), :N => :N)
	 
	 sort!(count_df, (:N), rev=(true))

     println(count_df)

     CSV.write(output_file, count_df)
     
end

#call functions
extract_dcom("vax_data.txt", "prevax_data.txt", "vax_dcom.txt", "prevax_dcom.txt")
dataframe_search("vax_dcom.txt", "vax_dcom_df.txt")
dataframe_search("prevax_dcom.txt", "prevax_dcom_df.txt")



