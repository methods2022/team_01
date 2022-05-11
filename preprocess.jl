#load packages
using DataFrames
using CSV

#function vax_status_reattempt is a reattempt at separating 
#studies from the COVID-19-myocarditis study set by vaccination MeSH term
#it first creates an create array of accepted terms and loops through terms 
#using each one to find the first occurrence of a term in the MeSH and or OT fields
#(i.e., if either field is available; some studies lack these fields)
#if nothing is found, it is a putative prevax study. Otherwise, it is a vax study.

#separate studies into vax studies and prevax using terms; save to separate files for further extraction analysis
function vax_status_reattempt(input_file, vax_output)

    #open input_file file and read; open output file and write
    input_file = open(input_file, "r")
    output_file1 = open(vax_output, "w")
    
    #array of accepted vaccination MeSH terms
    vax_terms = ["COVID-19 Vaccines/*adverse effects","COVID-19 Vaccines/administration & dosage/*adverse effects","mRNA Vaccines", "COVID-19 Vaccines","2019-nCoV Vaccine mRNA-1273","COVID-19 Vaccines/adverse effects","COVID-19 mRNA vaccine","vaccines","Vaccine","COVID-19 vaccine","*Vaccine","*Vaccines","COVID-19 Vaccines/*adverse effects","*mRNA vaccines","immunological products and vaccines","*Mrna vaccines","COVID-19 Vaccines/administration & dosage","2019-nCoV Vaccine mRNA-1273/adverse effects","COVID-19 Vaccines/*adverse effects/*immunology","covid-19 vaccine","moderna vaccine","mrna-1237","Immunogenicity, Vaccine", "*Immunogenicity, Vaccine","covid-19 vaccine complication","post vaccination myocarditis","mrna vaccine","COVID-19 Vaccines/therapeutic use","vaccine-induced myocarditis","Vaccines, Synthetic/adverse effects","vaccine associated myocarditis","Vaccine-associated myocarditis","covid-19 mrna vaccine","*Covid vaccine","*RNA vaccine","*mRNA-1273 vaccine","mRNA-1273 vaccine","vaccine myocarditis","*mRNA COVID-19 vaccine-associated myopericarditis","Bells palsy and COVID-19 vaccine","COVID-19 vaccine safety","GBS and COVID-19 vaccine","Myocarditis and COVID-19 vaccine","vaccine adverse reaction","Viral Vaccines/administration & dosage/immunology","Vaccination","Vaccination/*adverse effects","vaccination programmes","mass vaccination","COVID-19 vaccination","BNT162b2 messenger RNA (mRNA) COVID-19 vaccination","post-vaccination","COVID-19 mRNA vaccination","*vaccination","Vaccination/methods/*statistics & numerical data/trends","BNT162 Vaccine","BNT162 Vaccine/*adverse effects","BNT162b2","*BNT162 vaccine","VAERS"]
    #create a vax_dict to populate all vax study PMIDs
    vax_dict = Dict()
    #create vax_array to include vax study PMIDs (adds PMIDs as many times as term occurs in study; count can be extracted from dictionary)
    vax_array = []

    #line_count helps skip header with field labels
    line_count = 1

    #for loop to read lines in COVID-19 and myocarditis dataset
    for line in readlines(input_file)

        #skip header
        if line_count == 1
            line_count = 2
            continue
        end
        
        #splits each line using delimiter "|", saves as metadata fields
        field = split(line, "|")
        pmid = field[1]
        mh = field[9]
        ot = field[10]
        #default to "N/A" for mesh and other_term to indicate whether available or not
        mesh = "N/A"
        other_term = "N/A"

        # println("1 $mh\n")
        # println("2 $ot\n")

    #conditional statement blocks check if MH or OT are available. If yes, vax_terms array
    #is looped through to find first occurrence of terms in mh and or ot. PMID is then
    #pushed to vax_array if found. 
    if mh != "N/A"
        for n in vax_terms
            #println("$n")
            find = findfirst(n, mh)

            if find != nothing
                #println("$n found; map to PMID $pmid")
                push!(vax_array, pmid)
                #println("added")
            end
        end
     end

     if ot != "N/A"
        for n in vax_terms
            #println("$n")
            find = findfirst(n, ot)

            if find != nothing
                #println("$n found; map to PMID $pmid")
                push!(vax_array, pmid)
                #println("added")
            end
        end
     end
    end 

    #loop through PMIDs in vax_array and add to vax_dict 
    for n in vax_array
        if !haskey(vax_dict,n)
            vax_dict[n] = 1
        else
            vax_dict[n] += 1
        end
    end

    #print all unique instances of PMIDs for vax studies to output file
    for id in keys(vax_dict)
        println("$id")
        print(output_file1, "$id,\n")
    end

    #remaining studies not found in vax_dict are prevax studies; call populate_prevax
    #function to populate prevax studies in prevax_dict
    populate_prevax("covid_myocarditis_dataframe.txt", "prevax.txt", vax_array)


end

#populates prevax studies using vax_array PMIDs
function populate_prevax(input_file, output_file, array)

    #open files
    input_file = open(input_file, "r")
    output_file2 = open(output_file, "w")
    #create prevax_dict and prevax_array for PMID collection
    prevax_dict = Dict()
    prevax_array = []
    #creates one string value of array parameter to be utilized by findfirst()
    vax_string = join(array, "|")

    #skip header
    line_count = 1

        for line in readlines(input_file)
            if line_count == 1
                line_count = 2
                continue
            end
            
            field = split(line, "|")
            pmid = field[1]
            #conditonal block looks through vax_string for PMIDs; if present, vax study.
            #else, prevax study. Add to prevax_array.
           find = findfirst(pmid, vax_string)
            if find != nothing
                println("already got it")
            else 
                push!(prevax_array, pmid)
                println("$pmid is prevax")
            end
        
         end
    
        #  println("$prevax_array")
         #add PMIDs to prevax_dict
         for n in prevax_array
            if !haskey(prevax_dict,n)
                prevax_dict[n] = 1
            else
                prevax_dict[n] += 1
            end
        end
    
        #print PMIDs from prevax_dct to output file 
        for id in keys(prevax_dict)
            println("$id")
            print(output_file2, "$id,\n")
        end
    
    end
#call function
vax_status_reattempt("covid_myocarditis_dataframe.txt", "vax.txt")





