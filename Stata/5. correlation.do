
*********** CORRELATIONS ***********

// TO INSTALL

* cap ssc install grstyle
* cap ssc install outreg2
* cap ssc install ivreg2
* cap ssc install ranktest
* cap ssc install estout
* cap ssc install ftools
* cap ssc install reghdfe
* cap ssc install ivreghdfe 

grstyle init
grstyle set plain


cd "/Users/clementineabed-meraim/Documents/Memoire"

global path="/Users/clementineabed-meraim/Documents/Memoire"


***** 1. OFFLINE CORRELATION *****


*** DATASET AT BV LEVEL ***

// LANCER 03_create_variable mais avec final_bv 
use "$path/Data/Stata/final_bv.dta", clear


*** CORRELATION *** 
pwcorr std_blockades m_d_ppa_contrefact_pop19_std m_d_ppa_contrefact_std eligible_diff_pop19_std eligible_diff19_std m_mtppaver_pop18_std m_mtppaver_pop19_std benef_ppa_pop18_std benef_ppa_pop19_std delta_contrefact_19_std delta_mtppaver_pop_std delta_benef_pop_std, star(.05)

clear all



*** REGRESSION ***

// without controls
reghdfe std_blockades m_mtppaver_pop18_std, absorb(dept) cluster(dept)

// with controls
reghdfe std_blockades m_mtppaver_pop18_std std_nb_roundabouts_km2 std_density std_pop std_pop_square std_standard_living std_urbain2015 std_income_2y_mean std_employmentrate_2016 std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_no_bac_2016 std_frac_post_bac_2016 std_frac_immigrants_2016, absorb(dept) cluster(dept)



***** 2. ONLINE CORRELATION *****



*** DATASET AT DEPT LEVEL ***

use "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/final_dept.dta", replace

// Generate variables
gen density = Population_totale/surface_area

gen d_ppa_contrefact_pop19 = (ppa_simule19 - ppa_simule_contrefact19)/Population_totale
gen eligible_diff_pop19 = eligible_diff19/Population_totale

gen mtppaver_pop19 = mtppaver19/Population_totale
gen mtppaver_pop18 = mtppaver18/Population_totale

gen benef_ppa_pop18 = benef_ppa18/Population_totale
gen benef_ppa_pop19 = benef_ppa19/Population_totale

gen delta_benef_ppa = (benef_ppa_pop19 - benef_ppa_pop18)/ benef_ppa_pop18
gen delta_mtppaver = (mtppaver_pop19 - mtppaver_pop18)/ mtppaver_pop18
gen delta_contrefact19 = (ppa_simule19 - ppa_simule_contrefact19)/ppa_simule19

replace totalmessagesfiltered = totalmessagesfiltered/Population_totale
replace totalmessagesgeo = totalmessagesgeo/Population_totale
replace totalsentencesfiltered = totalsentencesfiltered/Population_totale
replace totalsentencesgeo = totalsentencesgeo/Population_totale

// every other value is divided by pop 2016 but we want to divide it by pop totale
gen nb_group_dept_pop = nb_group_dept*pop_2016/Population_totale
gen nb_members_dept_pop = nb_members_dept*pop_2016/Population_totale
gen nb_publication_30_days_dept_pop = nb_publication_30_days_dept*pop_2016/Population_totale


// Standard value 
//egen m_d_ppa_contrefact_std = std(m_d_ppa_contrefact19)
egen d_ppa_contrefact_pop19_std = std(d_ppa_contrefact_pop19)
egen eligible_diff_pop19_std = std(eligible_diff_pop19)

egen mtppaver_pop19_std = std(mtppaver_pop19)
egen mtppaver_pop18_std = std(mtppaver_pop18)

egen benef_ppa_pop19_std = std(benef_ppa_pop19)
egen benef_ppa_pop18_std = std(benef_ppa_pop18)

egen delta_benef_ppa_std = std(delta_benef_ppa)
egen delta_mtppaver_std = std(delta_mtppaver)
egen delta_contrefact19_std = std(delta_contrefact19)

egen totalmessagesfiltered_std = std(totalmessagesfiltered)
egen totalmessagesgeo_std = std(totalmessagesgeo)
egen totalsentencesfiltered_std = std(totalsentencesfiltered)
egen totalsentencesgeo_std = std(totalsentencesgeo)
egen sentimentgeo_std = std(sentimentgeo)
egen sentimentfiltered_std = std(sentimentfiltered)

egen blockades_std = std(blockades)
egen density_std = std(density)

egen nb_group_dept_pop_std = std(nb_group_dept_pop)
egen nb_members_dept_pop_std = std(nb_members_dept_pop)
egen nb_publication_30_dept_pop_std = std(nb_publication_30_days_dept_pop)



*** CORRELATION ***

// a. Groups, members, publication
pwcorr nb_members_dept_pop_std d_ppa_contrefact_pop19_std eligible_diff_pop19_std mtppaver_pop19_std  mtppaver_pop18_std benef_ppa_pop19_std benef_ppa_pop18_std delta_benef_ppa_std delta_mtppaver_std delta_contrefact19_std, star(.05)
 
pwcorr nb_group_dept_pop_std d_ppa_contrefact_pop19_std eligible_diff_pop19_std mtppaver_pop19_std  mtppaver_pop18_std benef_ppa_pop19_std benef_ppa_pop18_std delta_benef_ppa_std delta_mtppaver_std delta_contrefact19_std, star(.05)

pwcorr nb_publication_30_dept_pop_std d_ppa_contrefact_pop19_std eligible_diff_pop19_std mtppaver_pop19_std  mtppaver_pop18_std benef_ppa_pop19_std benef_ppa_pop18_std delta_benef_ppa_std delta_mtppaver_std delta_contrefact19_std, star(.05)

// b. Sentences, messages

// total geolocated dataset
pwcorr totalmessagesgeo_std d_ppa_contrefact_pop19_std eligible_diff_pop19_std mtppaver_pop19_std  mtppaver_pop18_std benef_ppa_pop19_std benef_ppa_pop18_std delta_benef_ppa_std delta_mtppaver_std delta_contrefact19_std, star(.05)

pwcorr totalsentencesgeo_std d_ppa_contrefact_pop19_std eligible_diff_pop19_std mtppaver_pop19_std  mtppaver_pop18_std benef_ppa_pop19_std benef_ppa_pop18_std delta_benef_ppa_std delta_mtppaver_std delta_contrefact19_std, star(.05)

// filtered geolocated dataset
pwcorr totalmessagesfiltered_std d_ppa_contrefact_pop19_std eligible_diff_pop19_std mtppaver_pop19_std  mtppaver_pop18_std benef_ppa_pop19_std benef_ppa_pop18_std delta_benef_ppa_std delta_mtppaver_std delta_contrefact19_std, star(.05)

pwcorr totalsentencesfiltered_std d_ppa_contrefact_pop19_std eligible_diff_pop19_std mtppaver_pop19_std  mtppaver_pop18_std benef_ppa_pop19_std benef_ppa_pop18_std delta_benef_ppa_std delta_mtppaver_std delta_contrefact19_std, star(.05)

// c. Sentiment 

//geolocated dataset
pwcorr sentimentgeo_std d_ppa_contrefact_pop19_std eligible_diff_pop19_std mtppaver_pop19_std  mtppaver_pop18_std benef_ppa_pop19_std benef_ppa_pop18_std delta_benef_ppa_std delta_mtppaver_std delta_contrefact19_std, star(.05)

// filtered geolocated dataset
pwcorr sentimentfiltered_std d_ppa_contrefact_pop19_std eligible_diff_pop19_std mtppaver_pop19_std  mtppaver_pop18_std benef_ppa_pop19_std benef_ppa_pop18_std delta_benef_ppa_std delta_mtppaver_std delta_contrefact19_std, star(.05)



*** REGRESSION ***

// without controls : on effect of the reform
reg nb_members_dept_pop_std delta_contrefact19_std density_std

reg nb_group_dept_pop_std delta_contrefact19_std density_std

reg totalsentencesfiltered_std delta_contrefact19_std density_std


// with controls

// A RAJOUTER : REGION, CONTROLS PAR DEPARTEMENT 




***** 2. DYNAMIC OF MOBILIZATION *****

clear all

// A CLEAN : PANEL DATASET PAR DEPARTEMENT Prime d'activité/Discussions facebook/Controls 
