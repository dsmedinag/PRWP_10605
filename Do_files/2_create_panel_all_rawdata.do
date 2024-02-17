********************************************************************************************************
* PRWP 10605: How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery? *
* Data setting
* By Daniel Medina, Maria Davalos, Diana Londoño


        local f_i 2015
        local f_f 2021

* All GEIH
forvalues i = `f_i' / `f_f' {
        
	
use "${data}\${rawdata}\DANE\Annual\GEIH_`i'", clear 

dis "GEIH_`i'"
		
capture replace p6080s1=subinstr(p6080s1,"_","",.)

local vars "p3147s10a1 p7280s1 p7350s1 p7420s7a1 p7482s1 p6360s1 p5090s1 p7240s1 p7140s9a1 p7050s1 p7028s1 p6980s7a1 p6780s1 p6765s1 p6480s1 p6430s1 p6410s1 p6290s1 p6915s1 p6810s1 p7390s1 p1661s4a1 p6880s1 p6830s1 p6830s1 p7458s1 p7450s1 p6310s1 p6240s1"
foreach x of local vars  {
capture drop `x'
}

local vars "mes regis p6980 p6980s1 p7420 p6080s1 rama2d_r4"
foreach x of local vars {
capture destring `x',replace force
}

capture encode fuente,gen(fuenteid)
capture drop fuente 
capture rename fuenteid fuente

compress
save "${data}\${rawdata}\DANE\Annual\Y_`i'.dta", replace
 
}

* All GEIH - MESEP
forvalues i = `f_i' / `f_f' {
        
	
use "${data}\${rawdata}\DANE\Annual\GEIH_MESEP_`i'", clear 

dis "GEIH_MESEP_`i'"
		
capture replace p6080s1=subinstr(p6080s1,"_","",.)

local vars "p3147s10a1 p7280s1 p7350s1 p7420s7a1 p7482s1 p6360s1 p5090s1 p7240s1 p7140s9a1 p7050s1 p7028s1 p6980s7a1 p6780s1 p6765s1 p6480s1 p6430s1 p6410s1 p6290s1 p6915s1 p6810s1 p7390s1 p1661s4a1 p6880s1 p6830s1 p6830s1 p7458s1 p7450s1 p6310s1 p6240s1"
foreach x of local vars  {
capture drop `x'
}

local vars "mes regis p6980 p6980s1 p7420 p6080s1 rama2d_r4"
foreach x of local vars {
capture destring `x',replace force
}

capture encode fuente,gen(fuenteid)
capture drop fuente 
capture rename fuenteid fuente

compress
save "${data}\${rawdata}\DANE\Annual\MESEP_Y_`i'.dta", replace
 
}

* Panel mesep
use "${data}\${rawdata}\DANE\Annual\MESEP_Y_2015", clear

gen año=2015
forval i=2016/2019 {
        dis "MESEP_Y_`i'"

append using "${data}\${rawdata}\DANE\Annual\MESEP_Y_`i'"

replace año=`i' if año==.
}

append using "${data}\${rawdata}\DANE\Annual\MESEP_Y_2021"

replace año=2021 if año==.

destring oficio rama4d_r4 clase area dpto, force replace
append using "${data}\${rawdata}\DANE\Annual\MESEP_Y_2020"

replace año=2020 if año==.

compress

keep directorio secuencia_p hogar año mes orden regis impa isa ie imdi iof1 iof2 ///
iof3h iof6 cclasnr2 cclasnr3 cclasnr4 cclasnr5 cclasnr6 cclasnr7 cclasnr8 cclasnr11 ///
impaes isaes iees imdies iof1es iof2es iof3hes iof3ies iof6es ingtotob ingtotes ingtot ///
 nper npersug ingtotug ingtotugarr ingpcug li lp pobre indigente npobres nindigentes ///
 dscy impa_tot isa_tot ie_tot impaes_t isaes_t iees_t ing_tot_impu p3246 iof3i ing_tot_impu1

save "${data}\GEIH_2015_2021_MESEP", replace


* Panel GEIH - MESEP
use "${data}\${rawdata}\DANE\Annual\Y_2015", clear

gen año=2015
forval i=2016/2019 {
        dis "Y_`i'"

append using "${data}\${rawdata}\DANE\Annual\Y_`i'"

replace año=`i' if año==.
}

append using "${data}\${rawdata}\DANE\Annual\Y_2021"

replace año=2021 if año==.

destring oficio rama4d_r4 clase area dpto, force replace
append using "${data}\${rawdata}\DANE\Annual\Y_2020"

replace año=2020 if año==.

merge 1:1 directorio secuencia_p hogar año mes orden regis using "${data}\GEIH_2015_2021_MESEP", keep(1 3) generate(merge_mesep)

compress

save "${data}\GEIH_2015_2021", replace
