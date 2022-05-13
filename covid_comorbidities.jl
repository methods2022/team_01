using DataFrames
using CSV


function analyze_covid_df(input, output)
    # create dataframe from input file
    df = CSV.File(input, header = 1, footerskip = 0, delim = "|") |> DataFrame

    # remove missing terms in MH and OT columns
    df = disallowmissing(df, Between(:MH, :OT); error = false)
    transform!(df, [:MH, :OT] => ByRow((x, y) -> string(x, ", ", y)) => :Terms)

    # create array > string of dataframe to remove unwanted characters
    terms = df[:, [:Terms]]
    test = Array(terms)
    list = join(test)
    list = replace(list, r"SubString.String." => "", "N/A" => "", "[" => "", "]" => ", ", "*" => "", '"' => "")
    list = uppercase(list)

    comorbidity = split(list, ", ")
    term = ""
    comorbidity_dict = Dict()


    # get counts of each comorbidity term
    for term in comorbidity
        if length(term) > 3
            if !haskey(comorbidity_dict, term)
                comorbidity_dict[term] = 1
            else
                comorbidity_dict[term] += 1
            end
        end
    end
    
    # create dataframe from dictionary
    term_df = DataFrame(Comorbidity = String[], Counts = Int[])
    for term in keys(comorbidity_dict)
        if comorbidity_dict[term] > 1
            if term == "ASTHMA" || term == "CANCER"|| term == "CEREBROVASCULAR DISEASE" || term == "CHRONIC KIDNEY DISEASE" || term == "COVID-19" || term == "INTERSTITIAL LUNG DISEASE" || term == "PULMONARY EMBOLISM" || term == "PULMONARY HYPERTENSION" || term == "BRONCHIECTASIS" || term == "COPD" || term == "CIRRHOSIS" || term == "NON-ALCOHOLIC FATTY LIVER DISEASE" || term == "ALCOHOLIC LIVER DISEASE" || term == "AUTOIMMUNE HEPATITIS" || term == "CYSTIC FIBROSIS" || term == "DIABETES MELLITUS" || term == "DISABILITIES" || term == "HEART CONDITIONS" || term == "MYOCARDITIS" || term == "HIV" || term == "MOOD DISORDERS" || term == "DEPRESSION" || term == "SCHIZOPHRENIA" || term == "DEMENTIA" || term == "OBESITY" || term == "PRIMARY IMMUNODEFICIENCIES" || term == "PREGNANCY" || term == "PHYSICAL INACTIVITY" || term == "SMOKING" || term == "TRANSPLANTATION" || term == "TUBERCULOSIS"
                push!(term_df, (term, comorbidity_dict[term]))
            end
        end
    end

    sort!(term_df, (:Counts), rev = true)
    print(term_df)
    CSV.write(output, term_df)
end

function analyze_myo_covid_df(input, output)

    df = CSV.File(input, header = 1, footerskip = 0, delim = "|") |> DataFrame
    df = disallowmissing(df, Between(:MH, :OT); error = false)
    transform!(df, [:MH, :OT] => ByRow((x, y) -> string(x, ", ", y)) => :Terms)

    terms = df[:, [:Terms]]
    test = Array(terms)
    list = join(test)
    list = replace(list, r"SubString.String." => "", "N/A" => "", "[" => "", "]" => ", ", "*" => "", '"' => "")
    list = uppercase(list)

    comorbidity = split(list, ", ")
    comorbid_dict = Dict()
    term = ""

    for term in comorbidity
        if length(term) > 3
            if !haskey(comorbid_dict, term)
                comorbid_dict[term] = 1
            else
                comorbid_dict[term] += 1
            end
        end
    end
    term_df = DataFrame(Comorbidity = String[], Counts = Int[])
    for term in keys(comorbid_dict)
        if comorbid_dict[term] > 1
            if term == "ASTHMA" || term == "CANCER"|| term == "CEREBROVASCULAR DISEASE" || term == "CHRONIC KIDNEY DISEASE" || term == "COVID-19" || term == "INTERSTITIAL LUNG DISEASE" || term == "PULMONARY EMBOLISM" || term == "PULMONARY HYPERTENSION" || term == "BRONCHIECTASIS" || term == "COPD" || term == "CIRRHOSIS" || term == "NON-ALCOHOLIC FATTY LIVER DISEASE" || term == "ALCOHOLIC LIVER DISEASE" || term == "AUTOIMMUNE HEPATITIS" || term == "CYSTIC FIBROSIS" || term == "DIABETES MELLITUS" || term == "DISABILITIES" || term == "HEART CONDITIONS" || term == "MYOCARDITIS" || term == "HIV" || term == "MOOD DISORDERS" || term == "DEPRESSION" || term == "SCHIZOPHRENIA" || term == "DEMENTIA" || term == "OBESITY" || term == "PRIMARY IMMUNODEFICIENCIES" || term == "PREGNANCY" || term == "PHYSICAL INACTIVITY" || term == "SMOKING" || term == "TRANSPLANTATION" || term == "TUBERCULOSIS"
                push!(term_df, (term, comorbid_dict[term]))
            end
        end
    end

    sort!(term_df, (:Counts), rev = true)
    print(term_df)
    CSV.write(output, term_df)
end

input_covid = open("./covid_dataframe.txt", "r")
output_covid = open("./covid_comorbidities_counts.txt", "w")

input_myo = open("./covid_myocarditis_dataframe.txt", "r")
output_myo = open("./covid_myo_comorbidities_counts.txt", "w")


analyze_covid_df(input_covid, output_covid)
analyze_myo_covid_df(input_myo, output_myo)

close(output_covid)
close(output_myo)