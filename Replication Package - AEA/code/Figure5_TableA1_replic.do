cd "$immcrime/"

***************************
** Figure 5 and Table A1 **
***************************

use "data/regiondata_complete.dta", clear
rename region region_str
encode region_str, gen(region)
** Homicides **
*define IV sample
ivreghdfe dasy_hom (dlnmigr=dlnstockfit) dlnpop dlngdp [aw=pop2002], a(year country) cl(region)
cap drop sample
gen sample=e(sample)
* OLS no country FEs
reghdfe dasy_hom dlnmigr dlnpop dlngdp [aw=pop2002] if sample==1,  a(year ) cluster(region )
outreg2 using "results/Table_A1.xls",  nocons label ctitle("Homicides, OLS")  addtext(Year FEs, Yes, Country FEs, No) replace
binscatter dasy_hom dlnmigr [aw=pop2002] if sample==1, absorb(year) control(dlnpop dlngdp) n(100) mcolor(gs8) title("Homicides, OLS") xtitle("Log change in migration rate") ytitle("Log change in homicide rate")
graph copy hom_base, replace
* OLS with country FEs
reghdfe dasy_hom dlnmigr dlnpop dlngdp [aw=pop2002] if sample==1,  a(year country) cluster(region ) 
outreg2 using "results/Table_A1.xls",  nocons label ctitle("Homicides, OLS")  addtext(Year FEs, Yes, Country FEs, Yes) append
binscatter dasy_hom dlnmigr [aw=pop2002] if sample==1, absorb(year) control(dlnpop dlngdp i.country) n(100) mcolor(gs8) title("Homicides, OLS with country FEs") xtitle("Log change in migration rate") ytitle("Log change in homicide rate")
graph copy hom_fe, replace
* SSIV with country FEs
ivreghdfe dasy_hom (dlnmigr=dlnstockfit) dlnpop dlngdp [aw=pop2002], a(year country) cl(region)
outreg2 using "results/Table_A1.xls",  nocons label ctitle("Homicides, SSIV")  addtext(Year FEs, Yes, Country FEs, Yes) append addst(Fstat, e(rkf))
cap drop mig_fs_h
areg dlnmigr dlnstockfit i.country dlnpop dlngdp  [aw=pop2002] if sample == 1,  a(year) cluster(region ) 
predict mig_fs_h
binscatter dasy_hom mig_fs_h [aw=pop2002] if sample == 1, absorb(year) control(dlnpop dlngdp i.country) n(100) mcolor(gs8) title("Homicides, SSIV") xtitle("Predicted log change in migration rate") ytitle("Log change in homicide rate")
graph copy hom_iv, replace

** Vehicle Theft **
*define IV sample
drop sample
ivreghdfe dasy_theft (dlnmigr=dlnstockfit) dlnpop dlngdp [aw=pop2002], a(year country) cl(region) first
cap drop sample clear
gen sample=e(sample)
* keep if sample == 1
* OLS no country FEs
reghdfe dasy_theft dlnmigr dlnpop dlngdp [aw=pop2002] if sample==1,  a(year ) cluster(region ) 
outreg2 using "results/Table_A1.xls",  nocons label ctitle("Theft, OLS")  addtext(Year FEs, Yes, Country FEs, No) append
binscatter dasy_hom dlnmigr [aw=pop2002] if sample==1, absorb(year) control(dlnpop dlngdp) n(100) mcolor(gs8)  title("Vehicle theft, OLS") xtitle("Log change in migration rate") ytitle("Log change in homicide rate")
graph copy theft_base, replace
* OLS with country FEs
reghdfe dasy_theft dlnmigr dlnpop dlngdp [aw=pop2002] if sample==1,  a(year country) cluster(region ) 
outreg2 using "results/Table_A1.xls",  nocons label ctitle("Theft, OLS")  addtext(Year FEs, Yes, Country FEs, Yes) append
binscatter dasy_hom dlnmigr [aw=pop2002] if sample==1, absorb(year) control(dlnpop dlngdp i.country) n(100) mcolor(gs8)  title("Vehicle theft, OLS with country FEs") xtitle("Log change in migration rate") ytitle("Log change in homicide rate")
graph copy theft_fe, replace
* SSIV with country FEs
ivreghdfe dasy_theft (dlnmigr=dlnstockfit) dlnpop dlngdp [aw=pop2002], a(year country) cl(region) first
outreg2 using "results/Table_A1.xls",  nocons label ctitle("Theft, SSIV")  addtext(Year FEs, Yes, Country FEs, Yes) append addst(Fstat, e(rkf))
cap drop mig_fs_t
areg dlnmigr dlnstockfit i.country dlnpop dlngdp  [aw=pop2002] if sample==1,  a(year) cluster(region ) 
predict mig_fs_t
binscatter dasy_theft mig_fs_t [aw=pop2002] if sample == 1, absorb(year) control(dlnpop dlngdp i.country) n(100) mcolor(gs8)  title("Vehicle theft, SSIV") xtitle("Predicted log change in migration rate") ytitle("Log change in homicide rate")
graph copy theft_iv, replace

graph combine hom_base theft_base hom_fe theft_fe hom_iv theft_iv, xsize(8) ysize(6) scale(.8) col(2)
graph save "results/Figure5.gph", replace
