
**** DATABASE CONSTRUCTION FOR ECONOMETRIC ANALYSIS ****




*** I. DATABASE AT BV LEVEL FOR CROSS SECTIONAL REGRESSION ***
cd "/Users/clementineabed-meraim/Documents/Memoire"

global path="/Users/clementineabed-meraim/Documents/Memoire"

use "$path/Data/Stata/final_bv.dta", clear

** Standardizing and adjusting variables **

// 1. Variables of mobilization

gen blockades_pop = blockades/Population_totale
gen nb_group_pop = nb_group/Population_totale
gen nb_members_pop = nb_members/Population_totale
replace pop_square = Population_totale^2

egen std_blockades = std(blockades/Population_totale)
egen std_nb_group_pop = std(nb_group/Population_totale)
egen std_nb_members_pop = std(nb_members/Population_totale)

// 2. Variables of PA reform

	// contrefacts
egen std_m_d_ppa_contrefact_pop19 = std(m_d_ppa_contrefact_pop19)
egen std_eligible_diff_pop19 = std(eligible_diff_pop19)

	// amounts
egen std_m_mtppaver_pop19 = std(m_mtppaver_pop19)
egen std_m_mtppaver_pop18 = std(m_mtppaver_pop18)

	// benef
egen std_benef_ppa_pop19 = std(benef_ppa_pop19)
egen std_benef_ppa_pop18 = std(benef_ppa_pop18)

	// deltas
egen std_delta_mtppaver_pop = std(delta_mtppaver_pop)
egen std_delta_benef_pop = std(delta_benef_pop)
egen std_delta_contrefact_19 = std(delta_contrefact_19)


// 3. Controls 
	// semography controls
egen std_density = std(density)
egen std_pop = std(Population_totale)
egen std_pop_square = std(Population_totale^2)
egen std_urbain2015 = std(urbain2015)
egen std_frac_immigrants_2016 = std(frac_immigrants_2016)

	// income controls
egen std_standard_living = std(standard_living)
gen log_income_2y_mean = log(income_2y_mean)
egen std_log_income_2y_mean = std(log_income_2y_mean)
egen std_income_2y_mean = std(income_2y_mean)

	// labour market controls
egen std_employmentrate_2016 = std(employmentrate_2016)
egen std_frac_non_cdi_2016 = std(frac_non_cdi_2016)
egen std_frac_retail_2016 = std(frac_retail_2016)
egen std_frac_executives_2016= std(frac_executives_2016)
egen std_frac_intermediate_2016 = std(frac_intermediate_2016)
egen std_frac_employees_2016 = std(frac_employees_2016)
egen std_frac_workers_2016 = std(frac_workers_2016)

	// age controls
egen std_frac_18_24_2016 = std(frac_18_24_2016)
egen std_frac_25_39_2016 = std(frac_25_39_2016)
egen std_frac_40_64_2016 = std(frac_40_64_2016)
egen std_frac_65_plus_2016 = std(frac_65_plus_2016)

	// education controls
egen std_frac_no_bac_2016 = std(frac_no_bac_2016)
egen std_frac_post_bac_2016 = std(frac_post_bac_2016)

	// vote controls
drop std_ABS2017 std_EM2017 std_FI2017 std_FN2017 std_PS2017 std_UMP2017

egen std_ABS2017 = std(ABS2017/Population_totale)
egen std_EM2017 = std(EM2017/Population_totale)	
egen std_FI2017 = std(FI2017/Population_totale)	
egen std_FN2017 = std(FN2017/Population_totale)	
egen std_PS2017 = std(PS2017/Population_totale)	
egen std_UMP2017 = std(UMP2017/Population_totale)	

	// std_ = std(/Population_totale)	
	
	
keep std_blockades std_nb_group_pop std_nb_members_pop std_m_d_ppa_contrefact_pop19 std_eligible_diff_pop19 std_m_mtppaver_pop19 std_m_mtppaver_pop18 std_benef_ppa_pop19 std_benef_ppa_pop18 std_delta_mtppaver_pop std_delta_benef_pop std_delta_contrefact_19 std_density std_pop std_pop_square std_urbain2015 std_frac_immigrants_2016 std_standard_living std_income_2y_mean std_employmentrate_2016  std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_no_bac_2016 std_frac_post_bac_2016 std_ABS2017 std_EM2017 std_FI2017 std_FN2017 std_PS2017 std_UMP2017 std_tx_fb_users_inORfrom bin_blockades_bv blockades_pop nb_group_pop std_nb_members_pop m_d_ppa_contrefact_pop19 eligible_diff_pop19 m_mtppaver_pop19 m_mtppaver_pop18 benef_ppa_pop19 benef_ppa_pop18 delta_mtppaver_pop delta_benef_pop delta_contrefact_19 density Population_totale pop_square urbain2015 frac_immigrants_2016 standard_living income_2y_mean employmentrate_2016 frac_non_cdi_2016 frac_retail_2016 frac_executives_2016 frac_intermediate_2016 frac_employees_2016 frac_workers_2016 frac_18_24_2016 frac_25_39_2016 frac_40_64_2016 frac_65_plus_2016 frac_no_bac_2016 frac_post_bac_2016 ABS2017 std_EM2017 std_FI2017 std_FN2017 PS2017 UMP2017 nb_roundabouts_km2 tx_fb_users_inORfrom  std_log_income_2y_mean dept bv2022_code


save "$path/Data/Stata/final_bv1.dta", replace
clear all



*** II. DATABASE AT DEPT LEVEL FOR CROSS SECTIONAL REGRESSION ***

** Merging dataset **

use "$path/Data/Stata/final_bv.dta", clear
sort dept

//egen total_pop = total(Population_totale)
//generate frac_pop = Population_totale/total_pop

// collapse

collapse (mean) income_2y_mean frac_immigrants_2016 employmentrate_2016 frac_non_cdi_2016 frac_retail_2016 frac_executives_2016 frac_intermediate_2016 frac_employees_2016 frac_workers_2016 frac_18_24_2016 frac_25_39_2016 frac_40_64_2016 frac_65_plus_2016 frac_no_bac_2016 frac_post_bac_2016 urbain2015 standard_living tx_fb_users_inORfrom [fweight=Population_totale], by(dept) 

merge 1:1 dept using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Facebook groups/dta/fb_dept.dta", keep(master match) 
drop _merge
save "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/final_dept.dta", replace
clear

use "$path/Data/Stata/final_bv.dta", clear
sort dept
collapse (sum) blockades Population_totale pop_2016 surface_area mtppaver18 mtppaver19 benef_ppa18 benef_ppa19 eligible_diff19 d_ppa_contrefact19 ppa_simule_contrefact19 ppa_simule19 ABS2017 EM2017 FI2017 FN2017 PS2017 UMP2017 nb_roundabouts, by(dept) 

merge 1:1 dept using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/final_dept.dta", keep(master match) 
drop _merge
save "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/final_dept.dta", replace
clear

import delimited "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/sentences_dep.csv"
// dep, gen(dept) force
rename dep dept
sort dept
drop if dept == .
merge 1:m dept using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/final_dept.dta"
save "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/final_dept.dta", replace


** Standardizing and adjusting variables **


	**  Generating variables **
gen density = Population_totale/surface_area
gen blockades_pop = blockades/Population_totale
gen nb_group_pop = nb_group/Population_totale
gen nb_members_pop = nb_members/Population_totale
gen pop_square = Population_totale^2

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


	** Standardizing variables **
	
// 1. Variables of mobilization

egen std_totalmessagesfiltered = std(totalmessagesfiltered)
egen std_totalmessagesgeo = std(totalmessagesgeo)
egen std_totalsentencesfiltered = std(totalsentencesfiltered)
egen std_totalsentencesgeo = std(totalsentencesgeo)
egen std_sentimentgeo = std(sentimentgeo)
egen std_sentimentfiltered = std(sentimentfiltered)

egen std_blockades = std(blockades)

egen std_nb_group_dept_pop = std(nb_group_dept_pop)
egen std_nb_members_dept_pop = std(nb_members_dept_pop)
egen std_nb_publication_30_dept_pop = std(nb_publication_30_days_dept_pop)

// 2. Variables of PA reform

egen std_d_ppa_contrefact_pop19 = std((ppa_simule19 - ppa_simule_contrefact19)/Population_totale)
egen std_eligible_diff_pop19 = std(eligible_diff19/Population_totale)

egen std_mtppaver_pop19 = std(mtppaver19/Population_totale)
egen std_mtppaver_pop18 = std(mtppaver18/Population_totale)

egen std_benef_ppa_pop18 = std(benef_ppa18/Population_totale)
egen std_benef_ppa_pop19 = std(benef_ppa19/Population_totale)

egen std_delta_benef_ppa = std((benef_ppa_pop19 - benef_ppa_pop18)/ benef_ppa_pop18)
egen std_delta_mtppaver = std((mtppaver_pop19 - mtppaver_pop18)/ mtppaver_pop18)
egen std_delta_contrefact19 = std((ppa_simule19 - ppa_simule_contrefact19)/ppa_simule19)

// 3. Control variables 

	// demography controls
egen std_density = std(Population_totale/surface_area)
egen std_pop = std(Population_totale)
egen std_pop_square = std(Population_totale^2)
egen std_urbain2015 = std(urbain2015)
egen std_frac_immigrants_2016 = std(frac_immigrants_2016)

	// income controls
egen std_standard_living = std(standard_living)
egen std_income_2y_mean = std(income_2y_mean)

	// labour market controls
egen std_employmentrate_2016 = std(employmentrate_2016)
egen std_frac_non_cdi_2016 = std(frac_non_cdi_2016)
egen std_frac_retail_2016 = std(frac_retail_2016)
egen std_frac_executives_2016= std(frac_executives_2016)
egen std_frac_intermediate_2016 = std(frac_intermediate_2016)
egen std_frac_employees_2016 = std(frac_employees_2016)
egen std_frac_workers_2016 = std(frac_workers_2016)

	// age controls
egen std_frac_18_24_2016 = std(frac_18_24_2016)
egen std_frac_25_39_2016 = std(frac_25_39_2016)
egen std_frac_40_64_2016 = std(frac_40_64_2016)
egen std_frac_65_plus_2016 = std(frac_65_plus_2016)

	// education controls
egen std_frac_no_bac_2016 = std(frac_no_bac_2016)
egen std_frac_post_bac_2016 = std(frac_post_bac_2016)

	// vote controls
//drop std_ABS2017 std_EM2017 std_FI2017 std_FN2017 std_PS2017 std_UMP2017
egen std_ABS2017 = std(ABS2017/Population_totale)
egen std_EM2017 = std(EM2017/Population_totale)	
egen std_FI2017 = std(FI2017/Population_totale)	
egen std_FN2017 = std(FN2017/Population_totale)	
egen std_PS2017 = std(PS2017/Population_totale)	
egen std_UMP2017 = std(UMP2017/Population_totale)

egen std_tx_fb_users_inORfrom = std(tx_fb_users_inORfrom)
gen nb_roundabouts_km2=nb_roundabouts/surface_area
egen std_nb_roundabouts_km2 = std(nb_roundabouts/surface_area)

keep std_blockades std_nb_group_dept_pop std_nb_members_dept_pop std_nb_publication_30_dept_pop std_totalmessagesfiltered std_totalmessagesgeo std_totalsentencesfiltered std_totalsentencesgeo std_sentimentgeo std_sentimentfiltered std_d_ppa_contrefact_pop19 std_eligible_diff_pop19 std_mtppaver_pop19 std_mtppaver_pop18 std_benef_ppa_pop18 std_benef_ppa_pop19 std_delta_benef_ppa std_delta_mtppaver std_delta_contrefact19 std_density std_pop std_pop_square std_urbain2015 std_frac_immigrants_2016 std_standard_living std_income_2y_mean std_employmentrate_2016  std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_no_bac_2016 std_frac_post_bac_2016 std_ABS2017 std_EM2017 std_FI2017 std_FN2017 std_PS2017 std_UMP2017 std_nb_roundabouts_km2 std_tx_fb_users_inORfrom blockades_pop nb_group_pop nb_members_pop nb_group_dept_pop nb_members_dept_pop nb_publication_30_days_dept_pop totalmessagesfiltered totalmessagesgeo totalsentencesfiltered totalsentencesgeo sentimentgeo sentimentfiltered d_ppa_contrefact_pop19 eligible_diff_pop19 mtppaver_pop19 mtppaver_pop18 benef_ppa_pop18 benef_ppa_pop19 delta_benef_ppa delta_mtppaver delta_contrefact19 density Population_totale pop_square urbain2015 frac_immigrants_2016 standard_living income_2y_mean employmentrate_2016 frac_non_cdi_2016 frac_retail_2016 frac_executives_2016 frac_intermediate_2016 frac_employees_2016 frac_workers_2016 frac_18_24_2016 frac_25_39_2016 frac_40_64_2016 frac_65_plus_2016 frac_no_bac_2016 frac_post_bac_2016 ABS2017 EM2017 FI2017 FN2017 PS2017 UMP2017 nb_roundabouts tx_fb_users_inORfrom 



save final_dept.dta, replace




** III. PANEL DATABASE AT DEPT LEVEL FOR DYNAMICS **

clear all


// adding "dept" variable to PA table
cd "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata"

use agg_table_regall_by_date_and_bv2012.dta
gen dept=int(BV2012_code/1000) 
save "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/agg_table_regall_by_date_and_bv2012.dta", replace

// merging with month data on sentences
clear
import delimited "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/sentences_dep_month.csv"
//destring dep, gen(dept) force
rename dep dept
sort dept
drop if dept == .
//drop _merge
merge 1:m dept using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/agg_table_regall_by_date_and_bv2012.dta"
save "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/panel_dept.dta", replace


clear
// merge avec population par département
// merge avec population par mois




