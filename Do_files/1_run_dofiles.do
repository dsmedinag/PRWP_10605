********************************************************************************************************
* PRWP 10605: How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery? *
* Run all do-files
* By Daniel Medina, Maria Davalos, Diana Londoño

* Graph style setting

graph set window fontface "Times New Roman"

set scheme s1color
grstyle init
grstyle set legend 6, nobox 
grstyle set symbolsize large
grstyle set graphsize 6cm 7cm
grstyle color p1  "0 159 218" // light blue
grstyle color p2  "0 34 68" // dark blue
grstyle color p3  "165 165 165" // grey
grstyle color p4  "34 94 168" // blue
grstyle color p5 "115 115 115" // dark grey
grstyle anglestyle vertical_tick horizontal

* Directories
cd "Put here project directory"
global data "Data"
global rawdata "Raw_data"
global dofiles "Do_files"
global temp_files "Data\Temps"
global dir_tables "Tables"
global graphs "Graphs"
global probit "Data\Probit" 

* Making folders
capture mkdir "${data}/${rawdata}/All"
capture mkdir "${data}/${rawdata}/Annual"

capture mkdir "$temp_files"
capture mkdir "$dir_tables"
capture mkdir "$graphs"
capture mkdir "$probit"

* Run do-files
log using "$data/run_all.smcl", replace

display as red "$S_TIME - 1st dofile"
do "${dofiles}/2_create_anual_files"

display as red "$S_TIME - 3st dofile"
do "${dofiles}/3_cod_general_variables_WB"

display as red "$S_TIME - 4nd dofile"
do "${dofiles}/4_key_variables"

display as red "$S_TIME - 5rd dofile"
do "${dofiles}/5_graphs_1_20"

display as red "$S_TIME - 6th dofile"
do "${dofiles}/6_table_2"

display as red "$S_TIME - 7th dofile"
do "${dofiles}/7_set_data_est"

display as red "$S_TIME - 8th dofile"
do "${dofiles}/8_tables_3_5"

display as red "$S_TIME - 9th dofile"
do "${dofiles}/9_graphs_21_32"


local files : dir "${temp_files}" files "*.dta"

dis `files'
foreach file of local files {
	erase "${temp_files}/`file'"
}

log close
