********************************************************************************************************
* PRWP 10605: How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery? *
* Table 3,4 & 5
* Figures 33 & 34
* By Daniel Medina, Maria Davalos, Diana Londoño

* Table 3 & 5
* Figure 33 & 34

use "$data/geih_ajust_model_outputs.dta", clear

*Heckman correction: Oaxaca - Blinder

* Monthly
global explicativas "edad estado_civil esc experiencia formalidad_afp rural ln_ht_sem"
global categoricas "normalize(area1-area24) normalize(act_eco1-act_eco12) normalize(rela_labor1-rela_labor3)"
global seleccion "edad estado_civil esc t_niños_0_3 t_niños_3_6 t_niños_6_12 rural area2-area24"

foreach i of numlist 2015 2017 2019/2021 {

quietly oaxaca log_wr_im ${explicativas} ${categoricas} [iw=fex_c_2011_an] if año==`i', by(sexo) ///
model1(heckman, select(pea = ${seleccion})) ///
model2(heckman, select(pea = ${seleccion}))  noisily robust relax

estimates store ts`i'
}

putexcel set "${dir_tables}/Table_results.xlsx", modify sheet(OB_heckman_monthly)
putexcel A1="Heckman correction: Oaxaca-Blinder decomposition of real monthly labor income, ages 18-59"
estimates table ts2015 ts2017 ts2019 ts2020 ts2021, eform b(%11.3f) star(0.1 0.05 0.01) stats(N r2_a) varlabel
putexcel (A2) = etable

* Hourly
global explicativas "edad estado_civil esc experiencia formalidad_afp rural tiempo_parcial"

foreach i of numlist 2015 2017 2019/2021 {

quietly oaxaca log_wr_im_h ${explicativas} ${categoricas} [iw=fex_c_2011_an] if año==`i', by(sexo) ///
model1(heckman, select(pea = ${seleccion})) ///
model2(heckman, select(pea = ${seleccion}))  noisily robust relax

estimates store ths`i'
}

putexcel set "${dir_tables}/Table_results.xlsx", modify sheet(OB_heckman_hourly)
putexcel A1="Heckman correction: Oaxaca-Blinder decomposition of real labor income per hour, ages 18-59"
estimates table ths2015 ths2017 ths2019 ths2020 ths2021, eform b(%11.3f) star(0.1 0.05 0.01) stats(N r2_a) varlabel
putexcel (A2) = etable

* Table 4

* Ñopo (2008) decomposition 

use "$data/geih_ajust_model_outputs.dta", clear

* Monthly
global explicativas "estado_civil formalidad_afp rural tiempo_parcial t_niños_0_6"
global categoricas "exp_cat1-exp_cat6 g_etarios2-g_etarios3 area1-area24 act_eco1-act_eco12 grupo_educacional1-grupo_educacional7 rela_labor1-rela_labor3"

foreach i of numlist 2015 2017 2019/2021 {

preserve
nopomatch ${explicativas}  ${categoricas} if año==`i' & g_etarios>=1 & g_etarios<=3, outcome(ing_tot_impu_r) by(hombre) sd ///
replace fact(fex_c_2011_an) filename("${temp_files}/m_`i'")		
restore

}

* Hourly
foreach i of numlist 2015 2017 2019/2021 {

preserve
nopomatch ${explicativas}  ${categoricas} if año==`i' & g_etarios>=1 & g_etarios<=3, outcome(wr_im_h) by(hombre) sd ///
replace fact(fex_c_2011_an) filename("${temp_files}/h_`i'") 
restore
		
}

use "${temp_files}/h_2015",clear

gen reg="h"
gen año=2015
foreach i of numlist 2015 2017 2019/2021 {
append using "${temp_files}/h_`i'"
replace reg="h" if reg==""
replace año=`i'  if año==.

append using "${temp_files}/m_`i'"
replace reg="m" if reg==""
replace año=`i'  if año==.

}

drop in 1
export excel using "${dir_tables}/Table_4.xlsx", sheet("nopo_monthly_hourly") firstrow(variables) replace

