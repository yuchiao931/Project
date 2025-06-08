cd "$immcrime/data"

**************
** Figure 1 **
**************
*plots % concerned about unemployment vs % concernd abt crime as a conseq of immigr
* use concerns_crime_unemp_immstock, clear // NB: see code for data construction for this figure which indicates where it can be obtained.
twoway (scatter crimeconcerns unemplconcerns [aw= immstock2015], mcolor(gs10) msymbol(circle_hollow) ) (scatter crimeconcerns unemplconcerns, mlabpos(0) mcolor(black) mlabcolor(black) msymbol(none) mlabel(country_code) ) (line unemplconcerns unemplconcerns, lcolor(black)) if OECD, xsize(5) ysize(5) legend(off) xtitle(% concerned about unemployment) ytitle(% concerned about crime)
graph save  "$results/Figure1", replace
