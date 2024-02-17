********************************************************************************************************
* PRWP 10605: How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery? *
* Figures 1-20 
* By Daniel Medina, Maria Davalos, Diana Londoño

* Figures 1-2

use "${data}/GEIH_2015_2021_est.dta", clear

keep if edad>=18 & edad<=59

keep año sexo fex_c_2011_an dsi* ft* ini* oci* PEA* PET* POB* Informalidad_DANE* Informalidad_AFP* Informalidad_Salud*

collapse (sum) dsi-oci PEA PET POB Informalidad_DANE-Informalidad_Salud [iw=fex_c_2011_an], by(sexo año)

reshape wide dsi-Informalidad_Salud, i(año) j(sexo)

local var "dsi ft ini oci PEA PET POB Informalidad_DANE Informalidad_AFP Informalidad_Salud"
foreach x of local var {
gen `x'=`x'1 +`x'2
}

gen TGP= 100*PEA/PET
gen TGP1= 100*PEA1/PET1
gen TGP2= 100*PEA2/PET2

label var TGP "Total"
label var TGP1 "Men"
label var TGP2 "Women"

gen TD= 100*dsi/PEA
gen TD1= 100*dsi1/PEA1
gen TD2= 100*dsi2/PEA2

label var TD "Total"
label var TD1 "Men"
label var TD2 "Women"

gen TI1= 100*Informalidad_AFP1/oci1
gen TI2= 100*Informalidad_AFP2/oci2

label var TI1 "Men"
label var TI2 "Women"

format TGP* TD* TI* %9.1f

graph bar TGP1 TGP2 if año==2015 | año>=2019, over(año) exclude0 blabel(bar, format(%9.1f)) ///
ylabel(20(20)80, nogrid angle(h)) title("",span) ///
legend(on order(1 "Men" 2 "Women") rows(1)) plotregion(lwidth(none))  ysize(12.000) xsize(20.000) 
graph export "${graphs}\figure1.emf", as(emf) replace

graph bar TD1 TD2 if año==2015 | año>=2019, over(año) exclude0 blabel(bar, format(%9.1f)) ///
ylabel(0(5)20, nogrid angle(h)) title("", span) ///
legend(on order(1 "Men" 2 "Women") rows(1)) plotregion(lwidth(none))  ysize(12.000) xsize(20.000)
graph export "${graphs}\figure2.emf", as(emf) replace

* Figures 3-4

use "${data}/GEIH_2015_2021_est.dta", clear

drop if regis==.
keep if edad>=18 & edad<=59

keep año area sexo fex_c_2011_an dsi* ft* ini* oci* PEA* PET* POB* Informalidad_DANE* Informalidad_AFP* Informalidad_Salud*

collapse (sum) dsi-oci PEA PET POB Informalidad_DANE-Informalidad_Salud [iw=fex_c_2011_an], by(area sexo año)

reshape wide dsi-Informalidad_Salud, i(area año) j(sexo)

local var "dsi ft ini oci PEA PET POB Informalidad_DANE Informalidad_AFP Informalidad_Salud"
foreach x of local var {
gen `x'=`x'1 +`x'2
}

gen TGP= 100*PEA/PET
gen TGP1= 100*PEA1/PET1
gen TGP2= 100*PEA2/PET2

label var TGP "Total"
label var TGP1 "Men"
label var TGP2 "Women"

gen TD= 100*dsi/PEA
gen TD1= 100*dsi1/PEA1
gen TD2= 100*dsi2/PEA2

label var TD "Total"
label var TD1 "Men"
label var TD2 "Women"

gen TI1= 100*Informalidad_AFP1/oci1
gen TI2= 100*Informalidad_AFP2/oci2

label var TI1 "Men"
label var TI2 "Women"

format TGP* TD* TI* %9.1f

tostring area, replace
replace area="0"+area if length(area)==1

merge m:1 area using "${data}/Names_code_areas_col.dta", keep(1 3) nogen
drop if id_mun==25001
replace Municipio="Cartagena" if regexm(Municipio,"Cartagena")
destring area,replace

gen brecha_td=TD2-TD1
gen brecha_tgp=TGP1-TGP2
gen brecha_ti=TI2-TI1

labmask area,values(Municipio)

collapse (mean) brecha_td brecha_tgp brecha_ti, by(area año)
drop if area==0

reshape wide brecha_td brecha_tgp brecha_ti, i(area) j(año)

egen min_br_tgp_pp=rowmin(brecha_tgp2015 brecha_tgp2016 brecha_tgp2017 brecha_tgp2018 brecha_tgp2019)

label var min_br_tgp_pp "Smallest prepandemic gap (2015-2019)"
label var brecha_tgp2019 "2019"
label var brecha_tgp2020 "2020"
label var brecha_tgp2021 "2021"

graph dot (asis) min_br_tgp_pp brecha_tgp2020 brecha_tgp2021, ///
over(area, gap(*5) sort(brecha_tgp2021) descending label(labsize(2.7))) legend(rows(1) span) ///
marker(1, msymbol(smtriangle)) ///
marker(2, msymbol(circle_hollow) mcolor("165 165 165")) ///
marker(3, msymbol(smsquare) mcolor("0 34 68")) ///
exclude0 title("",span) plotregion(lwidth(none)) ysize(12.000) xsize(18.000) ylabel(8(2)26, nogrid) ytitle("Percentage points")
graph export "${graphs}\figure3.emf", as(emf) replace

egen min_br_td_pp=rowmin(brecha_td2015 brecha_td2016 brecha_td2017 brecha_td2018 brecha_td2019)

label var min_br_td_pp "Smallest prepandemic gap (2015-2019)"
label var brecha_td2019 "2019"
label var brecha_td2020 "2020"
label var brecha_td2021 "2021"

graph dot (asis) min_br_td_pp brecha_td2020 brecha_td2021, ///
over(area, gap(*5) sort(brecha_td2021) descending label(labsize(2.7))) legend(rows(1) span) ///
marker(1, msymbol(smtriangle)) ///
marker(2, msymbol(circle_hollow) mcolor("165 165 165")) ///
marker(3, msymbol(smsquare) mcolor("0 34 68")) ///
exclude0 plotregion(lwidth(none)) ysize(12.000) xsize(18.000) ylabel(0(2)17, nogrid) ytitle("Percentage  points")
graph export "${graphs}\figure4.emf", as(emf) replace

* Figure 5 - 6

use "${data}/GEIH_2015_2021_est.dta", clear

keep if edad>=18 & edad<=59

destring mes, replace

merge m:1 mes año using "${data}/monthly_cpi.dta", keep(1 3) nogen

replace total_horas_trabajadas_semana=. if total_horas_trabajadas_semana==0

replace ing_tot_impu1=. if ing_tot_impu1==0
gen ing_lab_real=(ing_tot_impu1/ipc_mensual)
gen ing_lab_r_hora=(ing_tot_impu1/total_horas_trabajadas)

keep if oci==1

collapse (mean) oci ing_lab_r_hora ing_lab_real total_horas_trabajadas total_horas_trabajadas_semana inglabo [iw=fex_c_2011_an], by(sexo año)

replace ing_lab_real=ing_lab_real/1000

format ing_lab_real %9.0fc

keep oci ing_lab_real ing_lab_r_hora total_horas_trabajadas total_horas_trabajadas_semana inglabo sexo año

drop if sexo==.
reshape wide oci ing_lab_real ing_lab_r_hora total_horas_trabajadas total_horas_trabajadas_semana inglabo, i(año) j(sexo)

gen brecha=100*(ing_lab_real1-ing_lab_real2)/ing_lab_real2
gen pos=(ing_lab_real1+ing_lab_real2)/2

format brecha %9.0f

tostring brecha, replace force format(%9.1f)
replace brecha=brecha+"%"

tset año

twoway 	(tsline ing_lab_real1, recast(scatter) msymbol(circle)) ///
		(tsline ing_lab_real2, recast(scatter) msymbol(circle)) ///
		(tsrline ing_lab_real1 ing_lab_real2, recast(rspike) lcolor(black%60) lpattern(shortdash)) ///
		(tsline pos, mlabcolor(black%60) recast(scatter) msymbol(none) mlabel(brecha)), ///
ytitle(" Average labor income (thousands)") xtitle("") ylabel(1000(50)1250) ///
tlabel(2015(1)2021) plotregion(margin(large) lwidth(none)) ysize(12.000) xsize(20.000) ///
legend(on order(1 "Men" 2 "Women" 3 "Gap to women's real labor income (%)") rows(1))
graph export "${graphs}\Figure5.emf",  replace

gen brechah=100*(total_horas_trabajadas_semana1-total_horas_trabajadas_semana2)/total_horas_trabajadas_semana2
gen posh=(total_horas_trabajadas_semana1+total_horas_trabajadas_semana2)/2

format brechah %9.0f

tostring brechah, replace force format(%9.1f)
replace brechah=brechah+"%"

twoway (tsline total_horas_trabajadas_semana1, recast(scatter) msymbol(circle)) ///
(tsline total_horas_trabajadas_semana2, recast(scatter) msymbol(circle)) ///
(tsrline total_horas_trabajadas_semana1 total_horas_trabajadas_semana2, recast(rspike) lcolor(black%60) lpattern(shortdash)) ///
(tsline posh, mlabcolor(black%60) recast(scatter) msymbol(none) mlabel(brechah)), ///
ytitle("Average hours worked per week") xtitle("") ///
tlabel(2015(1)2021) plotregion(margin(large) lwidth(none)) ysize(12.000) xsize(20.000) ///
legend(on order(1 "Men" 2 "Women" 3 "Gap to hours worked by women(%)") rows(1))
graph export "${graphs}\Figure6.emf",  replace

* Figure 7 - 8

use "${data}/GEIH_2015_2021_est.dta", clear

keep if edad>=18 & edad<=59

destring mes, replace

merge m:1 mes año using "${data}/monthly_cpi.dta", keep(1 3) nogen

replace inglabo=. if inglabo==0
replace total_horas_trabajadas_semana=. if total_horas_trabajadas_semana==0

replace ing_tot_impu1=. if ing_tot_impu1==0
gen ing_lab_real=(ing_tot_impu1/ipc_mensual)
gen ing_lab_r_hora=(ing_tot_impu1/total_horas_trabajadas)

keep if oci==1
keep if g_etario==1 | g_etario==2 | g_etario==3

collapse (mean) oci ing_lab_r_hora ing_lab_real total_horas_trabajadas total_horas_trabajadas_semana inglabo [iw=fex_c_2011_an], by(sexo area año)

replace ing_lab_real=ing_lab_real/1000

format ing_lab_real %9.0fc

keep oci ing_lab_real ing_lab_r_hora total_horas_trabajadas total_horas_trabajadas_semana inglabo sexo año area

drop if sexo==.
reshape wide oci ing_lab_real ing_lab_r_hora total_horas_trabajadas total_horas_trabajadas_semana inglabo, i(año area) j(sexo)

tostring area, replace
replace area="0"+area if length(area)==1

merge m:1 area using "${data}/Names_code_areas_col.dta", keep(1 3) nogen
drop if id_mun==25001
replace Municipio="Cartagena" if regexm(Municipio,"Cartagena")
destring area,replace

labmask area,values(Municipio)

gen brechaing=100*(ing_lab_real1-ing_lab_real2)/ing_lab_real2
gen brechaabs=(ing_lab_real1-ing_lab_real2)

gen brechah=(total_horas_trabajadas_semana1-total_horas_trabajadas_semana2)

format brecha* %9.0f

drop if area==0

keep brechaing brechaabs brechah area año
reshape wide brechaing brechaabs brechah, i(area) j(año)

egen min_br_ing=rowmin(brechaing2015 brechaing2016 brechaing2017 brechaing2018 brechaing2019)
egen min_br_abs=rowmin(brechaabs2015 brechaabs2016 brechaabs2017 brechaabs2018 brechaabs2019)
egen min_br_h=rowmin(brechah2015 brechah2016 brechah2017 brechah2018 brechah2019)

label var min_br_ing "Smallest prepandemic gap (2015-2019)"
label var min_br_abs "Smallest prepandemic gap (2015-2019)"
label var min_br_h 	 "Smallest prepandemic gap (2015-2019)"

label var brechaing2019 "2019"
label var brechaing2020 "2020"
label var brechaing2021 "2021"

label var brechah2019 "2019"
label var brechah2020 "2020"
label var brechah2021 "2021"

label var brechaabs2019 "2019"
label var brechaabs2020 "2020"
label var brechaabs2021 "2021"

graph dot (asis) min_br_ing brechaing2020 brechaing2021, over(area, sort(brechaing2021) ///
descending label(labsize(2.7))) legend(rows(1) span) ///
marker(1, msymbol(smtriangle)) ///
marker(2, msymbol(circle_hollow) mcolor("165 165 165")) ///
marker(3, msymbol(smsquare) mcolor("0 34 68")) exclude0 ///
plotregion(lwidth(none)) ysize(12.000) xsize(18.000) ///
ylabel(0(5)30, nogrid) ytitle("Gap to women's real labor income (%)")
graph export "${graphs}\figure7.emf",  replace

graph dot (asis) min_br_h brechah2020 brechah2021, over(area, gap(*5) sort(brechah2021) ///
descending label(labsize(2.7))) legend(rows(1) span) ///
marker(1, msymbol(smtriangle)) ///
marker(2, msymbol(circle_hollow) mcolor("165 165 165")) ///
marker(3, msymbol(smsquare) mcolor("0 34 68")) exclude0 ///
plotregion(lwidth(none)) ysize(12.000) xsize(18.000) ylabel(3(1)12, nogrid) ///
ytitle("Gap average hours worked per week (men - women)")
graph export "${graphs}\figure8.emf",  replace

* Figure 9

use "${data}/GEIH_2015_2021_est.dta", clear

keep if edad>=18 & edad<=59

gen sector=.
gen variable=rama2d_r4

forval   x=01/03 {
replace  sector=0 if variable==`x'
}

forval   x=05/09 {
replace  sector=1 if variable==`x'
}

forval   x=35/40 {
replace  sector=1 if variable==`x'
}

forval   x=10/34 {
replace  sector=2 if variable==`x'
}

forval   x=41/43 {
replace  sector=3 if variable==`x'
}

forval   x=45/47 {
replace  sector=4 if variable==`x'
}

forval   x=49/53 {
replace  sector=5 if variable==`x'
}

forval   x=58/63 {
replace  sector=5 if variable==`x'
}

forval   x=55/56 {
replace  sector=6 if variable==`x'
}

foreach   x of numlist 64/67 {
replace  sector=7 if variable==`x'
}

foreach   x of numlist 68 77 {
replace  sector=8 if variable==`x'
}

foreach x of numlist 69/75 {
replace  sector=9 if variable==`x'
}

foreach x of numlist 79/82 {
replace  sector=10 if variable==`x'
}

foreach x of numlist 84 {
replace  sector=11 if variable==`x'
}

foreach x of numlist 85 {
replace  sector=12 if variable==`x'
}

foreach x of numlist 86 87 88 {
replace  sector=13 if variable==`x'
}

forval   x=90/93 {
replace  sector=14 if variable==`x'
}

forval   x=94/99 {
replace  sector=14 if variable==`x'
}

foreach x of numlist 78 {
replace  sector=15 if variable==`x'
}

replace  sector=16 if variable==0

label def sector 0 "Agriculture" ///
			1 "Electricity, gas, water, and mining" ///
			2 "Industry" ///
			3 "Construction" ///
			4 "Trade and repair of vehicles" ///
			5 "Transportation and communications" ///
			6 "Accommodation and food service" ///
			7 "Financial activities" ///
			8 "Real estate" ///
			9 "Professional activities" ///
			10 "Administrative and support activities" ///
			11 "Public administration" ///
			12 "Education" ///
			13 "Human health" ///
			14 "Other activities" ///
			15 "Employment activities" ///
			16 "Not specified" ,replace

lab val sector sector

keep año sector sexo fex_c_2011_an dsi* ft* ini* oci* PEA* PET* POB* Informalidad_DANE* Informalidad_AFP* Informalidad_Salud*

drop if sector==.

collapse (sum) oci PEA Informalidad_AFP [pw=fex_c_2011_an], by(sector sexo año)
reshape wide oci PEA Informalidad_AFP, i(sector año) j(sexo)

egen oci=rowtotal(oci*)
		
decode sector, gen(act_eco)

drop if sector>=15

forval i=1/2 {
gen p_oci`i'= 100*oci`i'/oci
}

gsort año p_oci2
gen order=_n
labmask order, values(act_eco)

drop Informalidad_AFP1 Informalidad_AFP2

drop PEA* act_eco order
reshape wide oci1 oci2 oci p_oci1 p_oci2, i(sector) j(año)

gen dem_crec21_19=(oci2021/oci2019-1)*100

gen pos=0
replace pos=9 if sector==2
replace pos=0 if sector==4
replace pos=3 if sector==5
replace pos=4 if sector==9
replace pos=5 if sector==11
replace pos=12 if sector==14

twoway 	(scatter p_oci22019 dem_crec21_19 [aw=oci22021], msymbol(circle) mcolor(%30) mlcolor(%20)) ///
		(scatter p_oci22019 dem_crec21_19 , msymbol(none) mlabel(sector) mlabvposition(pos)  mlabcolor(black)) ///
		(mspline p_oci22019 dem_crec21_19), ytitle("Industry participation (%)") ///
xtitle("Employment growth (%)") legend(off) xlabel(-20(5)20) xline(0, lcolor(red) lpattern(dash)) ///
plotregion(lwidth(none)) ysize(12.000) xsize(20.000) ylabel(0(20)100) yline(50, lcolor(red) lpattern(dash)) ///
text(100 -10 "Zone I") text(100 10 "Zone II") text(0 -10 "Zone III") text(0 10 "Zone IV")
graph export "${graphs}\Figure9.emf", as(emf) replace

* Figure 10

use "${data}/GEIH_2015_2021_est.dta", clear

keep if edad>=18 & edad<=59

drop if Informalidad_AFP==1

gen sector=.
gen variable=rama2d_r4
forval   x=01/03 {
replace  sector=0 if variable==`x'
}

forval   x=05/09 {
replace  sector=1 if variable==`x'
}

forval   x=35/40 {
replace  sector=1 if variable==`x'
}

forval   x=10/34 {
replace  sector=2 if variable==`x'
}

forval   x=41/43 {
replace  sector=3 if variable==`x'
}

forval   x=45/47 {
replace  sector=4 if variable==`x'
}

forval   x=49/53 {
replace  sector=5 if variable==`x'
}

forval   x=58/63 {
replace  sector=5 if variable==`x'
}

forval   x=55/56 {
replace  sector=6 if variable==`x'
}

foreach   x of numlist 64/67 {
replace  sector=7 if variable==`x'
}

foreach   x of numlist 68 77 {
replace  sector=8 if variable==`x'
}

foreach x of numlist 69/75 {
replace  sector=9 if variable==`x'
}

foreach x of numlist 79/82 {
replace  sector=10 if variable==`x'
}

foreach x of numlist 84 {
replace  sector=11 if variable==`x'
}

foreach x of numlist 85 {
replace  sector=12 if variable==`x'
}

foreach x of numlist 86 87 88 {
replace  sector=13 if variable==`x'
}

forval   x=90/93 {
replace  sector=14 if variable==`x'
}

forval   x=94/99 {
replace  sector=14 if variable==`x'
}

foreach x of numlist 78 {
replace  sector=15 if variable==`x'
}

replace  sector=16 if variable==0

label def sector 0 "Agriculture" ///
			1 "Electricity, gas, water, and mining" ///
			2 "Industry" ///
			3 "Construction" ///
			4 "Trade and repair of vehicles" ///
			5 "Transportation and communications" ///
			6 "Accommodation and food service" ///
			7 "Financial activities" ///
			8 "Real estate" ///
			9 "Professional activities" ///
			10 "Administrative and support activities" ///
			11 "Public administration" ///
			12 "Education" ///
			13 "Human health" ///
			14 "Other activities" ///
			15 "Employment activities" ///
			16 "Not specified" ,replace

lab val sector sector

keep año sector sexo fex_c_2011_an dsi* ft* ini* oci* PEA* PET* POB* Informalidad_DANE* Informalidad_AFP* Informalidad_Salud*

drop if sector==.

collapse (sum) oci PEA [pw=fex_c_2011_an], by(sector sexo año)
reshape wide oci PEA, i(sector año) j(sexo)

egen oci=rowtotal(oci*)
		
decode sector, gen(act_eco)

drop if sector>=15

forval i=1/2 {
gen p_oci`i'= 100*oci`i'/oci
}

gsort año p_oci2
gen order=_n
labmask order, values(act_eco)

drop PEA* act_eco order
reshape wide oci1 oci2 oci p_oci1 p_oci2, i(sector) j(año)

gen dem_crec21_19=(oci2021/oci2019-1)*100

merge 1:1 sector using "${data}/Vacancies.dta", keep(1 3) nogen

gen demvac_crec21_19=(vac2021/vac2019-1)*100

gen pos=0
replace pos=3 if sector==1
replace pos=3 if sector==4
replace pos=3 if sector==6
replace pos=9 if sector==9
replace pos=12 if sector==10
replace pos=9 if sector==11
replace pos=12 if sector==14

twoway 	(scatter p_oci22019 demvac_crec21_19 [aw=oci22021] if sector!=0, msymbol(circle) mcolor(%30) mlcolor(%20)) ///
		(scatter p_oci22019 demvac_crec21_19 if sector!=0, msymbol(none) mlabel(sector) mlabvposition(pos)  mlabcolor(black)) ///
		(mspline p_oci22019 demvac_crec21_19 if sector!=0), ytitle("Industry participation (%)") ///
xtitle("Growth in job offers (%)") legend(off) xlabel(-60(20)100) xline(0, lcolor(red) lpattern(dash)) ///
title("",span size(4.5)) plotregion(lwidth(none)) ysize(12.000) xsize(20.000) ylabel(0(20)100) yline(50, lcolor(red) lpattern(dash)) ///
text(100 -30 "Zone I") text(100 50 "Zone II") text(0 -30 "Zone III") text(0 50 "Zone IV")
graph export "${graphs}\Figure10.emf", as(emf) replace

* Figure 11-12

use "${data}/GEIH_2015_2021_est.dta", clear

keep if edad>=25 & edad<=59

gen ten_hijos=(c_hijos>0)

gen edu_sup=0 if  grupo_educacional<4
replace edu_sup=1 if  grupo_educacional>3 & grupo_educacional<7

keep año ten_hijos edu_sup sexo fex_c_2011_an dsi* ft* ini* oci* PEA* PET* POB* Informalidad_DANE* Informalidad_AFP* Informalidad_Salud*

collapse (sum) dsi ft ini oci PEA PET POB Informalidad_DANE Informalidad_AFP Informalidad_Salud [iw=fex_c_2011_an], by(edu_sup ten_hijos sexo año)

keep if año>=2017

reshape wide dsi-Informalidad_Salud, i(ten_hijos edu_sup año) j(sexo)
reshape wide dsi1-Informalidad_Salud2, i(edu_sup año) j(ten_hijos)

drop if edu_sup==.

gen TGP10= 100*PEA10/PET10
gen TGP20= 100*PEA20/PET20
gen TGP11= 100*PEA11/PET11
gen TGP21= 100*PEA21/PET21

label var TGP10 "Men no children"
label var TGP20 "Women no children"
label var TGP11 "Men children"
label var TGP21 "Women children"

gen TD10= 100*dsi10/PEA10
gen TD20= 100*dsi20/PEA20
gen TD11= 100*dsi11/PEA11
gen TD21= 100*dsi21/PEA21

label var TD10 "Men no children"
label var TD20 "Women no children"
label var TD11 "Men children"
label var TD21 "Women children"

gen TI10= 100*Informalidad_AFP10/oci10
gen TI20= 100*Informalidad_AFP20/oci20
gen TI11= 100*Informalidad_AFP11/oci11
gen TI21= 100*Informalidad_AFP21/oci21

label var TI10 "Men no children"
label var TI20 "Women no children"
label var TI11 "Men children"
label var TI21 "Women children"

format TGP* TD* TI* %9.1f

label def edu_sup 0 "No higher education" 1 "Higher education", replace
label values edu_sup edu_sup

keep año edu_sup TGP10-TD21

export excel using "${graphs}\Graphs_excel.xlsx" if año>=2017 & año!=2018, sheet("fig_11_12") sheetmodify firstrow(variables) keepcellfmt

* Figure 13

use "${data}/GEIH_2015_2021_est.dta", clear

keep if edad>=18 & edad<=59

gen sector=.
gen variable=rama2d_r4

forval   x=01/03 {
replace  sector=0 if variable==`x'
}

forval   x=05/09 {
replace  sector=1 if variable==`x'
}

forval   x=35/40 {
replace  sector=1 if variable==`x'
}

forval   x=10/34 {
replace  sector=2 if variable==`x'
}

forval   x=41/43 {
replace  sector=3 if variable==`x'
}

forval   x=45/47 {
replace  sector=4 if variable==`x'
}

forval   x=49/53 {
replace  sector=5 if variable==`x'
}

forval   x=58/63 {
replace  sector=5 if variable==`x'
}

forval   x=55/56 {
replace  sector=6 if variable==`x'
}

foreach   x of numlist 64/67 {
replace  sector=7 if variable==`x'
}

foreach   x of numlist 68 77 {
replace  sector=8 if variable==`x'
}

foreach x of numlist 69/75 {
replace  sector=9 if variable==`x'
}

foreach x of numlist 79/82 {
replace  sector=10 if variable==`x'
}

foreach x of numlist 84 {
replace  sector=11 if variable==`x'
}

foreach x of numlist 85 {
replace  sector=12 if variable==`x'
}

foreach x of numlist 86 87 88 {
replace  sector=13 if variable==`x'
}

forval   x=90/93 {
replace  sector=14 if variable==`x'
}

forval   x=94/99 {
replace  sector=14 if variable==`x'
}

foreach x of numlist 78 {
replace  sector=15 if variable==`x'
}

replace  sector=16 if variable==0

label def sector 0 "Agriculture" ///
			1 "Electricity, gas, water, and mining" ///
			2 "Industry" ///
			3 "Construction" ///
			4 "Trade and repair of vehicles" ///
			5 "Transportation and communications" ///
			6 "Accommodation and food service" ///
			7 "Financial activities" ///
			8 "Real estate" ///
			9 "Professional activities" ///
			10 "Administrative and support activities" ///
			11 "Public administration" ///
			12 "Education" ///
			13 "Human health" ///
			14 "Other activities" ///
			15 "Employment activities" ///
			16 "Not specified" ,replace

lab val sector sector

drop if sector==.

keep año sector sexo fex_c_2011_an dsi* ft* ini* oci* PEA* PET* POB* Informalidad_DANE* Informalidad_AFP* Informalidad_Salud* c_hijos

collapse (sum) Informalidad_AFP oci PEA [pw=fex_c_2011_an], by(sector sexo c_hijos año)

drop if c_hijos==.
reshape wide Informalidad_AFP oci PEA, i(sector c_hijos año) j(sexo)
reshape wide Informalidad_AFP* oci* PEA*, i(sector año) j( c_hijos)

egen Informalidad_AFP=rowtotal(Informalidad_AFP*)
egen oci=rowtotal(oci*)
gen ti=100*(Informalidad_AFP)/oci

egen oci1=rowtotal(oci1*)
egen oci2=rowtotal(oci2*)

gen oci2_1ymas=100*(oci21+oci22+oci23)/oci2
gen oci2_2ymas=100*(oci22+oci23)/oci2

drop if sector==16
scatter oci2_1ymas ti 
scatter oci2_2ymas ti if año==2021 || scatter oci2_2ymas ti if año==2019 || scatter oci2_2ymas ti if año==2017
scatter oci2_1ymas ti if año==2021 || scatter oci2_1ymas ti if año==2019 || scatter oci2_1ymas ti if año==2017


gen pos=0
replace pos=3 if sector==1
replace pos=3 if sector==4
replace pos=3 if sector==6
replace pos=9 if sector==9
replace pos=12 if sector==10
replace pos=9 if sector==11
replace pos=12 if sector==14

twoway 	(scatter ti oci2_1ymas if año==2019, msymbol(circle) mcolor(%30) mlcolor(%20)) ///
		(scatter ti oci2_1ymas if año==2020, msymbol(circle) mcolor(%30) mlcolor(%20)) ///
		(scatter ti oci2_1ymas if año==2021, msymbol(circle) mcolor(%30) mlcolor(%20)) ///
		(mspline ti oci2_1ymas if año>=2019, n(100)), ///
xlabel(25(5)50) ylabel(0(20)100) legend(on order(1 "2019" 2 "2020" 3 "2021") ///
rows(1)) plotregion(lwidth(none)) ysize(12.000) xsize(20.000) ///
xtitle("Employed women with children (% total employed women)") ytitle("Sector informality rate (%)")
graph export "${graphs}\Figure13.emf", as(emf) replace

****************************
* Figure 14-15

use "${data}/GEIH_2015_2021_est.dta", clear

gen joven=(edad>=18 & edad<=28)
label def joven 0 "No ages 18-28" 1 "Ages 18-28"
label val joven joven

gen ten_hijos=(c_hijos>0)
label def ten_hijos 0 "No children" 1 "Children"
label val ten_hijos ten_hijos

gen edu_sup=0 if  grupo_educacional<4
replace edu_sup=1 if  grupo_educacional>3 & grupo_educacional<7

label def edu_sup 0 "No higher education" 1 "Higher education"
label val edu_sup edu_sup

gen etnia=(p6080>=3 & p6080<=5)		
tab etnia

label def etnia 0 " No ethnic self-recognition" 1 "Ethnic self-recognition (black and similar)"
label val etnia etnia

keep año sexo joven ten_hijos urban edu_sup etnia fex_c_2011_an dsi PEA*

keep if año>=2017

local i=1
foreach x of varlist joven ten_hijos urban edu_sup etnia {
preserve

collapse (sum) dsi PEA [iw=fex_c_2011_an], by(año sexo `x')

decode `x', generate(categoria)
drop `x'
reshape wide dsi PEA, i(año categoria) j(sexo)

if `i'==1 {
save "$temp_files/data_cat_fig14_15", replace
local i=2
}
else {
append using "$temp_files/data_cat_fig14_15"

save "$temp_files/data_cat_fig14_15", replace

}
restore
}

use "$temp_files/data_cat_fig14_15", clear

drop if categoria==""

replace año=2019 if año==2020 & categoria=="Ethnic self-recognition (black and similar)"

gen TD1= 100*dsi1/PEA1
gen TD2= 100*dsi2/PEA2

label var TD1 "Men"
label var TD2 "Women"

format TD* %9.1f

keep año categoria TD1 TD2 

export excel using "${graphs}\Graphs_excel.xlsx" if año>=2017 & año!=2018, sheet("fig_14_15") sheetmodify firstrow(variables) keepcellfmt

****************************
* Figure 16-19

use "${data}/GEIH_2015_2021_est.dta", clear

gen joven=(edad>=41 & edad<=59)
label def joven 0 "No ages 41-59" 1 "Ages 41-59"
label val joven joven

gen ten_hijos=(c_hijos>0)
label def ten_hijos 0 "No children" 1 "Children"
label val ten_hijos ten_hijos

gen edu_sup=0 if  grupo_educacional<4
replace edu_sup=1 if  grupo_educacional>3 & grupo_educacional<7

label def edu_sup 0 "No higher education" 1 "Higher education"
label val edu_sup edu_sup

gen etnia=(p6080==1)		
tab etnia

label def etnia 0 " No ethnic self-recognition" 1 "Ethnic self-recognition (indigena)"
label val etnia etnia

merge m:1 mes año using "${data}/monthly_cpi.dta", keep(1 3) nogen

replace inglabo=. if ing_tot_impu1==0
replace inglabo=. if inglabo==0

replace total_horas_trabajadas_semana=. if total_horas_trabajadas_semana==0

gen ing_lab_real=(ing_tot_impu1/ipc_mensual)
gen ing_lab_r_hora=(ing_tot_impu1/total_horas_trabajadas)

keep if oci==1 

keep if año>=2017

rename total_horas_trabajadas_semana total_h_trab_sem
keep año sexo joven ten_hijos urban edu_sup etnia fex_c_2011_an mes ing_lab_real total_h_trab_sem fex_c_2011

local i=1
foreach x of varlist joven ten_hijos urban edu_sup etnia {
preserve

collapse (mean) ing_lab_real total_h_trab_sem [iw=fex_c_2011_an], by(sexo año `x')

replace ing_lab_real=ing_lab_real/1000
format ing_lab_real %9.0fc

decode `x', generate(categoria)
drop `x'
reshape wide ing_lab_real total_h_trab_sem, i(año categoria) j(sexo)

reshape wide ing_lab_real1-total_h_trab_sem2, i(categoria) j(año)

if `i'==1 {
save "$temp_files/data_cat_fig16_18", replace
local i=2
}
else {
append using "$temp_files/data_cat_fig16_18"

save "$temp_files/data_cat_fig16_18", replace

}
restore
}

use "$temp_files/data_cat_fig16_18", clear

drop if categoria==""

replace total_h_trab_sem12019=total_h_trab_sem12020 if categoria=="Ethnic self-recognition (indigena)"

replace total_h_trab_sem22019=total_h_trab_sem22020 if categoria=="Ethnic self-recognition (indigena)"

replace ing_lab_real22019=ing_lab_real22020 if categoria=="Ethnic self-recognition (indigena)"

replace ing_lab_real12019=ing_lab_real12020 if categoria=="Ethnic self-recognition (indigena)"

order categoria ing_lab_real* total_h_trab_sem*

replace categoria="Total" if regexm(categoria,"ocupada")==1
export excel using "${graphs}\Graphs_excel.xlsx", sheet("fig_16_19") sheetmodify firstrow(variables) keepcellfmt

* Figure 17

use "${data}/GEIH_2015_2021_est.dta", clear

keep if edad>=18 & edad<=59

gen tf_sinremun=(p6430==6)

replace tf_sinremun=. if p6430==.

gen children_hog=1 if niños_0_3==1 | niños_3_6==1 | niños_6_12==1
replace children_hog=0 if niños_0_3==0 & niños_3_6==0 & niños_6_12==1

drop if children_hog==.

keep año sexo tf_sinremun fex_c_2011_an oci PEA PET children_hog

collapse (sum) tf_sinremun oci* PEA* PET* [iw=fex_c_2011_an], by(children_hog sexo año)

reshape wide tf_sinremun oci PEA PET, i(children_hog año) j(sexo)

xtset children_hog año 

gen TO_fsr1= 100*tf_sinremun1/PET1
gen TO_fsr2= 100*tf_sinremun2/PET2
gen PO_fsr1= 100*tf_sinremun1/oci1
gen PO_fsr2= 100*tf_sinremun2/oci2
gen TI1= 100*(PET1-PEA1)/PET1
gen TI2= 100*(PET2-PEA2)/PET2
gen TC1=100*(tf_sinremun1/l1.tf_sinremun1-1)
gen TC2=100*(tf_sinremun2/l1.tf_sinremun2-1)
gen P_fsr1=100*(tf_sinremun1/(tf_sinremun1+tf_sinremun2))
gen P_fsr2=100*(tf_sinremun2/(tf_sinremun1+tf_sinremun2))

keep children_hog año TO_fsr1-P_fsr2

label def children_hog 0 "No children" 1 "Children", replace
label values children_hog children_hog

export excel using "${graphs}\Graphs_excel.xlsx" if año>=2017 & año!=2018, sheet("fig_17") sheetmodify firstrow(variables) keepcellfmt

* Figure 18 - 20

use "${data}/GEIH_2015_2021_est.dta", clear

destring mes, replace

keep if edad>=25 & edad<=59

merge m:1 mes año using "${data}/monthly_cpi.dta", keep(1 3) nogen

replace inglabo=. if inglabo==0
replace total_horas_trabajadas_semana=. if total_horas_trabajadas_semana==0

gen ing_lab_real=(ing_tot_impu1/ipc_mensual)
gen ing_lab_r_hora=(ing_tot_impu1/total_horas_trabajadas)

keep if oci==1

gen edu_sup=0 if  grupo_educacional<4
replace edu_sup=1 if  grupo_educacional>3 & grupo_educacional<7

keep if año>=2017

drop hijos
gen hijos=(c_hijos>0 & c_hijos!=.)
gen children_hog=(niños_0_3>0 | niños_3_6>0 | niños_6_12>0)
collapse (count) oci (p50) ing_lab_r_hora ing_lab_real inglabo (mean) total_horas_trabajadas total_horas_trabajadas_semana [iw=fex_c_2011_an], by(sexo children_hog edu_sup año)

rename children_hog hijos 

replace ing_lab_real=ing_lab_real/1000

format ing_lab_real %9.0fc

keep oci ing_lab_real ing_lab_r_hora total_horas_trabajadas total_horas_trabajadas_semana inglabo sexo año hijos edu_sup

reshape wide oci ing_lab_real ing_lab_r_hora total_horas_trabajadas total_horas_trabajadas_semana inglabo, i(hijos edu_sup año) j(sexo)
keep ing_lab_real* total_horas_trabajadas_semana* año hijos edu_sup

gen brecha=100*(ing_lab_real1-ing_lab_real2)/ing_lab_real2
gen pos=(ing_lab_real1+ing_lab_real2)/2

format brecha %9.0f

tostring brecha, replace force format(%9.1f)

replace brecha=brecha+"%"

keep if año==2017 | año>=2019

replace año=2018 if año==2017
label define año 2018 "2017" 2019 "2019" 2020 "2020" 2021 "2021",replace
label values año año

label def edu_sup 0 "No higher education" 1 "Higher education", replace
label values edu_sup edu_sup

label def hijos 0 "No children" 1 "Children", replace
label values hijos hijos

keep if año>=2018

drop if edu_sup==.

grstyle color p1  "0 159 218" // light blue
grstyle color p2  "0 34 68" // dark blue

twoway 	(scatter ing_lab_real1 año if edu_sup==0, msymbol(smcircle)) ///
		(scatter ing_lab_real2 año if edu_sup==0, msymbol(smcircle)) ///
		(rspike ing_lab_real1 ing_lab_real2 año if edu_sup==0, lcolor(black%60) lpattern(shortdash)) ///
		(scatter pos año if edu_sup==0, msymbol(none) mlabel(brecha) mlabsize(3)  mlabcolor(black%60)) ///
		(scatter ing_lab_real1 año if edu_sup==1, msymbol(smsquare) mcolor("0 159 218")) ///
		(scatter ing_lab_real2 año if edu_sup==1, msymbol(smsquare) mcolor("0 34 68")) ///
		(rspike ing_lab_real1 ing_lab_real2 año if edu_sup==1, lcolor(black%60) lpattern(shortdash)) ///
		(scatter pos año if edu_sup==1, msymbol(none) mlabel(brecha) mlabsize(3) mlabcolor(black%60)), by(hijos) plotregion(margin(medium)) ///
plotregion(margin(large) lwidth(none)) subtitle(, nobox) by(,  rows(1) legend(on) caption("") note("")) ///
legend(order(1 "Men without HE" 2 "Women without HE" 3 "Gap to women" 5 "Men with HE" 6 "Women with HE") rows(2)) ///
ytitle("Real labor income (thousands)") ylabel(, nogrid angle(h)) xtitle("") tlabel(2018(1)2021,valuelabel ) ysize(12.000) xsize(20.000)
graph export "${graphs}\Figure18.emf",  replace

gen brecha_h=100*(total_horas_trabajadas_semana1-total_horas_trabajadas_semana2)/total_horas_trabajadas_semana2
gen pos_h=(total_horas_trabajadas_semana1+total_horas_trabajadas_semana2)/2

format brecha_h %9.0f

tostring brecha_h, replace force format(%9.1f)

replace brecha_h=brecha_h+"%"

graph bar (asis) total_horas_trabajadas_semana1 total_horas_trabajadas_semana2 if año==2019 | año==2021, ///
over(año) over(edu_sup) by(hijos) exclude0 blabel(bar, format(%9.0f) size(3)) ///
bar(1, lcolor(%70)) bar(2, lcolor(%70))  plotregion(lwidth(none)) subtitle(, nobox) by(,  rows(1) legend(on)  caption("") note("")) ///
legend(order(1 "Men" 2 "Women" ) rows(1)) ysize(12.000) xsize(20.000)  ylabel(35(5)50, nogrid angle(h)) 
graph export "${graphs}\Figure20.emf", replace
