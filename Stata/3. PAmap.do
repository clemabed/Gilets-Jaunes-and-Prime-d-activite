**** MAPPING OF PRIME D'ACTIVITE AT BV LEVEL ****

cd "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata"

use final_bv.dta


replace logpop=log(pop_2016)
replace logsurf=log(surface_area)
replace logdist_p50=log(dist_p50)

local full_controls = ""
foreach v in `control_list' {
	gen m_`v' = (`v' == .)
	gen c_`v' = `v'
	replace c_`v' = 0 if c_`v'==.
	local full_controls = "`full_controls' m_`v' c_`v'"
}

sort bv
drop if bv == . | bv>97000

// rename bv bv2022_code
//drop _merge
save final_bv.dta,replace


** I. MAP PREPROCESSING **

cd "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes"
spshape2dta bv2022_2022.shp, replace saving(bv2022)

use "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022.dta", clear
destring bv2022, gen(bv2022_code) force
//We drop municipalities outside of mainland France
drop if bv2022_code == . | bv2022_code>97000


merge m:1 bv2022_code using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/final_bv.dta", keep(master match) 


// to install :
// ssc install colrspace
// ssc install palettes 
// ssc install geo2xy
// ssc install spmap
// ssc install schemepack

colorpalette w3 blue, n(2) nograph
local colors `r(p)'


** II. AMOUNTS **

// Average amounts of prime d'activite in life zones among CNAF beneficiaries
// Nov 2018
spmap m_mtppaver18 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID)clmethod(custom) clbreaks(0 25 30 40 45 50 70)  fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/m_PA_18.png", as(png) name("Graph") replace 

// Mar 2019
spmap m_mtppaver19 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID) clmethod(custom) clbreaks(0 25 30 40 45 50 70)  fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/m_PA_19.png", as(png) name("Graph") replace


// Average amounts of prime d'activite in life zones among population
// Nov 2018
spmap m_mtppaver_pop18 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) clmethod(custom) clbreaks(0 4 6 8 10 12 25)  fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/m_PA_pop_18.png", as(png) name("Graph") replace 

// Mar 2019
spmap m_mtppaver_pop19 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID) clmethod(custom) clbreaks(0 4 6 8 10 12 25) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/m_PA_pop_19.png", as(png) name("Graph") replace



** III. BENEFICIARIES **

//Number of beneficiaries in life zones (no adjustment)
// Nov 2018
spmap benef_ppa18 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID)clmethod(custom) clbreaks(0 300 500 1000 1500 500000) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/benef_PA_18.png", as(png) name("Graph") replace 

// Mar 2019
spmap benef_ppa19 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID)clmethod(custom) clbreaks(0 300 500 1000 1500 500000) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/benef_PA_19.png", as(png) name("Graph") replace 

//Number of beneficiaries in life zones among population
// Nov 2018
spmap benef_ppa_pop18 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID) clmethod(custom) clbreaks(0 0.01 0.035 0.05 0.06 0.2) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/benef_PA_pop_18.png", as(png) name("Graph") replace 

// Mar 2019
spmap benef_ppa_pop19 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID) clmethod(custom) clbreaks(0 0.01 0.035 0.05 0.06 0.2) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/benef_PA_pop_19.png", as(png) name("Graph") replace 


** IV. COUNTERFACTUALS **


// Counterfactual prime d'activite gain among CNAF benef
spmap m_d_ppa_contrefact19 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/PA_contrefact19.png", as(png) name("Graph") replace 

// Counterfactual prime d'acitivite gain among population
spmap m_d_ppa_contrefact_pop19  using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/PA_contrefact19_pop.png", as(png) name("Graph") replace 

// Counterfactual prime d'activite eligibles (no adjustment)
spmap eligible_diff19 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/eligible_contrefact19.png", as(png) name("Graph") replace 

// Counterfactual prime d'activite eligibles among population
spmap eligible_diff_pop19 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/eligible_pop_contrefact19.png", as(png) name("Graph") replace 


** V. DELTA **

// Delta difference  ( (Mar19 - Nov18) / Nov18 ) in the average amount of prime d'activite in life zones among population
spmap delta_mtppaver_pop using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/delta_PA_pop.png", as(png) name("Graph") replace 

// Delta difference  ( (Mar19 - Nov18) / Nov18 ) in the number of beneficiaries in life zones among population
spmap delta_benef_pop using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/delta_benef_pop.png", as(png) name("Graph") replace 


// Delta difference  ( (Simule19 - Counterfactual) / Simule19 ) in the counterfactual in life zones among population
spmap delta_contrefact_19 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" ,  id(_ID) fcolor(Blues2) osize(0.000 ..) ocolor(black) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/delta_contrefact_19.png", as(png) name("Graph") replace 


set graphics on
