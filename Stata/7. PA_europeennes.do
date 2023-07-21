

**** I. PA AMOUNTS AND VOTES EUROPENNES 2019 ****



use "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Europeennes 2019/dta/europeennes2019.dta"

//rename insee_code bv2022_code

save "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Europeennes 2019/dta/europeennes2019.dta", replace

merge 1:1 bv2022_code using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/final_bv.dta"
save "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/PA_europ.dta", replace

replace dept=int(bv2022_code/1000) 

// Delta : correlation and regression
pwcorr LREM2019 FN2019 FI2019 LR2019 ABS2019 delta_contrefact_19, star(.05)
pwcorr LREM2019 FN2019 FI2019 LR2019 ABS2019 delta_benef_pop, star(.05)
pwcorr LREM2019 FN2019 FI2019 LR2019 ABS2019 delta_mtppaver_pop, star(.05)

reghdfe LREM2019 delta_contrefact_19, absorb(dept) cluster(dept)
estimates store reg
esttab reg, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs

reghdfe LREM2019 delta_contrefact_19 standard_living frac_executives_2016 frac_bac_2016 density EM2017, absorb(dept) cluster(dept)
estimates store reg
esttab reg, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) nonum nomtitles label booktabs

