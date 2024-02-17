********************************************************************************************************
* PRWP 10605: How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery? *
* Key variables
* By Daniel Medina, Maria Davalos, Diana Londoño

use "${data}/GEIH_2015_2021_wb", clear

* Create children in the household variable
* Female
replace regis=10 if regis==.
replace hogar=1 if hogar==.

keep directorio secuencia hogar año mes regis p6083s1 p6083 edad regis
rename p6083s1 orden

drop if orden==. 
gen hijos_m=1 if edad<12
drop if hijos_m==.

collapse (sum) hijos_m, by(directorio secuencia hogar año mes orden regis)

save "${data}/temp_m", replace

* Male
use "${data}/GEIH_2015_2021_wb",clear

replace regis=10 if regis==.
replace hogar=1 if hogar==.

keep directorio secuencia hogar año mes p6081s1 p6081 edad regis
rename p6081s1 orden

drop if orden==. 
gen hijos_h=1 if edad<12
drop if hijos_h==.

collapse (sum) hijos_h, by(directorio secuencia hogar año mes orden regis)

save "${data}/temp_h", replace

* Partner last education level
use "${data}/GEIH_2015_2021_wb",clear

keep directorio secuencia hogar año mes orden regis p6071s1 p6220 p6210

renam p6220 ult_titulo_c
replace ult_titulo_c=1 if ult_titulo_c==. & p6210<5

label def titulo 1 "Ninguno" 2 "Bachiller" 3 "Técnico y tecnólogo" 4 "Universitario" 5 "Posgrado", replace
label values ult_titulo_c titulo

rename orden orden2
rename p6071s1 orden
drop if orden==.

drop p6210

duplicates report directorio secuencia hogar año mes orden regis
duplicates tag directorio secuencia hogar año mes orden regis,gen(tag)

bys directorio secuencia hogar año mes orden regis: egen min=min(orden2)

drop if tag==1 & orden2!=min

drop tag min orden2

duplicates report directorio secuencia hogar año mes orden regis

save "${data}/conyugue_edu", replace

* Merge bases
use "${data}/GEIH_2015_2021_wb",clear

gen regis_ori=regis
gen hogar_ori=hogar

replace regis=10 if regis==.
replace hogar=1 if hogar==.

merge 1:1 directorio secuencia hogar año mes orden regis using "${data}\temp_m", keep(1 3) gen(merge_hm)
merge 1:1 directorio secuencia hogar año mes orden regis using "${data}\temp_h", keep(1 3) gen(merge_hh)

erase "${data}/temp_h.dta"
erase "${data}/temp_m.dta"

replace hijos_m=. if sexo==1
replace hijos_h=. if sexo==2

merge 1:1 directorio secuencia hogar año mes orden regis using "${data}/conyugue_edu", keep(1 3) gen(merge_c_edu)

duplicates report directorio secuencia hogar año mes orden regis

erase "${data}/conyugue_edu.dta"

compress

merge m:1 mes año using "${data}\monthly_cpi.dta", keep(1 3) nogen

drop if sexo==.

* Annual expansion factor
gen fex_c_2011_an=fex_c_2011/12

* Household indicador
egen idhogar=group(directorio secuencia hogar año mes regis)

* labor income correction for outliers
_pctile  inglabo [pw=fex_c_2011_an], p(1 99.99)
replace inglabo=. if  inglabo<r(r1) | inglabo>r(r2)
gen inglabo_r=(inglabo/ipc_mensual)

* Children by household

gen c_hijos_m=0 if hijos_m==. & sexo==2
replace c_hijos_m=1 if hijos_m==1 & sexo==2
replace c_hijos_m=2 if hijos_m==2 & sexo==2
replace c_hijos_m=3 if hijos_m>=3 & hijos_m!=. & sexo==2
replace c_hijos_m=. if regis_ori==.

gen c_hijos_h=0 if hijos_h==. & sexo==1
replace c_hijos_h=1 if hijos_h==1 & sexo==1
replace c_hijos_h=2 if hijos_h==2 & sexo==1
replace c_hijos_h=3 if hijos_h>=3 & hijos_h!=. & sexo==1
replace c_hijos_h=. if regis_ori==.

gen c_hijos=0 if c_hijos_h==0 | c_hijos_m==0
replace c_hijos=1 if c_hijos_h==1 | c_hijos_m==1
replace c_hijos=2 if c_hijos_h==2 | c_hijos_m==2
replace c_hijos=3 if c_hijos_h==3 | c_hijos_m==3

tab c_hijos mes [iw=fex_c_2011] if año==2020

label def c_hijos 0 "Sin hijos" 1 "1 hijo" 2 "2 hijos" 3 "+2 hijos", replace
label values c_hijos c_hijos

* Total children
gen hijos=hijos_h if sexo==1
replace hijos=hijos_m if sexo==2
replace hijos=0 if (hijos_h==. & sexo==1) | (hijos_m==. & sexo==2)
replace hijos=. if regis_ori==.

* Children in household by age range
gen temp=(edad<=3)
replace temp=. if regis_ori==.
bys idhogar: egen niños_0_3=max(temp)
drop temp

label def niños_0_3 0 "No Niños/hogar 0-3 años" 1 "Niños/hogar 0-3 años", replace
label values niños_0_3 niños_0_3

gen temp=(edad>3 & edad<=6)
replace temp=. if regis_ori==.
bys idhogar: egen niños_3_6=max(temp)
drop temp

label def niños_3_6 0 "No Niños/hogar +3-6 años" 1 "Niños/hogar +3-6 años", replace
label values niños_3_6 niños_3_6

gen temp=(edad>7 & edad<=12)
replace temp=. if regis_ori==.
bys idhogar: egen niños_6_12=max(temp)
drop temp

label def niños_6_12 0 "No Niños/hogar +6-12 años" 1 "Niños/hogar +6-12 años", replace
label values niños_6_12 niños_6_12

* +15 year by household
gen unos=1
replace unos=. if regis_ori==.
bys idhogar: egen adult_hogar=sum(unos) if edad>=15 & edad!=.
bys idhogar: egen min=min(adult_hogar)
replace adult_hogar=min
replace adult_hogar=0 if min==.
drop min

* * +15 year by household - females
bys idhogar: egen adult_hogar_m=sum(unos) if edad>=15 & edad!=. & sexo==2
bys idhogar: egen min=min(adult_hogar_m)
replace adult_hogar_m=min
replace adult_hogar_m=0 if min==.
drop min

*  Children in household by age range (Total)

gen temp=1 if edad<=3 & regis_ori!=.
bys idhogar: egen t_niños_0_3=sum(temp)
replace t_niños_0_3=. if regis_ori==.
drop temp

gen temp=1 if edad>3 & edad<=6 & regis_ori!=.
bys idhogar: egen t_niños_3_6=sum(temp)
replace t_niños_3_6=. if regis_ori==.
drop temp

gen temp=1 if edad>6 & edad<=12 & regis_ori!=.
bys idhogar: egen t_niños_6_12=sum(temp)
replace t_niños_6_12=. if regis_ori==.
drop temp

gen temp=1 if edad<=6 & regis_ori!=.
bys idhogar: egen t_niños_0_6=sum(temp)
replace t_niños_0_6=. if regis_ori==.
drop temp

gen t_niños_0_3_pc=t_niños_0_3/adult_hogar
gen t_niños_0_3_pc_m=t_niños_0_3/adult_hogar_m
replace t_niños_0_3_pc=0 if adult_hogar==0
replace t_niños_0_3_pc_m=0 if adult_hogar_m==0

gen t_niños_3_6_pc=t_niños_3_6/adult_hogar
gen t_niños_3_6_pc_m=t_niños_3_6/adult_hogar_m
replace t_niños_3_6_pc=0 if adult_hogar==0
replace t_niños_3_6_pc_m=0 if adult_hogar_m==0

gen t_niños_6_12_pc=t_niños_6_12/adult_hogar
gen t_niños_6_12_pc_m=t_niños_6_12/adult_hogar_m
replace t_niños_6_12_pc=0 if adult_hogar==0
replace t_niños_6_12_pc_m=0 if adult_hogar_m==0

gen t_niños_0_6_pc=t_niños_0_6/adult_hogar
gen t_niños_0_6_pc_m=t_niños_0_6/adult_hogar_m
replace t_niños_0_6_pc=0 if adult_hogar==0
replace t_niños_0_6_pc_m=0 if adult_hogar_m==0

* Education level
rename p6220 ult_titulo

gen 	grupo_educacional=0 if p6210==1 | p6210==2 // ninguno
replace grupo_educacional=0 if p6210==3 & p6210s1<5 // ninguno aunque tiene algunos grados primaria
replace grupo_educacional=1 if p6210==3 & p6210s1==5 // primaria completa
replace grupo_educacional=1 if p6210==4 & p6210s1<9 // primaria completa aunque tiene algunos grados secundaria
replace grupo_educacional=2 if p6210==4 & p6210s1==9 // secundaria completa
replace grupo_educacional=2 if p6210==5 & p6210s1==10 // secundaria completa
replace grupo_educacional=3 if p6210==5 & p6210s1>=11 & p6210s1<=13 // Bachiller completo
replace grupo_educacional=3 if p6210==6 & ult_titulo==2 // Bachiller completo aunque hizo algunos años en superior
replace grupo_educacional=3 if p6210==6 & ult_titulo==4 & p6210s1<4 // Universitaria no completa
replace grupo_educacional=4 if p6210==6 & ult_titulo==3 // Tecnica y tecnologica
replace grupo_educacional=5 if p6210==6 & ult_titulo==4 & p6210s1>=4 // Universitaria
replace grupo_educacional=6 if p6210==6 & ult_titulo==5 // posgrado

label def grupo_educacional 0 "Ninguno" 1 "Primaria" 2 "Secundaria" 3 "Bachiller" 4 "Técnica y tecnológica" 5 "Universitaria" 6 "Posgrado", replace
label values grupo_educacional grupo_educacional

tab grupo_educacional mes if año==2020

* Indicator labor participation
gen pea=(PEA==1)

* Labor status
gen work_status=1 if oci==1
replace work_status=2 if dsi==1
replace work_status=3 if ini==1

label def work_status 1 "Ocupada (o)" 2 "Desocupada (o)" 3 "Inactiva (o)", replace
label values work_status work_status

* Contract type
replace p6460=. if p6460>2
tab p6460 mes if año==2020

rename p6460 tipo_contrato 

label def tipo_contrato 1 "Término indefinido" 2 "Término fijo", replace
label values tipo_contrato tipo_contrato

* Work place
tab p6880
rename p6880 lugar_de_trabajo

replace lugar_de_trabajo=0 if lugar_de_trabajo==1 | lugar_de_trabajo==2
replace lugar_de_trabajo=1 if lugar_de_trabajo==7 | lugar_de_trabajo==3 
replace lugar_de_trabajo=2 if lugar_de_trabajo==4 | lugar_de_trabajo==5 | lugar_de_trabajo==6 | lugar_de_trabajo==11
replace lugar_de_trabajo=3 if lugar_de_trabajo==8 | lugar_de_trabajo==9 | lugar_de_trabajo==10

label def lugar_de_trabajo 0 "En una vivienda" 1 "Local, fábrica y similares"  2 "En la calle, vehículo u otro" 3 "En el area rural, mina o construcción", replace
label values lugar_de_trabajo lugar_de_trabajo

tab lugar_de_trabajo mes if año==2020

gen experiencia=edad-esc-11 if grupo_educacional==0 & edad-esc>5
replace experiencia=edad-esc-7 if grupo_educacional==1 & edad-esc>5
replace experiencia=edad-esc-5 if grupo_educacional==2 & edad-esc>5
replace experiencia=edad-17 if grupo_educacional==3 & edad-esc>5
replace experiencia=edad-20 if grupo_educacional==4 & edad-esc>5
replace experiencia=0 if experiencia<0 & grupo_educacional<=4 & edad-esc>5
replace experiencia=edad-22 if (grupo_educacional==5 | grupo_educacional==6) & edad-esc>5
replace experiencia=0 if experiencia<0 & (grupo_educacional==5 | grupo_educacional==6) & edad-esc>5

tab experiencia mes if año==2020

* Partial-time workers
gen tiempo_parcial=(total_horas_trabajadas_semana<40)
replace tiempo_parcial=. if total_horas_trabajadas_semana==0 | total_horas_trabajadas_semana==.
tab tiempo_parcial sexo

label def tiempo_parcial 1 "Tiempo parcial" 0 "Tiempo completo", replace
label values tiempo_parcial tiempo_parcial

* economic sector

			gen act_eco = .
			
			replace act_eco = . if act_eco_r4 == 0
			replace act_eco = 0 if act_eco_r4 == 1
			replace act_eco = 1 if act_eco_r4 == 2 | act_eco_r4 == 4 | act_eco_r4 == 5
			replace act_eco = 2 if act_eco_r4 == 3
			replace act_eco = 3 if act_eco_r4 == 6
			replace act_eco = 4 if act_eco_r4 == 7
			replace act_eco = 5 if act_eco_r4 == 8 | act_eco_r4 == 10
			replace act_eco = 6 if act_eco_r4 == 9
			replace act_eco = 7 if act_eco_r4 == 11 | act_eco_r4 == 12
			replace act_eco = 8 if act_eco_r4 == 13 | act_eco_r4 == 14
			replace act_eco = 9 if act_eco_r4 == 15
			replace act_eco = 10 if act_eco_r4 == 16 | act_eco_r4 == 17
			replace act_eco = 11 if act_eco_r4 == 18 | act_eco_r4 == 19 | act_eco_r4 == 20 | act_eco_r4 == 21
						

label def sector	0 "Agricultura" ///
			1 "Electricidad, gas, agua y minas" ///
			2 "Industria" ///
			3 "Construcción" ///
			4 "Comercio y reparación vehículos" ///
			5 "Transporte, almacenamiento y comunicaciones" ///
			6 "Alojamiento y servicios de comida" ///
			7 "Actividades financieras e inmobiliarias" ///
			8 "Actividades profesionales y administrativas" ///
			9 "Administración pública" ///
			10 "Educación y Salud humana" ///
			11 "Otras actividades", replace

			
label val act_eco sector
tab act_eco mes [iw= fex_c_2011] if año==2020

* Urban

destring clase1, replace
gen urban=1 if (clase1==1 & año==2020) | urbano==1
replace urban=0 if (clase1==2 & año==2020) | rural==1

label def urban 1 "Urbana" 0 "Rural", replace
label values urban urban

* Estado civil

rename p6070 estado_civil

replace estado_civil=1 if estado_civil>=1 & estado_civil<=3
replace estado_civil=2 if estado_civil>=4 & estado_civil<=6

label def estado_civil 1 "Unión libre y casada(o)" 2 "Separada/divorciada(o), viuda(o) y soltera(o)", replace
label values estado_civil estado_civil

drop g_etarios

		gen g_etarios = 0  if edad < 18							
		replace g_etarios =  1  if edad >=18 & edad <=24	
		replace g_etarios = 2  if edad >=25 & edad <=40
		replace g_etarios = 3  if edad >=41 & edad <=59				
		replace g_etarios = 4  if edad >=60				
		
		label variable g_etarios "Grupos Etarios"
		label define g_etarios 0 "0-18" 1 "18-24" 2 "25-40" 3 "41-59"  4 "+60",replace
		label values g_etarios g_etarios

tab g_etarios

save  "${data}/GEIH_2015_2021_est.dta", replace
