cd "$immcrime/data"

**************
** Figure 2***
**************
*prison vs education gap

use cross_country_data_homicide_migration.dta, clear

**** Top panel: migration and homicides, over time *****
preserve
collapse homic migr [aw=pop1990], by(year)
twoway (connected migr year, color(gs8) msymbol(circle_hollow)) (connected homicide_rate year, color(blue) msymbol(triangle_hollow) yaxis(2)), xtitle("") ///
ytitle("Homicide rate per 100,000 inhabitants", axis(2)) ytitle("Stock of migrants over population")  legend(order(1 "Stock of migrants over population" 2 "Homicide rate") pos(6) col(2)) xlabel(1990(5)2020)
graph save "$results/Figure2_top", replace
restore

********** scatterplots ********
preserve
keep if year==1990|year==2019
gen lnmigr = ln(migr_pop)
gen lnhomic = ln(homicide_rate)
keep country code lnhomic lnmigr year pop1990
reshape wide lnhomic lnmigr, i(country code) j(year)
gen dlnmigr90=lnmigr2019-lnmigr1990
gen dlnhomic=lnhomic2019-lnhomic1990
twoway (scatter dlnhomic dlnmigr90 [aw=pop1990], msymbol(circle_hollow) mcolor(black)) (scatter dlnhomic dlnmigr90, mlabel(code) mlabcolor(black) msymbol(none)) ///
(lfit dlnhomic dlnmigr90 [aw=pop1990], lcolor(blue)), title("Immigration and homicides (pop. weighted)") xtitle("log change migration, 1990-2019") ytitle("log change homicides, 1990-2019") legend(off)
graph save "$results/figure2_bottom", replace
restore 