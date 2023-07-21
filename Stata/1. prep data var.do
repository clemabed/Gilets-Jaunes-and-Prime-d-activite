*** Create variables from : 01_regressions.do
clear

use "$path/$directory_name/Data/Stata/final_bv.dta", clear

// before was : final_com
*****************************************
* Setup the data

set more off

//Log of variables
gen logpop		= log(pop_2016)
gen logsurf		= log(surface)
gen logdist_p50	= log(dist_p50)
gen logcar		= log(total_voiture)
gen logroads	= log(roads)
gen log80km		= log(affected_roads)


foreach type_var in "std_tx" "log"{
	
	if("`type_var'"=="log"){
		
		// Facebook penetration
		cap drop `type_var'_fb_users*
		gen `type_var'_fb_users 			 = log(max(users_A, fb_users))
		replace `type_var'_fb_users 		 = 0 if `type_var'_fb_users == .
		gen `type_var'_fb_users_from 		 = log(max(users_B, fb_users_from))
		replace `type_var'_fb_users_from 	 = 0 if `type_var'_fb_users_from == .
		gen `type_var'_fb_users_inORfrom 	 = log(max(users_AorB, fb_users_inORfrom))
		replace `type_var'_fb_users_inORfrom = 0 if `type_var'_fb_users_inORfrom == .

		// Change - Signatures
		gen `type_var'_sign_pre	= log(1 + nb_sign_pre)
		replace `type_var'_sign_pre	=0 if `type_var'_sign_pre ==.
		gen `type_var'_sign_post	= log(1 + nb_sign_post)
		replace `type_var'_sign_post	=0 if `type_var'_sign_post ==.	

		//Alternative definition of outcomes
		//replace ln_nb_sign_post=0 if ln_nb_sign_post==.
		gen `type_var'_members_post17_local=log(nb_members_post17_local)
		replace `type_var'_members_post17_local = 0 if `type_var'_members_post17_local == .
		//replace ln_nb_members_post17_local=0 if ln_nb_members_post17_local==.
		gen `type_var'_publication_post17_local=log(nb_publication_post17_local)
		replace `type_var'_publication_post17_local = 0 if `type_var'_publication_post17_local == .

	}

	else if("`type_var'"=="std_tx"){
		
		// Facebook penetration
		cap drop `type_var'_fb_users*
		egen `type_var'_fb_users 				= std((max(users_A, fb_users))/pop_2016) 
		replace `type_var'_fb_users  			= 0 if `type_var'_fb_users == .
		replace `type_var'_fb_users  			= `type_var'_fb_users /100
		*
		egen `type_var'_fb_users_from 			= std((max(users_B, fb_users_from))/pop_2016) 
		replace `type_var'_fb_users_from 		= 0 if `type_var'_fb_users_from == .
		replace `type_var'_fb_users_from  	 	= `type_var'_fb_users_from /100
		*
		gen tx_fb_users_inORfrom = 0
		replace tx_fb_users_inORfrom = max(users_AorB, fb_users_inORfrom)/pop_2016
		replace tx_fb_users_inORfrom = 1 if tx_fb_users_inORfrom > 1
		egen `type_var'_fb_users_inORfrom 		= std(tx_fb_users_inORfrom) 
		replace `type_var'_fb_users_inORfrom 	= 0 if `type_var'_fb_users_inORfrom == .
		replace `type_var'_fb_users_inORfrom   	= `type_var'_fb_users_inORfrom /100

		// Change - Signatures
		egen `type_var'_sign_pre	= std(nb_sign_pre/pop_2016) 
		replace `type_var'_sign_pre	= 0 if  `type_var'_sign_pre	== .
		egen `type_var'_sign_post	= std(nb_sign_post/pop_2016) 
		replace `type_var'_sign_post= 0 if  `type_var'_sign_post	== .
		
		//Alternative definition of outcomes
		gen `type_var'_members_post17_local = nb_members_post17_local/pop_2016
		replace `type_var'_members_post17_local = 0 if `type_var'_members_post17_local == .
		gen `type_var'_publication_post17_local = nb_publication_post17_local/pop_2016
		replace `type_var'_publication_post17_local = 0 if `type_var'_publication_post17_local == .
		
	}

}

//Square of pop and splines
sum pop_2016, d
gen pop_spline00 = pop_2016*(pop_2016 < `r(p50)') if pop_2016 != . 
gen pop_splineP50 = pop_2016*(pop_2016 >= `r(p50)' & pop_2016 < `r(p75)') if pop_2016 != . 
gen pop_splineP75 = pop_2016*(pop_2016 >= `r(p75)' ) if pop_2016 != . 
gen pop_square = pop_2016*pop_2016 if pop_2016 != . 

//Number of groups, standardized
egen std_nb_group_pre=std(nb_group_pre17)

//Presence of a local group dummy
gen bin_group_local_pre=0
replace bin_group_local_pre=1 if nb_group_pre17_local>0 & nb_group_pre17_local!=.
gen bin_group_local_post=0
replace bin_group_local_post=1 if nb_group_post17_local>0 & nb_group_post17_local!=.

//Nonlocal groups, standardized
gen nb_group_pre_nonlocal = nb_group_pre17 - nb_group_pre17_local
egen std_nb_group_pre_nonlocal = std(nb_group_pre_nonlocal)
assert nb_group_pre_nonlocal != . if nb_group_pre17 != . & nb_group_pre17_local != . 
assert nb_group_pre_nonlocal == . if nb_group_pre17 == . | nb_group_pre17_local == . 

//Number of roundabouts in the life zone  
egen sum_nb_roundabouts_bv = sum(nb_roundabouts), by(bv)
gen leaveout_roundabouts = sum_nb_roundabouts - nb_roundabouts

//Surface area of the rest of the life zone, and density of roundabouts in the rest of the life zone
egen surf_bv=sum(surface), by(bv)
replace surf_bv=surf_bv-surface
gen leaveout_drbv=leaveout_roundabouts/surf_bv
egen std_leaveout_drbv=std(leaveout_drbv)

//Standardized density of roundabouts
egen std_nb_roundabouts_km2=std(nb_roundabouts_km2)

//Leave out instrument, employment zone
egen sum_nb_roundabouts_ze=sum(nb_roundabouts), by(bv2022_code)
gen leaveout_roundabouts_ze=sum_nb_roundabouts_ze-nb_roundabouts
egen surf_ze=sum(surface), by(bv2022_code)
replace surf_ze=surf_ze-surface
gen leaveout_drze=leaveout_roundabouts_ze/surf_ze
egen std_leaveout_drze=std(leaveout_drze)

//Number of traffic lights in the life zone  
egen sum_traffic_light_bv = sum(total_traffic_light), by(bv2022_code)
gen leaveout_traffic_light = sum_traffic_light_bv - total_traffic_light

//Surface area of the rest of the life zone, and density of traffic lights in the rest of the life zone
gen leaveout_light_drbv=leaveout_traffic_light/surf_bv
egen std_leaveout_light_drbv=std(leaveout_light_drbv)

//Standardized density of traffic lights
//egen std_nb_traffic_light_km2=std(traffic_light_km2)

// Ile de France Region dummy 
gen paris_region = (dept==75 | dept==77 | dept==78 | dept>=91)

//Vote shares in 2014 and 2017 elections
foreach votes in EM2017 UMP2017 PS2017 FN2017 FI2017 ABS2017 ABS2014 FG2014 PS2014 MODEM2014 UMP2014 FN2014{
	egen std_`votes' =std(`votes') 
}


foreach type_var in "std_tx" "log"{

	* Label variables

	lab var `type_var'_fb_users 			"Facebook users in ($type_var)"
	lab var `type_var'_fb_users_from 		"Facebook users from ($type_var)"
	lab var `type_var'_fb_users_inORfrom 	"Facebook Penetration ($type_var)"
	lab var nb_sign_post "Sign."
	lab var `type_var'_members_post17_local "Memb. ($type_var)"
	lab var `type_var'_publication_post17_local "Posts ($type_var)"
	lab var nb_group_post17_local "Nb. local groups"

	lab var `type_var'_sign_pre "Pre signatures ($type_var)"
	lab var std_nb_group_pre "Pre nb. groups"
	lab var `type_var'_sign_post "Signatures ($type_var)"
	lab var bin_group_local_post "Local gr."
	lab var `type_var'_members_post17_local "Memb. ($type_var)"
	lab var `type_var'_publication_post17_local "Posts ($type_var)"
	lab var `type_var'_sign_pre "Signatures ($type_var, pre-17/11)"
	lab var std_nb_group_pre "Nb. Groups (pre-17/11)"
	lab var bin_group_local_pre "Local Group (bin, pre-17/11)"
	lab var std_nb_roundabouts_km "Roundabout Density (Munic.)"
	lab var std_leaveout_drbv "Roundabout Density (LZ)"
	lab var bin_blockade "Local Blockade"
	//lab var std_nb_traffic_light_km "Traffic light Density (Munic.)"
	lab var std_leaveout_light_drbv "Traffic light Density (LZ)"
	label var pop_square "Squared Population"
	label var pop_splineP50 "Pop.spline: median"
	label var pop_splineP75 "Pop.spline: 75th percentile"
	label var logroads	"Roads length (log km)"
	label var log80km	"Reduced speed (log km)"


	if("`type_var'"=="log"){
		local `type_var'_car = "logcar"
	}
	else if("`type_var'"=="std_tx"){
		local `type_var'_car = "voiture_pop"
	}  

	loc population = "density pop_2016 pop_square pop_splineP50 pop_splineP75" 
	loc geography = "urbain2015 new_urban distance_20000 distance_100000"  
	loc commuting = "frac_car_2016 frac_public_tran_2016 dist_p50"  
	loc labormarket = "income_2y_mean frac_non_cdi_2016 unemployment_2016 frac_retail_2016 frac_executives_2016 frac_intermediate_2016 frac_employees_2016 frac_workers_2016"
	loc age = "frac_18_24_2016 frac_25_39_2016 frac_40_64_2016 frac_65_plus_2016"
	loc education = "frac_no_bac_2016 frac_post_bac_2016"
	loc immigrants = "frac_immigrants_2016"
	loc votes = "EM2017 FI2017 UMP2017 PS2017 FN2017 ABS2017"
	loc votes_2014 = "ABS2014 FG2014 PS2014 MODEM2014 UMP2014 FN2014"
	loc motorists = "``type_var'_car' diesel_vs_essence logroads log80km"


	local `type_var'_control_list = "`population' `geography' `commuting' `labormarket' `age' `education' `immigrants' `votes' `motorists'"  

	foreach v in ``type_var'_control_list' {
		di "`v'"
		capture confirm variable m_`v'
		if _rc != 0{
			gen m_`v' = (`v' == .)
			gen c_`v' = `v'
			replace c_`v' = 0 if c_`v'==.
		}
		local `type_var'_full_controls = "``type_var'_full_controls' m_`v' c_`v'"
	}

}

di "`std_tx_control_list'"
di "`std_tx_full_controls'"

save "$path/$directory_name/Data/Stata/final_bv.dta", replace

