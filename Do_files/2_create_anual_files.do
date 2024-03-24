********************************************************************************************************
* PRWP 10605: How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery? *
* From monthly raw data to repeated cross-sectional panel
* By Daniel Medina, Maria Davalos, Diana Londoño

* GEIH files 2017/2019 and 2021

foreach k of numlist 2017/2019 2021 {

local meses "Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre"

	foreach x of local meses {

	local tipo "Cabecera Resto"
		foreach m of local tipo {
		fs "$data/$rawdata/`k'/`x'.dta/`m'*"

		* Merging files from each year folder
		local i=1 
			foreach f in `r(files)' {

				if `i'==1 {
				use "${data}/${rawdata}/`k'/`x'.dta/`f'", clear
				dis as red "`f'"
				}

				else {
				dis as red "`f'"

					if regexm("`f'", "vivienda")!=1 {
					merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${data}/${rawdata}/`k'/`x'.dta/`f'", nogen
					}

					else  {
					merge m:1 DIRECTORIO SECUENCIA_P using "${data}/${rawdata}/`k'/`x'.dta/`f'", nogen
					}
				
				}

			local i=`i'+1
			}
				
		foreach v of varlist _all {
		capture rename `v', lower
			if c(rc) != 0 {
			 local newname: permname `=lower("`v'")'
			 label var `v' `"RENAME of `v' (`:var label `v'')
			rename `v' `newname'
			}
		}
	
	capture mkdir "${data}/${rawdata}/All/`k'"
	save "${data}/${rawdata}/All/`k'/`x'_`m'",replace
		}
	}
	
		* Append monthly data
		local j=1
		foreach y of local meses {
			if `j'==1 {
			use "${data}/${rawdata}/All/`k'/`y'_Cabecera", clear
			append using "${data}/${rawdata}/All/`k'/`y'_Resto"
			}

			else {
			append using "${data}/${rawdata}/All/`k'/`y'_Cabecera"
			append using "${data}/${rawdata}/All/`k'/`y'_Resto"
			}

		local j=`j'+1
		}
		
	* Drop variables unused
		
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

		local vars "oficio clase dpto rama4d_r4 area"
		foreach z of local vars  {
		capture destring `z', force replace 
		}

	compress
	
* Merge sector code rev 4 for 2015/2019
local ciiu=`k'-2000
			gen SECUENCIA_P=secuencia_p
			gen DIRECTORIO=directorio
			gen ORDEN=orden
			
			merge 1:1 SECUENCIA_P DIRECTORIO ORDEN using "$data/$rawdata/`k'/CIIU `ciiu'.dta", keep(1 3) nogen
			drop SECUENCIA_P DIRECTORIO ORDEN

save "${data}/${rawdata}/Annual/Y_`k'.dta", replace
		
}

* GEIH files 2020

foreach k of numlist 2020  {

dis "GEIH_`k'"
	
local meses "Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre"

	local t=0
	foreach x of local meses {
	local t=`t'+1
	local z="`t'.`x'"
	fs "$data/$rawdata/`k'/`z'/DTA/*"

		local i=1 
		foreach f in `r(files)' {

		if `i'==1 {
		use "${data}/${rawdata}/`k'/`z'/DTA/`f'", clear
		dis as red "`f'"
		}

		else {
		dis as red "`f'"

			if regexm("`f'", "vivienda")!=1 {
			merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${data}/${rawdata}/`k'/`z'/DTA/`f'", nogen
			}

			else  {
			merge m:1 DIRECTORIO SECUENCIA_P using "${data}/${rawdata}/`k'/`z'/DTA/`f'", nogen
			}
		}

		local i=`i'+1
		}

	foreach v of varlist _all {
    capture rename `v', lower
		if c(rc) != 0 {
        local newname: permname `=lower("`v'")'
        label var `v' `"RENAME of `v' (`:var label `v'')
        rename `v' `newname'
		}
	}

capture mkdir "${data}/${rawdata}/All/`k'"
save "${data}/${rawdata}/All/`k'/`x'",replace
}

	* Append monthly data
	local j=1
	foreach y of local meses {

	if `j'==1 {
	use "${data}/${rawdata}/All/`k'/`y'", clear
	}

	else {
	append using "${data}/${rawdata}/All/`k'/`y'" 	
	}

	local j=`j'+1
}
	
capture replace p6080s1=subinstr(p6080s1,"_","",.)

* Drop variables unused

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

	local vars "oficio clase dpto rama4d_r4 area"
	foreach z of local vars  {
	capture destring `z', force replace 
	}

compress

save "${data}/${rawdata}/Annual/Y_`k'.dta", replace
}


* MESEP files

forval y=2015/2021 {
dis "GEIH_MESEP_`y'"

use "${data}/${rawdata}/MESEP/`y'/Personas", clear 
merge m:1 directorio secuencia_p mes using "${data}/${rawdata}/MESEP/`y'/Hogares", nogen

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

	local vars "oficio clase dpto rama4d_r4 area"
	foreach z of local vars  {
	capture destring `z', force replace 
	}

compress
save "${data}/${rawdata}/Annual/MESEP_Y_`y'.dta", replace

}


* Panel MESEP
use "${data}/${rawdata}/Annual/MESEP_Y_2015", clear

gen año=2015
forval i=2016/2021 {
        dis "MESEP_Y_`i'"

append using "${data}/${rawdata}/Annual/MESEP_Y_`i'"

replace año=`i' if año==.
}

keep directorio secuencia_p año mes orden impa isa ie imdi iof1 iof2 iof3h iof3i iof6 cclasnr2 cclasnr3 cclasnr4 cclasnr5 cclasnr6 cclasnr7 cclasnr8 cclasnr11 impaes isaes iees imdies iof1es iof2es iof3hes iof3ies iof6es ingtotob ingtotes ingtot nper npersug ingtotug ingtotugarr ingpcug li lp pobre indigente npobres nindigentes
compress

save "${data}/GEIH_2015_2021_MESEP", replace


* Panel GEIH - MESEP
use "${data}/${rawdata}/Annual/Y_2015", clear

gen año=2015
forval i=2016/2021 {
        dis "Y_`i'"

append using "${data}/${rawdata}/Annual/Y_`i'"

replace año=`i' if año==.
}

merge 1:1 directorio secuencia_p año mes orden using "${data}/GEIH_2015_2021_MESEP", keep(1 3) generate(merge_mesep)

compress

replace area=. if area>76 & area<99


sum fex_c_2011 if año==2020
capture noisily replace fex_c_2011=fex_c if año==2020 & r(N)==0

save "${data}/GEIH_2015_2021", replace
