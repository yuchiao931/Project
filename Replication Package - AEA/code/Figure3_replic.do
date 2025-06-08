cd "$immcrime/data"

**************
** Figure 3 **
**************
*overrepresentation of migrants in prison population

use prison_pop, clear
set scheme s1mono
twoway (scatter shareinprison immigrantspop, msymbol(none) mlabel(country_code) mlabcolor(black) xtitle("% of foreigners in total population") ytitle("% of foreigners in prison population") ylabel(0(10)70) xlabel(0(10)70)) (function y=x, range(0 70)), legend(off) 
graph save "$results/Figure3", replace
