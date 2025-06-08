cd "$immcrime/data"

net install grc1leg, from (http://www.stata.com/users/vwiggins)

**************
** Figure 4 **
**************
*literature review on shiftshare results. Each estimates, with associated standard errors, were taken manually to create 'literature.dta' dataset from the following papers: BBP 2012: Bianchi, Buonanno & Pinotti (2012); BFM 2013: Bell, Fasani and Machin (2013); SPE 2014: Spenkuch (2014), ADU 2021: Ajzenman, Dominguez-Rivera and Undurraga (2023). 

use literature, clear

twoway rcap C_low C_high paperid if crimeid==1 & Ident=="OLS", horizontal  xline(0) lcolor($color) || scatter paperid Coef if crimeid==1 & Ident=="OLS", msymbol(o) mcolor($color)  mlabel(Coef) mlabcolor(black) mlabposition(12) || rcap C_low C_high paperid if crimeid==1 & Ident=="SSIV", horizontal  xline(0) lcolor($color) lpattern(dash) || scatter paperid Coef if crimeid==1 & Ident=="SSIV", mcolor($color) mlabel(Coef) mlabcolor(black) mlabposition(12) title("Property") graphregion(color(white)) msymbol(x) legend(off) ytitle("") ylabel( -1 `" "BBP, 2012""Italy""' -2 `""BFM, 2013""United Kingdom""' -3 `""SPE, 2014""United States""' -4 `""ADU, 2023""Chile""',  nogrid ) xlabel(, nogrid) nodraw  ytitle("") subtitle(" ") legend(cols(4))
graph copy property_labels, replace
twoway rcap C_low C_high paperid if crimeid==2 & Ident=="OLS", horizontal  xline(0) lcolor($color) || scatter paperid Coef if crimeid==2 & Ident=="OLS", msymbol(o) mcolor($color)  mlabel(Coef) mlabcolor(black) mlabposition(12) || rcap C_low C_high paperid if crimeid==2 & Ident=="SSIV", horizontal  xline(0) lcolor($color) lpattern(dash) || scatter paperid Coef if crimeid==2 & Ident=="SSIV",  mcolor($color) title("Violent ") graphregion(color(white)) msymbol(x) legend(off) ylabel(, nogrid) xlabel(, nogrid) nodraw  mlabel(Coef) mlabcolor(black)  mlabposition(12) yscale(off) subtitle(" ")
graph copy violent , replace
graph combine  property_labels violent, name(estimates)  graphregion(color(white) margin(zero))  xcommon 
grc1leg property_labels violent, name(estimates_)  graphregion(color(white))

graph save "$results/Figure4.gph", replace