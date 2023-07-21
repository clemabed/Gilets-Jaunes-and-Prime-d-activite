**** PREPROCESSING FOR DATA OF PRIME D'ACTIVITE AT BV LEVEL ****


cd "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata"


// Merging with population INSEE

use Pop_BV.dta
//replace BV2012 = substr(BV2012, 2, .) in 1/109
//destring BV2012, gen(BV2012_code) force
//drop BV2012
//duplicates drop BV2012_code, force 
save Pop_BV.dta, replace

clear 
use agg_table_regall_by_date_and_bv2012.dta
//destring BV2012, gen(BV2012_code) force
//rename BV2012 BV2012_code
drop _merge
merge m:1 BV2012_code using Pop_BV.dta, keep(master match) 
save agg_table_regall_by_date_and_bv2012.dta, replace

// Create 2 dataset to assess for before and after reform :


clear 
use agg_table_regall_by_date_and_bv2012.dta
sort BV2012 date
tsset BV2012 date
replace m_mtppaver_pop = mtppaver/Population_totale
replace benef_ppa_pop = benef_ppa/Population_totale
replace eligible_diff = eligible_ppa - eligible_ppa_contrefact 
replace eligible_diff_pop = (eligible_ppa - eligible_ppa_contrefact)/Population_totale
replace m_d_ppa_contrefact_pop = m_d_ppa_contrefact*nb_obs/Population_totale
replace d_ppa_contrefact = m_d_ppa_contrefact*nb_obs
replace ppa_simule_contrefact = m_ppa_simule_contrefact*nb_obs
replace ppa_simule = m_ppa_simule*nb_obs
save agg_table_regall_by_date_and_bv2012.dta, replace

// Nov 2018
clear 
use agg_table_regall_by_date_and_bv2012.dta
rename BV2012 bv
keep if date == 21518 
keep mtppaver m_mtppaver m_mtppaver_pop benef_ppa benef_ppa_pop bv Population_totale
rename m_mtppaver m_mtppaver18
rename mtppaver mtppaver18
rename m_mtppaver_pop m_mtppaver_pop18
rename benef_ppa benef_ppa18
rename benef_ppa_pop benef_ppa_pop18
rename bv bv2022_code
save PA_BV_Nov18.dta, replace
clear all

// Mar 2019
use agg_table_regall_by_date_and_bv2012.dta
sort BV2012 date
tsset BV2012 date

rename BV2012 bv
keep if date == 21638
keep  mtppaver m_mtppaver m_mtppaver_pop benef_ppa benef_ppa_pop eligible_diff eligible_diff_pop m_d_ppa_contrefact m_d_ppa_contrefact_pop m_d_ppa_contrefact d_ppa_contrefact ppa_simule_contrefact ppa_simule bv Population_totale
rename ppa_simule ppa_simule19
rename ppa_simule_contrefact ppa_simule_contrefact19
rename m_mtppaver m_mtppaver19 
rename mtppaver mtppaver19
rename m_mtppaver_pop m_mtppaver_pop19 
rename d_ppa_contrefact d_ppa_contrefact19
rename m_d_ppa_contrefact m_d_ppa_contrefact19
rename m_d_ppa_contrefact_pop m_d_ppa_contrefact_pop19
rename eligible_diff eligible_diff19
rename eligible_diff_pop eligible_diff_pop19
rename benef_ppa benef_ppa19
rename benef_ppa_pop benef_ppa_pop19
rename bv bv2022_code
save PA_BV_Mar19.dta, replace
clear all


// Merging those with the BV dataset 
use final_bv.dta
//rename bv bv2022_code
drop _merge
merge 1:1 bv2022_code using PA_BV_Nov18.dta
save final_bv.dta, replace
clear all

use final_bv.dta
drop _merge
merge 1:1 bv2022_code using PA_BV_Mar19.dta
save final_bv.dta, replace
clear all

// Delta variables at BV level
use final_bv.dta
replace delta_mtppaver_pop = (m_mtppaver_pop19 - m_mtppaver_pop18) / m_mtppaver_pop18
replace delta_benef_pop = (benef_ppa_pop19 - benef_ppa_pop18) / benef_ppa_pop18
replace delta_contrefact_19 = (ppa_simule19-ppa_simule_contrefact19)/ppa_simule19
save final_bv.dta, replace

