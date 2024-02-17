********************************************************************************************************
* PRWP 10605: How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery? *
* Get annual files from raw data
* By Daniel Medina, Maria Davalos, Diana Londoño

* GEIH files
forval k=2015/2021  {
local meses "Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre"

foreach x of local meses {

cd "${rawdata}\zip_dane\`x'\DTA"

fs * 

local i=1 
foreach f in `r(files)' {

if `i'==1 {
use "`f'", clear
}


else {
	
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN HOGAR using "`f'", nogen
	
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



tab p6020 mes

capture mkdir "${rawdata}\DANE\`k'"
save "${rawdata}\DANE\`k'\`x'",replace
}

cd "${rawdata}\DANE\`k'\"

local j=1
foreach y of local meses {

if `j'==1 {

use "`y'", clear
	
}

else {

append using `y' 	
	
}

local j=`j'+1
}

compress


save "${rawdata}\DANE\Annual\GEIH_`k'", replace

}

* MESEP files
forval y=2015/2021 {
dis "GEIH_MESEP_`y'"

use "${data}\${rawdata}\DANE\MESEP\`y'\Personas", clear 

compress

save "${data}\${rawdata}\DANE\Annual\GEIH_MESEP_`y'", clear	
}

cd "Put here project directory"
