cd "$immcrime/data"

use "raw/european_regions.dta" , clear
drop if code=="FRY5" // drop Mayotte
* Generate difference variables from raw data to be used in regression:
replace migr = migr/1000
label var migr "Actual % of immigrants"
gen pop2002_=population if year==2002
bys code: egen pop2002=mean(pop2002_)
drop pop2002_
* Change in homicide rate (take inverse hyperbolic sine transformation in order not to drop years with zeros)
xtset id year
gen asy_homic = asinh(homicide_rate)
gen dasy_homic = asy_homic-L.asy_homic
label var dasy_homic "Change in the homicide rate"
* Change in vehiclde theft rate (take inverse hyperbolic sine transformation in order not to drop years with zeros)
gen asy_theft = asinh(vehicle_theft_rate)
gen dasy_theft = asy_theft-L.asy_theft
label var dasy_theft "Change in the vehicle theft rate"
gen lnmigr=ln(migr)
gen dlnmigr=lnmigr-L.lnmigr
label var dlnmigr "Change in the % of migrants"
gen lnpop=ln(population)
gen dlnpop=lnpop-L.lnpop
label var dlnpop "Change in population size"
gen lnGDP3 = ln(GDP3)
gen dlngdp=lnGDP3-L.lnGDP3
label var dlnpop "Change in GDP per population"
*For SSIV: Add predicted share of migrants by European region in 2000, using data on immigrant stock by country of origin in all European regions available from  Alesina et al. (2021) available here https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/8COTFK *
cap drop _merge
merge 1:1 code year using "raw/SSIV_predflows_2000", force
drop if _m==2
gen stockfit= foreign*1000 if year == 2002
bys code (year): replace stockfit = stockfit[_n-1] + predicted_flow[_n-1] if stockfit==.
replace stockfit = (stockfit/population)*100
gen lnstockfit=ln(stockfit)
xtset id year
gen dlnstockfit=lnstockfit-L.lnstockfit
label var dlnstockfit "Logchange in predicted share of immigrants based on  real stock of $t0 + predicted inflow"
cap drop _merge
	
save "regiondata_complete.dta", replace