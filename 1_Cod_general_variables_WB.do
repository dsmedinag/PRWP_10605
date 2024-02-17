********************************************************************************************************
* PRWP 10605: How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery? *
* Standard variables - World Bank Team
* By Daniel Medina, Maria Davalos, Diana Londoño

/*
This is a code to create standard variables from the database. 
We used this code in some WB projects and we ran it in this package 
to follow the initial rutine of the first research moments.  

You can consult the following repository for more information:
https://github.com/ccsaninc/worldbank_colombia
*/

use "${data}\GEIH_2015_2021", clear

* Key variables 

	*- Características generales

		*- Creación de la variable de población Total -*		
			
		gen pobtot = 1
		label var pobtot "Poblacion Total"
			
		*- Generación de la variable sexo -*
			
		gen sexo = .
		replace sexo = 1 if p6020 ==1 
		replace sexo = 2 if p6020 ==2
			
		label var sexo "Hombre / Mujer"
		label define sexo 1 "S1" 2 "S2"
		label values sexo sexo
		
		*- Edad de la persona -*	

		gen edad = p6040
		label var edad "Edad de la persona"
		
		* Definición de Grupos Etarios -*
	
		gen g_etarios = 0  if edad <= 17							
		replace g_etarios =  1  if edad >=18 & edad <=28	
		replace g_etarios = 2  if edad >=29 & edad <=59
		replace g_etarios = 3  if edad >=60 				
		
		label variable g_etarios "Grupos Etarios"
		label define g_etarios 0 "GE_0" 1 "GE_1" 2 "GE_2" 3 "GE_3" 
		label values g_etarios g_etarios

*- Identificación de filtro de Coberturas
				
		* -- Creación de la variable Total Nacional -- *	

		gen total_nal = 1
		label var total_nal "Total Nacional"
		label define total_nal 1 "C001"
		label values total_nal total_nal
		
		* -- Urbano -- *		

		gen urbano = 1 if clase == 1
		label var urbano "Zonas Urbanas"
		label define urbano 1 "C002"
		label values urbano urbano
		
		
		* -- Rural -- *		

		gen rural = 1 if clase == 2
		label var rural "Zonas Rurales"
		label define rural 1 "C005"
		label values rural rural
		
		*- Dummy 13 ciuades 
				
		gen ciudad13=1 if area == 5 | area == 8 | area == 11 | area == 13 | area == 17 | ///
		area == 23 | area == 50 | area == 52 | area == 54 | area == 66 | area == 68 | area == 73 | area == 76
		
		label var ciudad13 "Areas Metropolitanas"
		label define ciudad13 1 "C003"
		label values ciudad13 ciudad13
		
		*- Dummy 23 ciuades
		
		generate ciudad23 = 1 if area == 5 | area == 8 | area == 11 | area == 13 | area == 15 | area == 17 | area == 18 | area == 19 | area == 20 ///
		| area == 23 | area == 27 | area == 41 | area == 44 | area == 47 | area == 50 | area == 52 | area == 54 | area == 63 | area == 66 | area == 68 ///
		| area == 70 | area == 73 | area == 76 |area == 81 | area == 85 | area == 86 | area == 88 | area == 91 | area == 94 | area == 95 | area == 97 ///
		| area == 99
				
		label var ciudad23 "23 ciudades"	
		label define ciudad23 1 "C004"
		label values ciudad23 ciudad23
	
		*- Areas metropolitanas -*
							
				gen ciudad= .
				replace ciudad=1 if area==5
				replace ciudad=2 if area==8
				replace ciudad=3 if area==11
				replace ciudad=4 if area==13
				replace ciudad=5 if area==15
				replace ciudad=6 if area==17
				replace ciudad=7 if area==18
				replace ciudad=8 if area==19
				replace ciudad=9 if area==20
				replace ciudad=10 if area==23
				replace ciudad=11 if area==27
				replace ciudad=12 if area==41
				replace ciudad=13 if area==44
				replace ciudad=14 if area==47
				replace ciudad=15 if area==50
				replace ciudad=16 if area==52
				replace ciudad=17 if area==54
				replace ciudad=18 if area==63
				replace ciudad=19 if area==66
				replace ciudad=20 if area==68
				replace ciudad=21 if area==70
				replace ciudad=22 if area==73
				replace ciudad=23 if area==76
				replace ciudad=24 if area==81
				replace ciudad=25 if area==85
				replace ciudad=26 if area==86
				replace ciudad=27 if area==88
				replace ciudad=28 if area==91
				replace ciudad=29 if area==94
				replace ciudad=30 if area==95
				replace ciudad=31 if area==97
				replace ciudad=32 if area==99
		
		label var ciudad "Areas GEIH"
		label define ciudad 1 "A_05" 2 "A_08" 3 "A_11" 4 "A_13" 5 "A_15" 6 "A_17" 7 "A_18" 8 "A_19" 9 "A_20" 10 "A_23" 11 "A_27" 12 "A_41" 13 "A_44" 14 "A_47" 15 "A_50" 16 "A_52" 17 "A_54" 18 "A_63" 19 "A_66" 20 "A_68" 21 "A_70" 22 "A_73" 23 "A_76" 24 "A_81" 25 "A_85" 26 "A_86" 27 "A_88" 28 "A_91" 29 "A_94" 30 "A_95" 31 "A_97" 32 "A_99"
		label values ciudad ciudad
				

			*Edad quinquenios del Dane
			
			gen quin_DANE =.
			replace quin_DANE =0 if p6040<5	
			replace quin_DANE =1 if p6040>=5 & p6040<=10
			replace quin_DANE =2 if p6040>=11 & p6040<=20
			replace quin_DANE =3 if p6040>=21 & p6040<=30
			replace quin_DANE =4 if p6040>=31 & p6040<=40
			replace quin_DANE =5 if p6040>=41 & p6040<=50
			replace quin_DANE =6 if p6040>=51 & p6040<=60
			replace quin_DANE =7 if p6040>=61 & p6040<=70
			replace quin_DANE =8 if p6040>=71 & p6040<=80
			replace quin_DANE =9 if p6040>=81 & p6040<=90
			replace quin_DANE =10 if p6040>=91 & p6040<=100
			replace quin_DANE =11 if p6040>100

			lab define quin_DANE 0 "Q_0" 1 "Q_1" 2 "Q_2" 3 "Q_3" 4 "Q_4" 5 "Q_5" 6 "Q_6" 7 "Q_7" 8 "Q_8" 9 "Q_9" 10 "Q_10" 11 "Q_11" 
			lab values quin_DANE quin_DANE 	
			
			
*- Indicadores de mercado de trabajo -*
	
		*- Ocupados -*

		gen OC = .
			
		replace OC = 1 if p6240 == 1
			replace OC = 1 if p6250 == 1
			replace OC = 1 if p6260 == 1
			replace OC = 1 if p6270 == 1
		   
		label var OC "Personas Ocupadas"
		label define OC 1"D_01"
		label values OC OC
		
		*- Desocupados -*

		gen DS = .
			
			replace DS = 1 if p6351 == 1

		label var DS "Personas Desocupadas"
		label define DS 1 "D_02"
		label values DS DS

		*- Inactivos -*

		gen Ini = .
			
			replace Ini = 1 if p6240 == 5 
			replace Ini = 1 if p6300 == 2
			replace Ini = 1 if p6310 == 9 | p6310 == 10 | p6310 == 11 | p6310 == 12 | p6310 == 13
			replace Ini = 1 if p6330 == 2
			replace Ini = 1 if p6340 == 2
			replace Ini = 1 if p6351 == 2    

		label var Ini "Personas Inactivas"
		label define Ini 1 "D_03"
		label values Ini Ini

		*- Poblacion de Economicamente Activa (PEA) -*
			
		gen PEA =.
		
			replace PEA =1 if DS==1
			replace PEA =1 if OC==1 
					
		lab var PEA  "Poblacion Economicamente Activa"
		label define PEA  1 "D_04"
		label values PEA  PEA 
		
		*- Poblacion en edad de Trabajar (PET) -*
			
		gen PET =.						
		
			replace PET =1 if PEA ==1
			replace PET =1 if Ini==1

		lab var PET  "Poblacion Edad de Trabajar"
		label define PET 1 "D_05"
		label values PET PET
		
		gen PET_No = .
		
			replace PET_No = 1 if PET !=1
			
		lab var PET_No " NO Poblacion Edad de Trabajar	"
		label define PET_No 1 "D_06"
		label values PET_No PET_No
		
		gen POB = .
		
			replace POB = 1 
			
		lab var POB  "Poblacion"
		label define POB 1 "D_00"
		label values POB POB
			
*------- TIPOS DE OCUPADOS ---------------------------------------*

		**Tipos de Ocupados: Asalariados, Cuenta propia, empleados domesticos y otros....

		gen tip_ocu=1 if  p6430==1 | p6430==2 
		replace tip_ocu=2 if p6430==4 
		replace tip_ocu=3 if p6430==3 
		replace tip_ocu=4 if p6430!=. & tip_ocu==.
		 
		lab define tip_ocu 1 "POC_OC_0" 2 "POC_OC_1" 3 "POC_OC_2" 4 "POC_OC_3"
		lab values tip_ocu tip_ocu

*------- Tiene algun tipo de contrato ---------------------------------------*

		**Tipos de Ocupados: Asalariados, Cuenta propia, empleados domesticos y otros....

		gen cont_trab = .
		replace  cont_trab = 1 if p6440 == 1 
		
		lab var cont_trab "Contrato Laboral"
		lab define cont_trab 1 "Con contraro"
		lab values cont_trab cont_trab
		
*------- Calculo de los NINIS ---------------------------------------*
		
		gen ninis = .
		replace ninis = 1 if (DS == 1 | Ini == 1) & p6170==2

*------- CALCULO DE INGRESOS ------------------------------------*

	**Remuneraciones-Ingresos**
	*El ingreso laboral se compone del ingreso por la primera actividad + el ingreso por la segunda actividad. Para el cálculo debes tener en cuenta si son asalariados o independientes. 
	*Ingreso laboral de los independientes es: Ingreso primera actividad + (P550/12) + P7070

			*Ingreso asalariado
			
			destring  p6500 p6585s1a1 p6585s2a1 p6585s3a1 p6585s4a1 p6510s1 p6630s4a1 p6580s1 p7070, replace 
			gen salario=p6500
			replace p6585s1a1=. if p6585s1a1==98
			replace p6585s2a1=. if p6585s2a1==98
			replace p6585s3a1=. if p6585s3a1==98
			replace p6585s4a1=. if p6585s4a1==98

			egen subsidios=rowtotal(p6585s1a1 p6585s2a1 p6585s3a1 p6585s4a1)
			gen horasextras=p6510s1 if  p6510s2==2
			replace horasextras=. if horasextras==98
			replace horasextras=. if horasextras==99

			*Ingreso Final Asalariados correspondiente a la ocupacion primaria
			
			egen ing_asalariado= rowtotal(salario subsidios horasextras)
			
			*Ingreso cuenta propia
			
			gen salariocc=p6750/p6760 
			gen ganancia=p550/12 
			egen ing_cuentapropia= rowtotal(salariocc ganancia)

				/*
				gen salario2cc=p7070 if cuenta_propia==1
				*/


			*Ingreso laboral final ocupados
			gen ing_laboral=ing_cuentapropia
			replace ing_laboral=ing_asalariado if ing_laboral==0 

			*Horas laboradas por asalariados y/o cuenta propia
			
			**Horas totales 
				
				destring p6800, replace
				gen horas_totales=p6800*4
				replace horas_totales=0 if horas_totales==. | horas_totales<0 | horas_totales>600
			
			*horas extras
			
				destring p6640s1, replace
				replace p6640s1=0 if p6640s1>100
				gen horas_extras=p6640s1*4
				replace horas_extras=0 if horas_extras==. | horas_extras<0 | horas_extras>100 
				egen total_horas_trabajadas=rowtotal(horas_totales horas_extras)
				*672 horas es lo máximo que podrías trabajar una persona al mes (24*7*4) por lo tanto se hará el supuesto de que el máximo de horas que una persona puede trabajar al día no supera las 20 horas.
				gen horas_diarias=total_horas_trabajadas/30
				keep if horas_diarias<=20
				
				gen total_horas_trabajadas_semana = total_horas_trabajadas/4
				

			*Ingreso por hora trabajada
			
				gen ing_total_hora=ing_laboral/total_horas_trabajadas
				replace ing_total_hora=0 if ing_total_hora==.
				
			
			*- Tipo de Contrato -*
		
				gen per_contrato = .
				replace per_contrato = 1 if p6450 == 1 
				replace per_contrato = 2 if p6450 == 2
				
				label var per_contrato "Contrato a termino indefinido o definido"
				label define per_contrato 1 "Indefinido" 2 "Fijo"
				label values per_contrato per_contrato
							
			*- Tipo de Contrato -*
		
				gen tp_contrato = .
				replace tp_contrato = 1 if p6460 == 1 
				replace tp_contrato = 2 if p6460 == 2
				
				label var tp_contrato "Tipo de contrato (verbal / escrito)"
				label define tp_contrato 1 "Verbal" 2 "Escrito"
				label values tp_contrato tp_contrato
			
			******* Generar la variable de actividad economica - Documentos DANE Rev 4 *****************
			
			destring rama2d_r4, replace
		
			gen act_eco_r4 = .
			
			replace act_eco_r4 = 0 if rama2d_r4 == 0
			replace act_eco_r4 = 1 if rama2d_r4 >= 1 & rama2d_r4 <= 3
			replace act_eco_r4 = 2 if rama2d_r4 >= 5 & rama2d_r4 <= 9
			replace act_eco_r4 = 3 if rama2d_r4 >= 10 & rama2d_r4 <= 33
			replace act_eco_r4 = 4 if rama2d_r4 == 35
			replace act_eco_r4 = 5 if rama2d_r4 >= 36 & rama2d_r4 <= 39
			replace act_eco_r4 = 6 if rama2d_r4 >= 41 & rama2d_r4 <= 43
			replace act_eco_r4 = 7 if rama2d_r4 >= 45 & rama2d_r4 <= 47
			replace act_eco_r4 = 8 if rama2d_r4 >= 49 & rama2d_r4 <= 53
			replace act_eco_r4 = 9 if rama2d_r4 >= 55 & rama2d_r4 <= 56
			replace act_eco_r4 = 10 if rama2d_r4 >= 58 & rama2d_r4 <= 63
			replace act_eco_r4 = 11 if rama2d_r4 >= 64 & rama2d_r4 <= 66
			replace act_eco_r4 = 12 if rama2d_r4 == 68
			replace act_eco_r4 = 13 if rama2d_r4 >= 69 & rama2d_r4 <= 75
			replace act_eco_r4 = 14 if rama2d_r4 >= 77 & rama2d_r4 <= 82
			replace act_eco_r4 = 15 if rama2d_r4 == 84
			replace act_eco_r4 = 16 if rama2d_r4 == 85
			replace act_eco_r4 = 17 if rama2d_r4 >= 86 & rama2d_r4 <= 88
			replace act_eco_r4 = 18 if rama2d_r4 >= 90 & rama2d_r4 <= 93
			replace act_eco_r4 = 19 if rama2d_r4 >= 94 & rama2d_r4 <= 96
			replace act_eco_r4 = 20 if rama2d_r4 >= 97 & rama2d_r4 <= 98
			replace act_eco_r4 = 21 if rama2d_r4 == 99
			
			replace act_eco_r4 = . if rama2d_r4 == .
			
			lab var act_eco_r4 "Actividad economica Rev. 4" 
			
			label define act_eco_r4 0 "No informa" 1 "SECCIÓN A - Agricultura, Ganadería, Caza, Silvicultura Y Pesca" ///
			2 "SECCIÓN B - Explotación De Minas Y Canteras" 3 "SECCIÓN C - Industrias Manufactureras" ///
			4 "SECCIÓN D - Suministro De Electricidad, Gas, Vapor Y Aire Acondicionado" ///
			5 "SECCIÓN E - Distribución De Agua; Evacuación Y Tratamiento De Aguas Residuales, Gestión De Desechos Y Actividades De Saneamiento Ambiental" ///
			6 "SECCIÓN F - Construcción" 7 "SECCIÓN G - Comercio Al Por Mayor Y Al Por Menor; Reparación De Vehículos Automotores Y Motocicletas" ///
			8 "SECCIÓN H - Transporte Y Almacenamiento" 9 "SECCIÓN I - Alojamiento Y Servicios De Comida" ///
			10 "SECCIÓN J - Información Y Comunicaciones" 11 "SECCIÓN K - Actividades Financieras Y De Seguros" ///
			12 "SECCIÓN L - Actividades Inmobiliarias" 13 "SECCIÓN M - Actividades Profesionales, Científicas Y Técnicas" ///
			14 "SECCIÓN N - Actividades De Servicios Administrativos Y De Apoyo" ///
			15 "SECCIÓN O - Administración Pública Y Defensa; Planes De Seguridad Social De Afiliación Obligatoria" ///
			16 "SECCIÓN P - Educación" 17 "SECCIÓN Q - Actividades De Atención De La Salud Humana Y De Asistencia Social" ///
			18 "SECCIÓN R  - Actividades Artísticas, De Entretenimiento Y Recreación" 19 "SECCIÓN S - Otras Actividades De Servicios" ///
			20 "SECCIÓN T  - Actividades De Los Hogares Individuales En Calidad De Empleadores; Actividades No Diferenciadas De Los Hogares Individuales Como Productores De Bienes Y Servicios Para Uso Propio" ///
			21 "SECCIÓN U - Actividades De Organizaciones Y Entidades Extraterritoriales "
			label values act_eco_r4 act_eco_r4
			
			
			*- Agrupacion de actividades DANE
			
			gen act_eco_r4_DANE = .
			
			replace act_eco_r4_DANE = 0 if act_eco_r4 == 0
			replace act_eco_r4_DANE = 1 if act_eco_r4 == 1
			replace act_eco_r4_DANE = 2 if act_eco_r4 == 2
			replace act_eco_r4_DANE = 3 if act_eco_r4 == 3
			replace act_eco_r4_DANE = 4 if act_eco_r4 == 4 | act_eco_r4 == 5
			
			replace act_eco_r4_DANE = 5 if act_eco_r4 == 6
			replace act_eco_r4_DANE = 6 if act_eco_r4 == 7
			replace act_eco_r4_DANE = 7 if act_eco_r4 == 9
			replace act_eco_r4_DANE = 8 if act_eco_r4 == 8
			replace act_eco_r4_DANE = 9 if act_eco_r4 == 10
			replace act_eco_r4_DANE = 10 if act_eco_r4 == 11
			replace act_eco_r4_DANE = 11 if act_eco_r4 == 12
			replace act_eco_r4_DANE = 12 if act_eco_r4 == 13 | act_eco_r4 == 14
			replace act_eco_r4_DANE = 13 if act_eco_r4 == 15 | act_eco_r4 == 16 | act_eco_r4 == 17
			replace act_eco_r4_DANE = 14 if act_eco_r4 == 18 | act_eco_r4 == 19 | act_eco_r4 == 20 | act_eco_r4 == 21
			
			lab var act_eco_r4_DANE "Actividad economica Rev. 4 Clasf. DANE"
			
			label define act_eco_r4_DANE 0 "AE_1" 1 "AE_2" 2 "AE_3" 3 "AE_4" 4 "AE_5" 5 "AE_6" 6 "AE_7" 7 "AE_8" 8 "AE_9" 9 "AE_10" 10  "AE_11" 11 "AE_12" 12 "AE_13" 13 "AE_14" 14 "AE_15"

			label values act_eco_r4_DANE act_eco_r4_DANE
			
				
	*- Definicion de Informalidad DANE -*

		*- Definicion de profesionales -*

		destring oficio, replace

		gen profesional = .
		replace profesional = 0 if oficio >= 21 | oficio == 0 
		replace profesional = 1 if oficio >= 1 & oficio <= 20
		replace profesional = . if oficio == .

		lab var profesional "Profesionales / No profesionales"
		label define profesional 0 "NO Profesional" 1 "Profesional" 
		label values profesional profesional
		
		*----- Definicion del numero de personas por empresa ---*

		gen empresas_5 = .
		replace empresas_5 = 0 if p6870 >= 1 & p6870 <= 3
		replace empresas_5 = 1 if p6870 >= 4 & p6870 <= 9
		replace empresas_5 = . if p6870 == .

		lab var empresas_5 "Empresas con menor de 5 personas"
		label define empresas_5 0 "Menos de 5" 1 "Mas de 5"
		label values empresas_5 empresas_5
		
		*----- Definicion de variable asalariados privados de 5 o menos trabajadores ----*

		gen poc_ocu_infor_DANE = .
		replace poc_ocu_infor_DANE = 1 if empresas_5 ==0 & p6430 == 1 						// Empleado particular 
		replace poc_ocu_infor_DANE = 2 if empresas_5 ==0 & p6430 == 3 						// Empleado domestico
		replace poc_ocu_infor_DANE = 3 if empresas_5 ==0 & p6430 == 4 & profesional != 1 	// Cuenta propia con 5 trabajadores o menos con exepcion de los profesionales
		replace poc_ocu_infor_DANE = 4 if empresas_5 ==0 & p6430 == 5  						// Patron 
		replace poc_ocu_infor_DANE = 5 if empresas_5 ==0 & p6430 == 6 						// Trabajador familiar sin remuneracion
		replace poc_ocu_infor_DANE = 6 if empresas_5 ==0 & p6430 == 7						// Trabajador sin remuneracion 
		replace poc_ocu_infor_DANE = 7 if empresas_5 ==0 & p6430 == 8						// Peon
				
		*---- Categorias especiales --------*
	
		replace poc_ocu_infor_DANE = 8 if empresas_5 ==0 & p6430 == 2
		replace poc_ocu_infor_DANE = 9 if empresas_5 ==0 & p6430 == 9
	
		*--- Fin Categorias Especiales -----*
		
		replace poc_ocu_infor_DANE = . if empresas_5 == . & p6430 == .

		lab var poc_ocu_infor_DANE "Informalidad deficion DANE por Ocupacion"
		label define poc_ocu_infor_DANE 1 "Asalariado" 2 "Empleado Domestico" 3 "Cuenta Propia" 4 "Patron" 5 "TFSR" 6 "TFR" 7 "Peon" 8 "Empelado Gobierno" 9 "Otro"
		label values poc_ocu_infor_DANE poc_ocu_infor_DANE 

		* ----- Definicion de la informalidad total ----*

		gen infor_DANE_total = .
		replace infor_DANE_total = 1 if poc_ocu_infor_DANE ==1 | poc_ocu_infor_DANE ==2 | poc_ocu_infor_DANE ==3 | poc_ocu_infor_DANE ==4 | poc_ocu_infor_DANE ==5 | poc_ocu_infor_DANE ==6 | poc_ocu_infor_DANE ==7

		lab var infor_DANE_total "Informalidad total deficion DANE "
		label define infor_DANE_total 1 "Informal" 0 "Formal" 
		label values infor_DANE_total infor_DANE_total 
		
		* ----- Definicion de formales y no formales -----*

		gen Informalidad_DANE = .
		replace Informalidad_DANE = 0 if oci == 1 & infor_DANE_total != 1 
		replace Informalidad_DANE = 1 if oci == 1 & infor_DANE_total == 1
				
		lab var Informalidad_DANE "Formales y No Formales"
		label define Informalidad_DANE 0 "For_DANE_0" 1 "Inf_DANE_1" 
		label values Informalidad_DANE Informalidad_DANE
		
	
*- Definicion de Informalidad deaceurdo a las AFP -*

		*- Definion de Formales y no Formales por pension -*

		gen Informalidad_AFP = .
		replace Informalidad_AFP = 0 if p6920 == 1 
		replace Informalidad_AFP = 1 if p6920 == 2
		replace Informalidad_AFP = . if p6920 == .
		
		lab var Informalidad_AFP "Informalidad deficion AFP" 
		label define Informalidad_AFP 0 "For_SS_0" 1 "Inf_SS_1"
		label values Informalidad_AFP Informalidad_AFP
		
*- Definicion de Informalidad deaceurdo a las Salud -*

		*- Definion de Formales y no Formales por pension -*

			gen no_salud=1 if (p6100==9 | p6100==.)
			recode no_salud .=0

			gen no_pension=1 if (p6920==2 | p6920==.)
			recode no_pension .=0

			gen Informalidad_Salud = 1 if no_salud==1 & no_pension==1 & oci==1
			replace Informalidad_Salud = 0 if no_salud==0 & no_pension==0 & oci==1
			replace Informalidad_Salud = 1 if (no_salud==1 & oci==1) | (no_pension==1 & oci==1)

		lab var Informalidad_Salud "Informalidad deficion Salud" 
		label define Informalidad_Salud 0 "For_Salud_0" 1 "Inf_Salud_1" 
		label values Informalidad_Salud Informalidad_Salud	
	
	local vars "oficio1 oficio2 rama4d_d_r4 rama2d_d_r4 raband rama4d rama2d rama4d_d rama2d_d rama4dp8 rama2dp8"
	foreach x of local vars {
	capture destring `x',replace force
	}

	capture encode fuente,gen(fuenteid)
	capture drop fuente 
	capture rename fuenteid fuente

compress	
	
save "${data}/GEIH_2015_2021_wb", replace
