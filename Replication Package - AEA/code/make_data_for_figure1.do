cd "$immcrime/data/"

**** Get concerns from European Value Survey 2017 (EVS 5th Wave). The data available here, with permission: https://search.gesis.org/research_data/ZA7500)  ***
use "raw/ZA7500_v5-0-0.dta" 
gen immigrnegativedevt=(v184>=1&v184<=2)
gen crimeconcerns=(v186>=1&v186<=4)
gen unemplconcerns=(v185>=1&v185<=4)
gen concernedmigr=(v219>=1&v219<=3)
collapse *concerns immigrnegativedevt concernedmigr, by(country c_abrv)
decode country, g(country_name)
drop country
rename c_abrv country_label
gen survey="EVS"
save immigrconcerns, replace

**** Get concerns from World Value Survey 2017-2020 (WVS Wave 7). The data available here, with permission: https://www.worldvaluessurvey.org/WVSDocumentationWV7.jsp ***
use "raw/WVS_Cross-National_Wave_7_Stata_v5_0.dta"
gen crimeconcerns=(Q124==2&Q124!=.)
gen unemplconcerns=(Q128==2&Q128!=.)
gen immigrnegativedevt=(Q121>=1&Q121<=2)
gen restrpolicy=(Q130>=3&Q130<=4)
collapse *concerns restrpolicy immigrnegativedevt, by(B_COUNTRY B_COUNTRY_ALPHA)
decode B_COUNTRY, g(country_name)
drop B_COUNTRY
rename B_COUNTRY_ALPHA country_label
append using immigrconcerns
replace survey="WVS" if survey==""
order country_name country_label
save immigrconcerns, replace

*** Add three-letters code to EVS countries ***
clear
import excel "raw/countrycodes.xls", sheet("Code Country") firstrow
rename Country country_name
drop if country_name=="Unknown"
save "${input_path}countrycodes.dta", replace //source : OECD 
use "${input_path}immigrconcerns.dta"
merge m:1 country_name using "${input_path}countrycodes.dta"
drop if _merge==2
gen country_code = country_label if ustrlen(country_label)==3
replace country_code = CODE if ustrlen(country_label)!=3 & ustrlen(CODE)==3
replace country_code = substr(CODE,6,.) if ustrlen(country_label)!=3 & ustrlen(CODE)==8
bys country_name (country_code): replace country_code=country_code[_n+1] if country_code==""
replace country_code ="SVK" if country_name=="Slovakia" & country_code==""
replace country_code ="MKD" if country_name=="North Macedonia" & country_code==""
replace country_code ="MNE" if country_name=="Montenegro" & country_code==""
replace country_code ="GBR" if country_name=="Great Britain" & country_code==""
replace country_code ="CZE" if country_name=="Czechia" & country_code==""
replace country_code ="BIH" if country_name=="Bosnia and Herzegovina" & country_code==""
replace country_code ="AZE" if country_name=="Azerbaijan" & country_code==""
keep country_name country_code unemplconcerns crimeconcerns immigrnegativedevt survey  concernedmigr restrpolicy

*** Add GDP PC and stock of immigrants over pop (from https://databank.worldbank.org/source/world-development-indicators#) ***
preserve
clear
import excel "raw/Data_Extract_From_World_Development_Indicators.xlsx", sheet("Data") firstrow
global years YR2015 YR2016 YR2017 YR2018 YR2019
foreach x in $years {
split `x', parse(.)
replace `x'=`x'1+"."+substr(`x'2,1,3)
destring `x', force replace
}
keep $years CountryName CountryCode SeriesName
rename CountryName country_name 
rename CountryCode country_code
expand 2 
generate survey=""
bys country_name country_code SeriesName: replace survey="WVS" if _n==1
bys country_name country_code SeriesName: replace survey="EVS" if _n==2
save "raw/GDP_and_MIGstock", replace
restore
duplicates report country_name
merge 1:m country_code  survey using "raw/GDP_and_MIGstock"
keep if _merge==3 // we lose taiwan from the WVS
gen GDP2019=YR2019 if SeriesName=="GDP per capita, PPP (constant 2017 international $)"
replace GDP2019=YR2017 if SeriesName=="GDP per capita, PPP (constant 2017 international $)" & country_name=="Iran"
label var GDP2019 "GDP per capita, PPP (constant 2017 international $)"
gen immstock2015=YR2015 if SeriesName=="International migrant stock (% of population)"
label variable immstock2015 "International migrant stock (% of population)"
keep if GDP2019!=. | immstock2015!=.
bys country_name survey (GDP2019): replace immstock2015=immstock2015[_n+1]
bys country_name survey (GDP2019): gen N=_n
keep if N==1
keep immstock2015 GDP2019 country_name crimeconcerns unemplconcerns immigrnegativedevt survey country_code  concernedmigr restrpolicy
*** add a dummy for being a OECD member ***
global OECD_members " United States" "Mexico"	"Turkey" "Iceland" "Estonia" "Luxembourg" "Germany" "United Kingdom"  "France" "Italy" "South Korea" "Spain" "Poland" "Canada" "Australia" "Chile" "Latvia" "Netherlands" "Belgium" "Czech Republic" "Greece" "Portugal" "Sweden" "Hungary" "Austria" "Israel" "Switzerland" "Slovenia" "Denmark" "Finland" "Slovakia" "Norway" "Ireland" "New Zealand" "Lithuania"
preserve 
clear
import delimited "raw/list_OECD.csv" // source https://worldpopulationreview.com/country-rankings/oecd-countries
rename country country_name
replace country_name ="Czechia" if country_name=="Czech Republic"
replace country_name ="Great Britain" if country_name=="United Kingdom"
save "${input_path}OECD_members.dta", replace
restore
merge m:1 country_name using "raw/OECD_members.dta"
drop if _merge==2
gen OECD=0
replace OECD=1 if _merge==3
keep country_name crimeconcerns unemplconcerns immigrnegativedevt survey country_code GDP2019 immstock2015 OECD restrpolicy concernedmigr
drop if survey == "WVS" & (country_n ==  "Czechia" | country_n ==  "Germany" | country_n ==  "Great Britain" | country_n ==  "Netherlands" | country_n ==  "Slovakia" ) // only keep answers from EVS for 5 OECD countries which are both in EVS and WVS 
save "concerns_crime_unemp_immstock", replace
