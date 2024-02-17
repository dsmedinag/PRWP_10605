********************************************************************************************************
* PRWP 10605: How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery? *
* Figures 21-32 
* By Daniel Medina, Maria Davalos, Diana Londoño

* Making variables and labeling
use "${data}/GEIH_2015_2021_est.dta", clear

drop area2 mes1 mes2
keep if edad>=18 & edad<60

label var edad "Age"
label var esc "Schooling"
label var experiencia "Experience"
label var t_niños_0_3 "# Children 0-3 years"
label var t_niños_3_6 "# Children 3-6 years"
label var t_niños_6_12 "# Children 6-12 years"

label def grupo_educacional_ing 0 "No education" 1 "Elementary" 2 "Secondary" 3 "High School" 4 "Technical and technological" 5 "University"  6 "Postgraduate", replace
label val grupo_educacional grupo_educacional_ing
label var grupo_educacional "Education category"

label def act_eco_ing 0 "Agriculture" 1 "Electricity, gas, water and mining" ///
2 "Industry" 3 "Construction" 4 "Trade and vehicle repair" 5 "Transportation, storage and communications" ///
6 "Accommodation and food services"  7 "Financial and real estate activities" ///
8 "Professional and administrative activities" 9 "Public administration" ///
10 "Education and human health" 11 "Other activities", replace
label val act_eco act_eco_ing
label var act_eco "Sector"

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
replace exp_cat=1 if experiencia>=1 & experiencia<=3
replace exp_cat=2 if experiencia>=3 & experiencia<=6
replace exp_cat=3 if experiencia>=7 & experiencia<=10
replace exp_cat=4 if experiencia>=10 & experiencia<=15
replace exp_cat=5 if experiencia>=15 & experiencia!=.

label def exp_cat 0 "No experience" 1 "+0-3 years" 2 "+3-6 years" 3 "+7-10 years" 4 "+10-15 years" 5 "+15 years", replace
label values exp_cat exp_cat
label var experiencia "Experience"

replace sexo=0 if sexo==1 
replace sexo=1 if sexo==2 
label def sexo 0 "Men" 1 "Women", replace
label values sexo sexo

recode estado_civil (2=0)
label def estado_civil 0 "Otherwise" 1 "Union or married", replace
label values estado_civil estado_civil
label var estado_civil "Marital status: Union or married"

gen rela_labor=1 if p6430==1 | p6430==8 | p6430==3
replace rela_labor=2 if p6430==2 
replace rela_labor=3 if p6430==4 | p6430==5 | p6430==9
label def rela_labor 1 "Private employee" 2 "Government employee" 3 "Self-employed", replace
label values rela_labor rela_labor

gen formalidad_afp=1-Informalidad_AFP
label def formalidad_afp 0 "Otherwise" 1 "Formal", replace
lab values formalidad_afp formalidad_afp
label var formalidad_afp "Formality"

replace rural=(urban==0)
label def rural 0 "Otherwise" 1 "Rural", replace
lab values rural rural
label var rural "Rural"

label def tiempo_parcial_ing 0 "Otherwise" 1 "Part-time job (<40 hours per week)" , replace
label val tiempo_parcial tiempo_parcial_ing

gen lavadora=1 if p5210s4==1
replace lavadora=0 if p5210s4==2

gen acueducto=1 if p5050==1
replace acueducto=0 if p5050==2

gen energia_cocina=1 if p5080==1 | p5080==3 | p5080==4
replace energia_cocina=0 if p5080==2 | p5080==5 | p5080==6 | p5080==7

label var acueducto "Aqueduct"
label var energia_cocina "electric or gas cooker"
label var lavadora "washing machine"

replace area=11 if area==25
replace area=99 if area==.

gen area2=string(area)
replace area2="0"+area2 if length(area2)==1
drop area
rename area2 area
merge m:1 area using "${data}/Names_code_areas_col", keep(1 3) nogen keepusing(Depto)
destring area, replace
labmask area,values(Depto)

gen ing_tot_impu_r=ing_tot_impu1/ipc_mensual
gen log_wr_im=ln(ing_tot_impu_r)
label var log_wr "Real monthly labor income - imputed"

gen log_wr=ln(inglabo_r)
label var log_wr "Real monthly labor income"

gen ln_ht_sem=ln(total_horas_trabajadas_semana)
label var ln_ht_sem "Hours worked per week"

gen log_wr_im_h=ln(ing_tot_impu_r/total_horas_trabajadas)
label var log_wr_im_h "Real hourly labor income - imputed"

gen log_ing_pc=ln(ingpcug/ipc_mensual)
label var log_ing_pc "Log Household per capita income"

gen hombre=(sexo==0)
gen wr_im_h=ing_tot_impu_r/total_horas_trabajadas

label var hombre "Male"
label var wr_im_h "Real hourly labor income - imputed"

global vars "area act_eco rela_labor grupo_educacional g_etarios exp_cat"

foreach x of global vars {
tab `x', gen(`x')
}

save "${data}/geih_ajust_model_outputs", replace
