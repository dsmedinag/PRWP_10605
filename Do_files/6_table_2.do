********************************************************************************************************
* PRWP 10605: How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery? *
* Table 2 
* By Daniel Medina, Maria Davalos, Diana Londoño

* Table 2

use "${data}/GEIH_2015_2021_est.dta", clear

keep if g_etarios>=1 & g_etarios<=3  & area!=99
label def g_etarios_ing 1 "18-24 years old" 2 "+25-44 years old" 3 "+45-59 years old"
label val g_etarios g_etarios_ing

drop experiencia
gen experiencia=edad-esc-11 if grupo_educacional==0 & edad-esc>5
replace experiencia=edad-esc-7 if grupo_educacional==1 & edad-esc>5
replace experiencia=edad-esc-5 if grupo_educacional==2 & edad-esc>5
replace experiencia=edad-17 if grupo_educacional==3 & edad-esc>5
replace experiencia=edad-20 if grupo_educacional==4 & edad-esc>5
replace experiencia=0 if experiencia<0 & grupo_educacional<=4 & edad-esc>5
replace experiencia=edad-22 if (grupo_educacional==5 | grupo_educacional==6) & edad-esc>5
replace experiencia=0 if experiencia<0 & (grupo_educacional==5 | grupo_educacional==6) & edad-esc>5

gen 	exp_cat=0 if experiencia==0
replace exp_cat=1 if experiencia>0 & experiencia<=3
replace exp_cat=2 if experiencia>3 & experiencia<=6
replace exp_cat=3 if experiencia>=7 & experiencia<=10
replace exp_cat=4 if experiencia>10 & experiencia<=15
replace exp_cat=5 if experiencia>15 & experiencia!=.

label def exp_cat 0 "No experience" 1 "+0-3 years" 2 "+3-6 years" 3 "+7-10 years" 4 "+10-15 years" 5 "+15 years", replace
label values exp_cat exp_cat

replace sexo=0 if sexo==1
replace sexo=1 if sexo==2
label def sexo 0 "Men" 1 "Women", replace
label values sexo sexo

gen ing_tot_impu_r=ing_tot_impu1/ipc_mensual
gen log_wr_im=ln(ing_tot_impu_r)
label var log_wr "Real monthly labor income - imputed"

gen log_wr=ln(inglabo_r)
label var log_wr "Real monthly labor income"

gen ln_ht_sem=ln(total_horas_trabajadas_semana)
label var ln_ht_sem "Hours worked per week"

gen log_wr_im_h=ln(ing_tot_impu_r/total_horas_trabajadas)
label var log_wr_im_h "Real hourly labor income - imputed"

capture drop log_ing_pc_rest
gen log_ing_pc_rest=ln(((ingtotugarr-ing_tot_impu_r)/ipc_mensual)/(npersug-1))
replace log_ing_pc_rest=ln(((ingtotugarr)/ipc_mensual)/(npersug-1)) if ing_tot_impu_r==. | (ingtotugarr-ing_tot_impu_r)<0
label var log_ing_pc_rest "Per capita income of other household members"

gen log_ing_pc=ln(ingpcug/ipc_mensual)
label var log_ing_pc "Household per capita income"

recode estado_civil (2=0)
label def estado_civil 0 "Otherwise" 1 "Union or married", replace
label values estado_civil estado_civil

gen rela_labor=1 if p6430==1 | p6430==8 | p6430==3
replace rela_labor=2 if p6430==2 
replace rela_labor=3 if p6430==4 | p6430==5 | p6430==9
label def rela_labor 1 "Private employee" 2 "Government employee" 3 "Self-employed", replace
label values rela_labor rela_labor

gen formalidad_afp=1-Informalidad_AFP
label def formalidad_afp 0 "Otherwise" 1 "Formal", replace
lab values formalidad_afp formalidad_afp

replace rural=(urban==0)
label def rural 0 "Otherwise" 1 "Rural", replace
lab values rural rural

gen hombre=(sexo==0)
gen wr_im_h=ing_tot_impu_r/total_horas_trabajadas

label def tiempo_parcial_ing 0 "Otherwise" 1 "Part-time job (<40 hours per week)" , replace
label val tiempo_parcial tiempo_parcial_ing

label def niños_0_3_ing  0 "Otherwise" 1 "(%) children 0-3 years old in the household" , replace
label val niños_0_3 niños_0_3_ing

label def niños_3_6_ing  0 "Otherwise" 1 "(%) children +3-6 years old in the household" , replace
label val niños_3_6 niños_3_6_ing

label def niños_6_12_ing 0 "Otherwise" 1 "(%) children +6-12 years old in the household" , replace
label val niños_6_12 niños_6_12_ing

label def pobre_ing 0 "Otherwise" 1 "(%) poor" , replace
label val pobre pobre_ing

label def grupo_educacional_ing 0 "No education" 1 "Elementary" 2 "Secondary" 3 "High School" 4 "Technical and technological" 5 "University"  6 "Postgraduate", replace
label val grupo_educacional grupo_educacional_ing

label def work_status_ing 1 "Employed" 2 "Unemployed" 3 "Inactive", replace
label val work_status work_status_ing

label def act_eco_ing 0 "Agriculture" 1 "Electricity, gas, water and mining" ///
2 "Industry" 3 "Construction" 4 "Trade and vehicle repair" 5 "Transportation, storage and communications" ///
6 "Accommodation and food services"  7 "Financial and real estate activities" ///
8 "Professional and administrative activities" 9 "Public administration" ///
10 "Education and human health" 11 "Other activities", replace
label val act_eco act_eco_ing

replace area=11 if area==25
replace area=99 if area==.

capture drop area2 mes1 mes2

foreach x of varlist area grupo_educacional rela_labor exp_cat g_etarios work_status act_eco niños_0_3 niños_3_6 niños_6_12 rural estado_civil tiempo_parcial {
tab `x', gen(`x')
}

preserve 
keep if año==2015 | año>=2019

collapse (count) unos (mean) ing_tot_impu_r wr_im_h total_horas_trabajadas_semana edad experiencia esc t_niños_0_3 t_niños_3_6 t_niños_6_12 [iweight=fex_c_2011_an], by(año sexo)

rename total_horas_trabajadas_semana horas_trab_semana
local i=1
foreach x of varlist edad t_niños_0_3 t_niños_3_6 t_niños_6_12 esc experiencia ing_tot_impu_r wr_im_h horas_trab_semana {

rename `x' ind`i'`x'

local i=`i'+1
}

reshape long ind, i(año sexo) j(variable) string
reshape wide ind unos, i(variable año) j(sexo)

gen ind2=(ind0*unos0+ind1*unos1)/(unos0+unos1)

drop unos*
reshape wide ind0 ind1 ind2, i(variable) j(año)

order variable ind0* ind1* ind2*

replace variable="Age" if variable=="1edad"
replace variable="# children 0-3 years old at household" if variable=="2t_niños_0_3"
replace variable="# children +3-6 years old at household" if variable=="3t_niños_3_6"
replace variable="# children +6-12 years old at household" if variable=="4t_niños_6_12" 
replace variable="Years of education" if variable=="5esc"
replace variable="Years of experience" if variable=="6experiencia"
replace variable="Real monthly labor income - imputed" if variable=="7ing_tot_impu_r"
replace variable="Real hourly labor income - imputed" if variable=="8wr_im_h"
replace variable="Hours worked per week" if variable=="9horas_trab_semana"

format ind0* ind1* ind2* %10.1f 

save "${temp_files}/sum_variables_c", replace

restore

foreach x of varlist exp_cat grupo_educacional g_etarios work_status formalidad_afp act_eco rela_labor rural estado_civil tiempo_parcial niños_0_3 niños_3_6 niños_6_12 pobre {

preserve

keep if año==2015 | año>=2019
drop if `x'==.

collapse (count) unos [iweight=fex_c_2011_an], by(`x' año sexo)

rename unos ind
reshape wide ind, i(`x' año) j(sexo)

gen ind2=ind0+ind1

bys año: egen tot_0=sum(ind0)
bys año: egen tot_1=sum(ind1) 
bys año: egen tot_2=sum(ind2) 

replace ind0=100*ind0/tot_0
replace ind1=100*ind1/tot_1
replace ind2=100*ind2/tot_2

drop tot*
reshape wide ind0 ind1 ind2, i(`x') j(año)

order `x' ind0* ind1* ind2*

decode `x', gen(variable)
drop `x' 

save "${temp_files}/sum_`x'", replace
restore
}

preserve
keep if año==2015 | año>=2019

collapse (count) unos, by(año sexo)

rename unos ind
reshape wide ind, i(año) j(sexo)

gen ind2=ind0+ind1

gen variable="Observations (thousands)"
reshape wide ind0 ind1 ind2, i(variable) j(año)

order variable ind0* ind1* ind2*

save "${temp_files}/sum_N", replace
restore

clear
set obs 1
gen variable="	"
save "${temp_files}/sum_espacio", replace

clear
set obs 1
gen variable="Continuous"
append using "${temp_files}/sum_variables_c"

set obs 11
set obs 12
replace variable="Categoricals (%, total)" in 12


local vars "rural estado_civil pobre espacio g_etarios espacio niños_0_3 niños_3_6  niños_6_12 espacio grupo_educacional espacio exp_cat tiempo_parcial formalidad_afp espacio work_status espacio rela_labor espacio act_eco N"
foreach x of local vars {

append using "${temp_files}/sum_`x'"

}

drop if variable=="Otherwise"

export excel variable ind02015-ind12021 using "${dir_tables}/Table_2.xlsx", sheet("Descriptive stats") sheetmodify keepcellfmt cell(B4)
