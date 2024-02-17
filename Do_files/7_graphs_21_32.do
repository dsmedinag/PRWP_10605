********************************************************************************************************
* PRWP 10605: How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery? *
* Figures 21-32 
* By Daniel Medina, Maria Davalos, Diana Londoño

use "$data/geih_ajust_model_outputs.dta", clear

*Probit model to participation probability

foreach i of numlist 2015 2017 2019/2021 {
global seleccion "i.estado_civil i.rural i.lavadora i.acueducto i.energia_cocina edad esc log_ing_pc t_niños_0_3 t_niños_3_6 t_niños_6_12 area2-area24"
quietly probit pea $seleccion if sexo==1 & año==`i'  [iw=fex_c_2011_an], robust
dis as red _N

* Conditional marginal effects
quietly margins, at(t_niños_0_3=(0(2)8)) atmeans saving("$probit/margin1_`i'_f",replace)
dis as red 1
quietly margins, at(t_niños_3_6=(0(2)8)) atmeans saving("$probit/margin2_`i'_f",replace)
dis as red 2
quietly margins, at( log_ing_pc=(11.99 12.77 13.12 13.8 14.5 14.9)) atmeans saving("$probit/margin3_`i'_f",replace)
dis as red 3
quietly margins, at(esc=(0(5)25)) atmeans saving("$probit/margin4_`i'_f",replace)
dis as red 4
quietly margins, at(edad=(20(10)60)) atmeans saving("$probit/margin5_`i'_f",replace)
dis as red 5
quietly margins rural estado_civil, atmeans saving("$probit/margin6_`i'_f",replace)
dis as red 6

* Average marginal effects
quietly margins, at(t_niños_0_3=(0(2)8)) saving("$probit/Amargin1_`i'_f",replace)
dis as red 1
quietly margins, at(t_niños_3_6=(0(2)8)) saving("$probit/Amargin2_`i'_f",replace)
dis as red 2
quietly margins, at( log_ing_pc=(11.99 12.77 13.12 13.8 14.5 14.9)) saving("$probit/Amargin3_`i'_f",replace)
dis as red 3
quietly margins, at(esc=(0(5)25)) saving("$probit/Amargin4_`i'_f",replace)
dis as red 4
quietly margins, at(edad=(20(10)60)) saving("$probit/Amargin5_`i'_f",replace)
dis as red 5
quietly margins rural estado_civil, saving("$probit/Amargin6_`i'_f",replace)
dis as red 6

dis as red "`i'"
}

foreach i of numlist 2015 2017 2019/2021 {
global seleccion "i.estado_civil i.rural i.lavadora i.acueducto i.energia_cocina edad esc log_ing_pc t_niños_0_3 t_niños_3_6 t_niños_6_12 area2-area24"
quietly probit pea $seleccion if sexo==0 & año==`i' [iw=fex_c_2011_an], robust
dis as red _N

* Conditional marginal effects
quietly margins, at(t_niños_0_3=(0(2)8)) atmeans saving("$probit/margin1_`i'_m",replace)
dis as red 1
quietly margins, at(t_niños_3_6=(0(2)8)) atmeans saving("$probit/margin2_`i'_m",replace)
dis as red 2
quietly margins, at( log_ing_pc=(11.99 12.77 13.12 13.8 14.5 14.9)) atmeans saving("$probit/margin3_`i'_m",replace)
dis as red 3
quietly margins, at(esc=(0(5)25)) atmeans saving("$probit/margin4_`i'_m",replace)
dis as red 4
quietly margins, at(edad=(20(10)60)) atmeans saving("$probit/margin5_`i'_m",replace)
dis as red 5
quietly margins rural estado_civil, atmeans saving("$probit/margin6_`i'_m",replace)
dis as red 6


* Average marginal effects
quietly margins, at(t_niños_0_3=(0(2)8)) saving("$probit/Amargin1_`i'_m",replace)
dis as red 1
quietly margins, at(t_niños_3_6=(0(2)8)) saving("$probit/Amargin2_`i'_m",replace)
dis as red 2
quietly margins, at( log_ing_pc=(11.99 12.77 13.12 13.8 14.5 14.9)) saving("$probit/Amargin3_`i'_m",replace)
dis as red 3
quietly margins, at(esc=(0(5)25)) saving("$probit/Amargin4_`i'_m",replace)
dis as red 4
quietly margins, at(edad=(20(10)60)) saving("$probit/Amargin5_`i'_m",replace)
dis as red 5
quietly margins rural estado_civil, saving("$probit/Amargin6_`i'_m",replace)
dis as red 6

dis as red "`i'"
}

* Figures
* Figure 21

* Go to especific output
global m=1

use $probit/margin${m}_2015_f,clear

gen año=2015
gen sexo=1
foreach i of numlist 2017 2019/2021 {

append using $probit/margin${m}_`i'_f
replace sexo=1 if sexo==.

append using $probit/margin${m}_`i'_m
replace sexo=0 if sexo==.

replace año=`i' if año==.
}

keep _margin _se _statistic _pvalue _ci_lb _ci_ub _at año sexo

duplicates drop 
reshape wide _margin _se _statistic _pvalue _ci_lb _ci_ub , i(_at año) j(sexo)

drop if año==2015

local j=1
gen xvar=.
forval i=0(2)8 {
replace xvar=`i' if _at==`j'
local j=1+`j'
}

twoway 	(scatter _margin0 xvar if año==2019, mcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin0 xvar if año==2021, mcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021, lcolor("0 34 68")) ///
		(scatter _margin1 xvar if año==2019, mcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin1 xvar if año==2021, mcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021, lcolor("0 34 68")), ///		
ylabel(,format(%9.1f)) xtitle("Children in the household 0-3 years") ytitle("Pr(labour force=1)") ///
legend(on order(1 "Men 2019" 3 "Men  2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure21.emf",  replace

* Figure 22

global m=1
use $probit/Amargin${m}_2015_f,clear

gen año=2015
gen sexo=1
foreach i of numlist 2017 2019/2021 {

append using $probit/Amargin${m}_`i'_f
replace sexo=1 if sexo==.

append using $probit/Amargin${m}_`i'_m
replace sexo=0 if sexo==.

replace año=`i' if año==.
}

keep _margin _se _statistic _pvalue _ci_lb _ci_ub _at año sexo

duplicates drop 
reshape wide _margin _se _statistic _pvalue _ci_lb _ci_ub , i(_at año) j(sexo)

drop if año==2015

local j=1
gen xvar=.
forval i=0(2)8 {
replace xvar=`i' if _at==`j'
local j=1+`j'
}

twoway 	(scatter _margin0 xvar if año==2019, mcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin0 xvar if año==2021, mcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021, lcolor("0 34 68")) ///
		(scatter _margin1 xvar if año==2019, mcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin1 xvar if año==2021, mcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021, lcolor("0 34 68")), ///		
ylabel(,format(%9.1f)) xtitle("Children in the household 0-3 years") ytitle("Pr(labour force=1)") ///
legend(on order(1 "Men 2019" 3 "Men  2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure22.emf",  replace

* Figure 23
global m=2
use $probit/margin${m}_2015_f,clear

gen año=2015
gen sexo=1
foreach i of numlist 2017 2019/2021 {

append using $probit/margin${m}_`i'_f
replace sexo=1 if sexo==.

append using $probit/margin${m}_`i'_m
replace sexo=0 if sexo==.

replace año=`i' if año==.
}

keep _margin _se _statistic _pvalue _ci_lb _ci_ub _at año sexo

duplicates drop 
reshape wide _margin _se _statistic _pvalue _ci_lb _ci_ub , i(_at año) j(sexo)

drop if año==2015

local j=1
gen xvar=.
forval i=0(2)8 {
replace xvar=`i' if _at==`j'
local j=1+`j'
}

twoway 	(scatter _margin0 xvar if año==2019, mcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin0 xvar if año==2021, mcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021, lcolor("0 34 68")) ///
		(scatter _margin1 xvar if año==2019, mcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin1 xvar if año==2021, mcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021, lcolor("0 34 68")), ///		
ylabel(,format(%9.1f)) xtitle("Children in the household +3-6 years") ytitle("Pr(labour force=1)") ///
legend(on order(1 "Men 2019" 3 "Men  2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure23.emf",  replace

* Figure 24

global m=2
use $probit/Amargin${m}_2015_f,clear

gen año=2015
gen sexo=1
foreach i of numlist 2017 2019/2021 {

append using  $probit/Amargin${m}_`i'_f
replace sexo=1 if sexo==.

append using  $probit/Amargin${m}_`i'_m
replace sexo=0 if sexo==.

replace año=`i' if año==.
}

keep _margin _se _statistic _pvalue _ci_lb _ci_ub _at año sexo

duplicates drop 
reshape wide _margin _se _statistic _pvalue _ci_lb _ci_ub , i(_at año) j(sexo)

drop if año==2015

local j=1
gen xvar=.
forval i=0(2)8 {
replace xvar=`i' if _at==`j'
local j=1+`j'
}

twoway 	(scatter _margin0 xvar if año==2019, mcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin0 xvar if año==2021, mcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021, lcolor("0 34 68")) ///
		(scatter _margin1 xvar if año==2019, mcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin1 xvar if año==2021, mcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021, lcolor("0 34 68")), ///		
ylabel(,format(%9.1f)) xtitle("Children in the household +3-6 years") ytitle("Pr(labour force=1)") ///
legend(on order(1 "Men 2019" 3 "Men  2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure24.emf",  replace

* Figure 25

global m=3
use $probit/margin${m}_2015_f,clear

gen año=2015
gen sexo=1
foreach i of numlist 2017 2019/2021 {

append using $probit/margin${m}_`i'_f
replace sexo=1 if sexo==.

append using $probit/margin${m}_`i'_m
replace sexo=0 if sexo==.

replace año=`i' if año==.
}

keep _margin _se _statistic _pvalue _ci_lb _ci_ub _at año sexo

duplicates drop 
reshape wide _margin _se _statistic _pvalue _ci_lb _ci_ub , i(_at año) j(sexo)

drop if año==2015

local j=1
gen xvar=.
foreach i of numlist 11.99 12.77 13.12 13.8 14.5 14.9 {
replace xvar=`i' if _at==`j'
local j=1+`j'
}

replace xvar=exp(xvar)/1000

format xvar %10.0f
twoway 	(scatter _margin0 xvar if año==2019, mcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin0 xvar if año==2021, mcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021, lcolor("0 34 68")) ///
		(scatter _margin1 xvar if año==2019, mcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin1 xvar if año==2021, mcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021, lcolor("0 34 68")), ///		
xscale(log) xlabel(160 350 500 1000 2000 3000) ylabel(,format(%9.1f)) ///
xtitle("Household per capita income (thousands COP)") ytitle("Pr(Labor force=1)") ///
legend(on order(1 "Men 2019" 3 "Men 2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure25.emf",  replace

*Figure 26

global m=3
use $probit/Amargin${m}_2015_f,clear

gen año=2015
gen sexo=1
foreach i of numlist 2017 2019/2021 {

append using $probit/Amargin${m}_`i'_f
replace sexo=1 if sexo==.

append using $probit/Amargin${m}_`i'_m
replace sexo=0 if sexo==.

replace año=`i' if año==.
}

keep _margin _se _statistic _pvalue _ci_lb _ci_ub _at año sexo

duplicates drop 
reshape wide _margin _se _statistic _pvalue _ci_lb _ci_ub , i(_at año) j(sexo)

drop if año==2015

local j=1
gen xvar=.
foreach i of numlist 11.99 12.77 13.12 13.8 14.5 14.9 {
replace xvar=`i' if _at==`j'
local j=1+`j'
}

replace xvar=exp(xvar)/1000

format xvar %10.0f
twoway 	(scatter _margin0 xvar if año==2019, mcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin0 xvar if año==2021, mcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021, lcolor("0 34 68")) ///
		(scatter _margin1 xvar if año==2019, mcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin1 xvar if año==2021, mcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021, lcolor("0 34 68")), ///		
xscale(log) xlabel(160 350 500 1000 2000 3000) ylabel(,format(%9.1f)) ///
xtitle("Household per capita income (thousands COP)") ytitle("Pr(Labor force=1)") ///
legend(on order(1 "Men 2019" 3 "Men 2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure26.emf",  replace

* Figure 27

global m=4
use $probit/margin${m}_2015_f,clear

gen año=2015
gen sexo=1
foreach i of numlist 2017 2019/2021 {

append using $probit/margin${m}_`i'_f
replace sexo=1 if sexo==.

append using $probit/margin${m}_`i'_m
replace sexo=0 if sexo==.

replace año=`i' if año==.
}

keep _margin _se _statistic _pvalue _ci_lb _ci_ub _at año sexo

duplicates drop 
reshape wide _margin _se _statistic _pvalue _ci_lb _ci_ub , i(_at año) j(sexo)

drop if año==2015

local j=1
gen xvar=.
forval i=0(5)25 {
replace xvar=`i' if _at==`j'
local j=1+`j'
}

twoway 	(scatter _margin0 xvar if año==2019, mcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin0 xvar if año==2021, mcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021, lcolor("0 34 68")) ///
		(scatter _margin1 xvar if año==2019, mcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin1 xvar if año==2021, mcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021, lcolor("0 34 68")), ///		
ylabel(,format(%9.1f)) xtitle("Years of schooling") ytitle("Pr(labour force=1)") ///
legend(on order(1 "Men 2019" 3 "Men  2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure27.emf",  replace

*Figure 28

global m=4
use $probit/Amargin${m}_2015_f,clear

gen año=2015
gen sexo=1
foreach i of numlist 2017 2019/2021 {

append using $probit/Amargin${m}_`i'_f
replace sexo=1 if sexo==.

append using $probit/Amargin${m}_`i'_m
replace sexo=0 if sexo==.

replace año=`i' if año==.
}

keep _margin _se _statistic _pvalue _ci_lb _ci_ub _at año sexo

duplicates drop 
reshape wide _margin _se _statistic _pvalue _ci_lb _ci_ub , i(_at año) j(sexo)

drop if año==2015

local j=1
gen xvar=.
forval i=0(5)25 {
replace xvar=`i' if _at==`j'
local j=1+`j'
}

twoway 	(scatter _margin0 xvar if año==2019, mcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin0 xvar if año==2021, mcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021, lcolor("0 34 68")) ///
		(scatter _margin1 xvar if año==2019, mcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin1 xvar if año==2021, mcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021, lcolor("0 34 68")), ///		
ylabel(,format(%9.1f)) xtitle("Years of schooling") ytitle("Pr(labour force=1)") ///
legend(on order(1 "Men 2019" 3 "Men  2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure28.emf",  replace

* Figure 29

global m=5
use $probit/margin${m}_2015_f,clear

gen año=2015
gen sexo=1
foreach i of numlist 2017 2019/2021 {

append using $probit/margin${m}_`i'_f
replace sexo=1 if sexo==.

append using $probit/margin${m}_`i'_m
replace sexo=0 if sexo==.

replace año=`i' if año==.
}

keep _margin _se _statistic _pvalue _ci_lb _ci_ub _at año sexo

duplicates drop 
reshape wide _margin _se _statistic _pvalue _ci_lb _ci_ub , i(_at año) j(sexo)

drop if año==2015

local j=1
gen xvar=.
forval i=20(10)60 {
replace xvar=`i' if _at==`j'
local j=1+`j'
}

twoway 	(scatter _margin0 xvar if año==2019, mcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin0 xvar if año==2021, mcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021, lcolor("0 34 68")) ///
		(scatter _margin1 xvar if año==2019, mcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin1 xvar if año==2021, mcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021, lcolor("0 34 68")), ///		
ylabel(,format(%9.1f)) xtitle("Age") ytitle("Pr(labour force=1)") ///
legend(on order(1 "Men 2019" 3 "Men  2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure29.emf",  replace

*Figure 30

global m=5
use $probit/Amargin${m}_2015_f,clear

gen año=2015
gen sexo=1
foreach i of numlist 2017 2019/2021 {

append using $probit/Amargin${m}_`i'_f
replace sexo=1 if sexo==.

append using $probit/Amargin${m}_`i'_m
replace sexo=0 if sexo==.

replace año=`i' if año==.
}

keep _margin _se _statistic _pvalue _ci_lb _ci_ub _at año sexo

duplicates drop 
reshape wide _margin _se _statistic _pvalue _ci_lb _ci_ub , i(_at año) j(sexo)

drop if año==2015

local j=1
gen xvar=.
forval i=20(10)60 {
replace xvar=`i' if _at==`j'
local j=1+`j'
}

twoway 	(scatter _margin0 xvar if año==2019, mcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin0 xvar if año==2021, mcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021, lcolor("0 34 68")) ///
		(scatter _margin1 xvar if año==2019, mcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019, lcolor("0 159 218")) ///
		(scatter _margin1 xvar if año==2021, mcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021, lcolor("0 34 68")), ///		
ylabel(,format(%9.1f)) xtitle("Age") ytitle("Pr(labour force=1)") ///
legend(on order(1 "Men 2019" 3 "Men  2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure30.emf",  replace

* Figure 31-32

global m=6
use $probit/Amargin${m}_2015_f,clear

gen año=2015
gen sexo=1
foreach i of numlist 2017 2019/2021 {

append using $probit/Amargin${m}_`i'_f
replace sexo=1 if sexo==.

append using $probit/Amargin${m}_`i'_m
replace sexo=0 if sexo==.

replace año=`i' if año==.
}

keep _margin _se _statistic _pvalue _ci_lb _ci_ub año sexo _term
duplicates drop 

egen at = seq(), f(0) t(1)

reshape wide _margin _se _statistic _pvalue _ci_lb _ci_ub , i(at año _term) j(sexo)

drop if año==2015

rename at xvar

global t=1
twoway 	(connect _margin0 xvar if año==2019 & _term==${t}, mcolor("0 159 218") lcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019  & _term==${t}, lcolor("0 159 218")) ///
		(connect _margin0 xvar if año==2021 & _term==${t}, mcolor("0 34 68")  lcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021  & _term==${t}, lcolor("0 34 68")) ///
		(connect _margin1 xvar if año==2019  & _term==${t}, mcolor("0 159 218") lcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019  & _term==${t}, lcolor("0 159 218")) ///
		(connect _margin1 xvar if año==2021 & _term==${t}, mcolor("0 34 68") lcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021  & _term==${t}, lcolor("0 34 68")), ///		
ylabel(,format(%9.1f)) xtitle("Housing zone") ytitle("Pr(Labor force=1)") xlabel(-0.5 " " 0 "Urban" 1 "Rural" 1.5 " ") ///
legend(on order(1 "Men 2019" 3 "Men  2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure31.emf",  replace

global t=2
twoway 	(connect _margin0 xvar if año==2019 & _term==${t}, mcolor("0 159 218") lcolor("0 159 218") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2019  & _term==${t}, lcolor("0 159 218")) ///
		(connect _margin0 xvar if año==2021 & _term==${t}, mcolor("0 34 68")  lcolor("0 34 68") msymbol(smtriangle_hollow)) ///
		(rcap _ci_lb0 _ci_ub0 xvar if año==2021  & _term==${t}, lcolor("0 34 68")) ///
		(connect _margin1 xvar if año==2019  & _term==${t}, mcolor("0 159 218") lcolor("0 159 218") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2019  & _term==${t}, lcolor("0 159 218")) ///
		(connect _margin1 xvar if año==2021 & _term==${t}, mcolor("0 34 68") lcolor("0 34 68") msymbol(smcircle)) ///
		(rcap _ci_lb1 _ci_ub1 xvar if año==2021  & _term==${t}, lcolor("0 34 68")), ///			
ylabel(,format(%9.1f)) xtitle("Marital status") ytitle("Pr(Labor force=1)") xlabel(-0.5 " " 0 "Single" 1 "In union" 1.5 " ") ///
legend(on order(1 "Men 2019" 3 "Men  2021" 5 "Women 2019" 7 "Women 2021") rows(1) span)
graph export "${graphs}\Figure32.emf",  replace


