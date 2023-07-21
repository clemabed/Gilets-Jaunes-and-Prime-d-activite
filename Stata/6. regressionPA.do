
*********** REGRESSION ***********



**** I. WHAT EXPLAINS PA AMOUNTS ? ****
grstyle init
grstyle set plain


cd "/Users/clementineabed-meraim/Documents/Memoire"

global path="/Users/clementineabed-meraim/Documents/Memoire"

use "$path/Data/Stata/final_bv1.dta", clear



***** NOV 2018 *****

** 2. INDEPENDANT REG **
// What explains the PA per LZ in Nov18 ?

	// All controls
reghdfe m_mtppaver_pop18 blockades nb_group_hab nb_members_hab tx_fb_users_inORfrom density pop_2016 pop_square pop_splineP50 pop_splineP75 urbain2015 new_urban distance_20000 distance_100000 income_2y_mean frac_non_cdi_2016 unemployment_2016 frac_retail_2016 frac_executives_2016 frac_intermediate_2016 frac_employees_2016 frac_workers_2016 frac_18_24_2016 frac_25_39_2016 frac_40_64_2016 frac_65_plus_2016 frac_no_bac_2016 frac_post_bac_2016 frac_immigrants_2016 std_EM2017 std_FI2017 std_UMP2017 std_PS2017 std_FN2017 std_ABS2017, absorb(dept) cluster(dept)

	// Restricted + Standardized
reghdfe m_mtppaver_pop18 std_blockades std_nb_group_pop std_nb_members_pop std_tx_fb_users_inORfrom std_density std_urbain2015 std_standard_living std_income_2y_mean frac_non_cdi_2016 employmentrate_2016 std_frac_retail_2016 std_frac_executives_2016 frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_no_bac_2016 std_frac_post_bac_2016 std_EM2017 std_FI2017 std_UMP2017 std_PS2017 std_FN2017 std_ABS2017, absorb(dept) cluster(dept)

	// Related to revenue

pwcorr m_mtppaver_pop18 std_standard_living std_income_2y_mean std_density std_employmentrate_2016, star(0.05)

reghdfe m_mtppaver_pop18 std_standard_living std_income_2y_mean std_density std_employmentrate_2016, absorb(dept, savefe) cluster(dept)

// ATTENTION : test avec log, reprendre std_income_2y_mean si pas concluant
// enlever la densité ? quel potentielle variable omise (taille moyenne foyer?)


	// Related to age 
reghdfe m_mtppaver_pop18 std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_density, absorb(dept) cluster(dept)

	// Related to employment status
reghdfe m_mtppaver_pop18 std_employmentrate_2016 std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_density, absorb(dept) cluster(dept)

	// Related to education
reghdfe m_mtppaver_pop18 std_frac_no_bac_2016 std_frac_post_bac_2016 std_density, absorb(dept) cluster(dept)

	// Related to vote
reghdfe m_mtppaver_pop18 std_EM2017 std_FI2017 std_UMP2017 std_PS2017 std_FN2017 std_ABS2017 std_density, absorb(dept) cluster(dept)



** 3. INCLUSION PROGRESSIVE **

	// MOST RELEVANT VARIABLES
reghdfe m_mtppaver_pop18 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density, absorb(dept) cluster(dept)
estimates store reg1
esttab reg1, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs

	// ADDING AGE
reghdfe m_mtppaver_pop18 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016, absorb(dept) cluster(dept)
estimates store reg2
esttab reg2, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs

	// ADDING EMPLOYMENT STATUS
reghdfe m_mtppaver_pop18 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016, absorb(dept) cluster(dept)
estimates store reg3
esttab reg3, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs


	// ADDING EDUCATION 
reghdfe m_mtppaver_pop18 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_frac_no_bac_2016 std_frac_post_bac_2016, absorb(dept) cluster(dept)
estimates store reg4
esttab reg4, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs

	// ALL
reghdfe m_mtppaver_pop18 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_frac_no_bac_2016 std_frac_post_bac_2016 std_EM2017 std_FI2017 std_UMP2017 std_PS2017 std_FN2017 std_ABS2017 std_urbain2015 std_frac_immigrants_2016, absorb(dept) cluster(dept)	
estimates store reg5
esttab reg5, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs

	
	// ALL + MOBILIZATION
reghdfe m_mtppaver_pop18 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_frac_no_bac_2016 std_frac_post_bac_2016 std_EM2017 std_FI2017 std_UMP2017 std_PS2017 std_FN2017 std_ABS2017 std_urbain2015 std_frac_immigrants_2016 std_blockades std_nb_group_pop std_nb_members_pop, absorb(dept) cluster(dept)	
estimates store reg6
esttab reg6, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs


***** MAR 2019 *****

** 1. INDEPENDANT REG **

// What explains the PA per LZ in Nov18 ?

	// All controls
reghdfe m_mtppaver_pop19 blockades nb_group_hab nb_members_hab tx_fb_users_inORfrom density pop_2016 pop_square pop_splineP50 pop_splineP75 urbain2015 new_urban distance_20000 distance_100000 income_2y_mean frac_non_cdi_2016 unemployment_2016 frac_retail_2016 frac_executives_2016 frac_intermediate_2016 frac_employees_2016 frac_workers_2016 frac_18_24_2016 frac_25_39_2016 frac_40_64_2016 frac_65_plus_2016 frac_no_bac_2016 frac_post_bac_2016 frac_immigrants_2016 std_EM2017 std_FI2017 std_UMP2017 std_PS2017 std_FN2017 std_ABS2017, absorb(dept) cluster(dept)

	// Restricted + Standardized
reghdfe m_mtppaver_pop19 std_blockades std_nb_group_pop std_nb_members_pop std_tx_fb_users_inORfrom std_density std_urbain2015 std_standard_living std_income_2y_mean frac_non_cdi_2016 employmentrate_2016 std_frac_retail_2016 std_frac_executives_2016 frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_no_bac_2016 std_frac_post_bac_2016 std_EM2017 std_FI2017 std_UMP2017 std_PS2017 std_FN2017 std_ABS2017, absorb(dept) cluster(dept)

	// Related to revenue
reghdfe m_mtppaver_pop19 std_standard_living std_income_2y_mean std_density, absorb(dept) cluster(dept)

	// Related to age 
reghdfe m_mtppaver_pop19 std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_density, absorb(dept) cluster(dept)

	// Related to employment status
reghdfe m_mtppaver_pop19 std_employmentrate_2016 std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_density, absorb(dept) cluster(dept)

	// Related to education
reghdfe m_mtppaver_pop19 std_frac_no_bac_2016 std_frac_post_bac_2016 std_density, absorb(dept) cluster(dept)

	// Related to vote
reghdfe m_mtppaver_pop19 std_EM2017 std_FI2017 std_UMP2017 std_PS2017 std_FN2017 std_ABS2017 std_density, absorb(dept) cluster(dept)



** 2. INCLUSION PROGRESSIVE **


	// MOST RELEVANT VARIABLES
reghdfe m_mtppaver_pop19 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density, absorb(dept) cluster(dept)
estimates store reg1
esttab reg1, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs

	// ADDING AGE
reghdfe m_mtppaver_pop19 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016, absorb(dept) cluster(dept)
estimates store reg2
esttab reg2, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs

	// ADDING EMPLOYMENT STATUS
reghdfe m_mtppaver_pop19 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016, absorb(dept) cluster(dept)
estimates store reg3
esttab reg3, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs

	// ADDING EDUCATION 
reghdfe m_mtppaver_pop19 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_frac_no_bac_2016 std_frac_post_bac_2016, absorb(dept) cluster(dept)
estimates store reg4
esttab reg4, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs

	// ALL
reghdfe m_mtppaver_pop19 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_frac_no_bac_2016 std_frac_post_bac_2016 std_EM2017 std_FI2017 std_UMP2017 std_PS2017 std_FN2017 std_ABS2017 std_urbain2015 std_frac_immigrants_2016, absorb(dept) cluster(dept)	
estimates store reg5
esttab reg5, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs
	
	// ALL + MOBILIZATION
reghdfe m_mtppaver_pop19 std_standard_living std_employmentrate_2016  std_income_2y_mean std_density std_frac_18_24_2016 std_frac_25_39_2016 std_frac_40_64_2016 std_frac_65_plus_2016 std_frac_non_cdi_2016 std_frac_retail_2016 std_frac_executives_2016 std_frac_intermediate_2016 std_frac_employees_2016 std_frac_workers_2016 std_frac_no_bac_2016 std_frac_post_bac_2016 std_EM2017 std_FI2017 std_UMP2017 std_PS2017 std_FN2017 std_ABS2017 std_urbain2015 std_frac_immigrants_2016 std_blockades std_nb_group_pop std_nb_members_pop, absorb(dept) cluster(dept)
estimates store reg6
esttab reg6, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs	
