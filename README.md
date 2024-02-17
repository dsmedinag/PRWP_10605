# Reproducibility packages of Policy Research Working Paper-10605: 

'How Have Gender Gaps in the Colombian Labor Market Changed during the Economic Recovery?' by Dávalos, María E; Londoño, Diana; Medina, Daniel.

Free access: [http://hdl.handle.net/10986/40639]

The code in this replication package constructs the analysis file from the Great Integrated Household Survey (GEIH, Spanish acronyms) using Stata 15. The do-files run all of the code to generate the data for figures 1 to 34 and tables 2 to 5 in the paper. Approximate time needed to reproduce the analyses on a standard 2021 desktop machine: 3-5 hours.

All data used in this work are publicly available through the web pages of the entities that hold the information. Our main source is the Departamento Administrativo Nacional de Estadística-DANE: [www.dane.gov.co]. Terms and conditions of use: [https://www.dane.gov.co/index.php/servicios-al-ciudadano/tramites/ayudas-de-navegabilidad/politica-de-uso]

Because our work requires comparing results over time from 2015 to 2021 and using information from the Mission for the Splicing of the Employment, Poverty, and Inequality Series (MESEP) as a source for labor income variables, we use the 2005 frame GEIH data between 2015 and 2021. 

The full dataset and documentation of GEIH can be downloaded from [https://microdatos.dane.gov.co/index.php/catalog/MERCLAB-Microdatos]. We obtain the GEIH microdata for each year from the 'Mercado Laboral' collection. For example, to download the year 2015, the label with which the information is identified is 'Gran Encuesta Integrada de Hogares - GEIH - 2015'. 

In the same repository, you can find the full dataset and documentation of 'Medición de Pobreza Monetaria y Desigualdad' from the Mission for the Splicing of the Employment, Poverty, and Inequality Series (MESEP). It can be downloaded from [https://microdatos.dane.gov.co/index.php/catalog/POBCONVID]. We obtain the microdata for each year from the 'Pobreza y Condiciones de Vida' collection. For example, to download the year 2015, the label with which the information is identified is 'Medición de Pobreza Monetaria y Desigualdad - 2015'.

The consumer price index used to deflate income variables is downloaded from the Banco de la República website [https://www.banrep.gov.co/es/estadisticas/indice-precios-consumidor-ipc].

The information on vacancies corresponds to the 'ofertas laborales' reported by the Public Employment Service (SPE, Spanish acronyms) in the Labor Demand Statistical Annex [https://www.serviciodeempleo.gov.co/dataempleo-spe/demanda-laboral/2022/prueba].

Finally, the names and codes of departments and municipalities are obtained from the 'Datos Abiertos' page of the Ministry of ICTs [https://www.datos.gov.co/Mapas-Nacionales/Departamentos-y-municipios-de-Colombia/xdk5-pm3f/about_data].

# Do-files description
We used 9 codes to obtain the results of the paper:

- 0_run_dofiles: this is the master code that runs all the other do-files that generate the panel, descriptive plots, and estimates in both tables and graphs.
- 1_create_annual_files: transforms the raw files downloaded from DANE into annualized files for panel construction.
- 2_create_panel_all_rawdata: This do-file builds the panel by merging the annual data and matching the information coming from the MESEP data.
- 3_cod_general_variables_WB: this is a code to create a standard variable used by the World Bank team for employment issues in Colombia.
- 4_key_variables: constructs key variables for estimation and descriptive exercises.
- 5_graphs_1_20: Generates the descriptive graphs 1 to 20 of the paper.
- 6_table_2: Construct the descriptive statistics table number 2 of the paper.
- 7_set_data_est: Creates some key variables and labels for the income gap estimation models.
- 8_tables_3_5: Generates the estimates of the decomposition methods used and exports the information for tables 3-5 of the paper and figures 33-34. These are then organized in Excel.
- 9_graphs_21_32: Generates the estimates of the probabilistic model and generates graphs 21 to 32 of the results of these specifications.
