#load packages
using DataFrames
using CSV

#create function to extract MeSH treatment terms for COVID-19 induced myocarditis 
function vax_extract_treatments(input_file1, input_file2, vax_output, prevax_output)

    #create file handles and open files
    input_file1 = open(input_file1, "r")
    input_file2 = open(input_file2, "r")
    output_file1 = open(vax_output, "w")
    output_file2 = open(prevax_output, "w")
    print(output_file1, "TERM|N\n")
    print(output_file2, "TERM|N\n")

    #create array of MeSH treatment terms
    treatment_terms = ["Adrenergic beta-1 Receptor Antagonists/administration & dosage",
    "Anti-Inflammatory Agents/administration & dosage",
    "Aspirin/*administration & dosage",
    "Prednisolone/*administration & dosage",
    "Bisoprolol/administration & dosage",
    "Bisoprolol/*administration & dosage",
    "Ibuprofen/administration & dosage",
    "Gadolinium/administration & dosage/metabolism",
    "Anti-Inflammatory Agents/administration & dosage",
    "Aspirin/administration & dosage/therapeutic use",
    "Diuretics/administration & dosage/therapeutic use",
    "Magnesium/administration & dosage",
    "permanent pacemaker implantation (ppm)",
    "Biopsy",
    "Endomyocardial biopsy",
    "*Endomyocardial biopsy",
    "*Heart Transplantation/adverse effects",
    "Cardiac magnetic resonance imaging (CMR)",
    "*Cardiac MRI",
    "*ECG",
    "Cardiac Imaging Techniques/methods",
    "Cardiac magnetic resonance imaging",
    "*cardiac magnetic resonance",
    "*Cardiac MRI",
    "cardiac magnetic resonance",
    "cardiac magnetic resonance imaging (CMR)",
    "Cardiac magnetic resonance",
    "cardiac MRI",
    "*CMR",
    "*MRI",
    "Echocardiography",
    "Electrocardiography",
    "Echocardiography/*methods",
    "Heart/*diagnostic imaging",
    "Electrocardiography/methods",
    "steroid pulse therapy",
    "Myocarditis/diagnostic imaging/drug therapy/*etiology",
    "immunomodulatory therapy",
    "Intravenous immunoglobulins",
    "Drug Therapy",
    "CMR",
    "MRI",
    "biopsy",
    "*biopsy",
    "*endomyocardial biopsy",
    "EMB, endomyocardial biopsy",
    "endomyocardial biopsy",
    "Biopsy/methods",
    "Azithromycin/administration & dosage/adverse effects/therapeutic use",
    "Hydroxychloroquine/administration & dosage/adverse effects/therapeutic use",
    "Cardiotonic Agents/administration & dosage",
    "Electrocardiography/methods",
    "Immunoglobulins, Intravenous/administration & dosage",
    "Radiography, Thoracic/methods",
    "Gadolinium",
    "Anti-Infective Agents/administration & dosage/adverse effects",
    "*Azithromycin/administration & dosage/adverse effects",
    "*Hydroxychloroquine/administration & dosage/adverse effects"]

    #create dictionaries for prevax and vax studies
    prevax_dict = Dict()
    vax_dict = Dict()

    line_count = 1

    for line in readlines(input_file1)

        if line_count == 1
            line_count = 2
            continue
        end
        
        field = split(line, "|")
        pmid = field[1]
        mh = field[9]
        ot = field[10]
        mesh = "N/A"
        other_term = "N/A"

        #if mesh and or other term data are available, loop through treatment_terms array
        #and find occurrences of terms. Add to dictionary and keep track of counts for
        #each study set.

    if mh != "N/A"
        for n in treatment_terms
            
            find = findfirst(n, mh)

            if find != nothing
                if !haskey(vax_dict, n)
                    vax_dict[n] = 1
                else
                    vax_dict[n] += 1
                end
            end
        end
     end

     if ot != "N/A"
        for n in treatment_terms
          
            find = findfirst(n, ot)

            if find != nothing
                if !haskey(vax_dict, n)
                    vax_dict[n] = 1
                else
                    vax_dict[n] += 1
                end
            end
        end
     end
    end 

    lc = 1

    for line in readlines(input_file2)

        if lc == 1
            lc = 2
            continue
        end
        
        field = split(line, "|")
        pmid = field[1]
        mh = field[9]
        ot = field[10]
        mesh = "N/A"
        other_term = "N/A"

    if mh != "N/A"
        for n in treatment_terms
            
            find = findfirst(n, mh)

            if find != nothing
                if !haskey(prevax_dict, n)
                    prevax_dict[n] = 1
                else
                    prevax_dict[n] += 1
                end
            end

        end
     end

     if ot != "N/A"
        for n in treatment_terms
          
            find = findfirst(n, ot)

            if find != nothing
                if !haskey(prevax_dict, n)
                    prevax_dict[n] = 1
                else
                    prevax_dict[n] += 1
                end
            end

        end
     end
    end 

    #print treatment terms and counts for each study subset to output files
    for terms in keys(vax_dict)
        
        print(output_file1, "$terms|$(vax_dict[terms])\n")

    end

    for terms in keys(prevax_dict)
        
        print(output_file2, "$terms|$(prevax_dict[terms])\n")

    end


end

#create dataframes for treatment terms data
function dataframe_search(input_file, output_file)
    df = CSV.File(input_file, header=1, footerskip=0, delim="|") |> DataFrame
    
    count_df = combine(groupby(df, :TERM), :N => :N)
	 
	 sort!(count_df, (:N), rev=(true))
	 
     println(count_df)
  
     CSV.write(output_file, count_df)
     
end

#call functions
vax_extract_treatments("vax_data.txt", "prevax_data.txt", "vax_treatments.txt", "prevax_treatments.txt")
dataframe_search("vax_treatments.txt", "vax_treatments_df.txt")
dataframe_search("prevax_treatments.txt", "prevax_treatments_df.txt")




