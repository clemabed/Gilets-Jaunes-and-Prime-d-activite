**** MAPPING OF ONLINE MOB AT DEPARTMENT LEVEL ****


**** STATIC MAPPING ****


** I. DATA PREPROCESSING **

cd "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata"

import delimited sentences_dep.csv

sort dep
//destring dep, gen(dept) force
rename dep dept
keep  dept totalsentencesgeo totalmessagesgeo sentimentgeo totalsentencesfiltered totalmessagesfiltered sentimentfiltered
drop if dept == .
duplicates drop dept, force

save sentences_dep.dta, replace

// Ratio to the population
clear
cd "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata"

import delimited Pop_BV.csv
destring bv2022, gen(bv2022_code) force
gen dept=int(bv2022_code/1000) 
merge m:1 dept using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/sentences_dep.dta"
drop _merge

keep populationtotale dept
egen department_population = total(populationtotale), by(dept)
keep department_population dept
duplicates drop 
sort dept
merge m:1 dept using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/sentences_dep.dta"
drop _merge

gen totalmessagesfiltered_pop = totalmessagesfiltered/department_population
gen totalmessagesgeo_pop = totalmessagesgeo/department_population
gen totalsentencesfiltered_pop = totalsentencesfiltered/department_population
gen totalsentencesgeo_pop = totalsentencesgeo/department_population

egen totalmessagesfiltered_pop_std = std(totalmessagesfiltered_pop)
egen totalmessagesgeo_pop_std = std(totalmessagesgeo_pop)
egen totalsentencesfiltered_pop_std = std(totalsentencesfiltered_pop)
egen totalsentencesgeo_pop_std = std(totalsentencesgeo_pop)
save sentences_dep.dta, replace


** II. MAP PREPROCESSING **

cd "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes"
spshape2dta bv2022_2022.shp, replace saving(bv2022)

use "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022.dta", clear
destring bv2022, gen(bv2022_code) force
//We drop municipalities outside of mainland France
drop if bv2022_code == . | bv2022_code>97000
gen dept=int(bv2022_code/1000) 

merge m:1 dept using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/sentences_dep.dta", keep(master match)

colorpalette w3 blue, n(2) nograph
local colors `r(p)'

** III. MAPPING **

// a. TOTAL GEOLOCATED DATASET 

// totalsentencesgeo
spmap totalsentencesgeo_pop_std using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.000 ..) clmethod(custom) clbreaks(-1.5 -0.6 -0.20 0.3 6.6) legstyle(2) legend(symxsize(*3)) legend(size(medium)) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesgeo.png", as(png) name("Graph") replace 


// totalmessagesgeo
spmap totalmessagesgeo_pop_std using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2)  ndsize(0.000 ..) clmethod(custom) clbreaks(-1.42 -0.5 -0.24 0.19 6.9) legstyle(2) legend(symxsize(*3)) legend(size(medium)) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesgeo.png", as(png) name("Graph") replace clmethod(custom) 

//  b. FILTERED GEOLOCATED DATASET 

// totalsentencesfiltered
spmap totalsentencesfiltered_pop_std using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2)  ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) clmethod(custom) clbreaks(-1.31 -0.7 -0.26 0.32 6.5) legend(size(medium)) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesfiltered.png", as(png) name("Graph") replace


// totalmessagesfiltered
spmap totalmessagesfiltered_pop_std using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2)  ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(-1.4 -0.54 -0.23 0.14 6.9)
graph export  "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesfiltered.png", as(png) name("Graph") replace


// c. SENTIMENT POLARITY

colorpalette viridis, n(10) nograph reverse
local colors `r(p)'

// sentimentgeo
spmap sentimentgeo using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp", id(_ID) fcolor("`colors'") ocolor("`colors'") clmethod(custom) clbreaks(-0.1 -0.02 -0.01 0.002 0.06) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentgeo.png", as(png) name("Graph") replace 


colorpalette viridis, n(10) nograph reverse
local colors `r(p)'

// sentimentfiltered 
spmap sentimentfiltered using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") clmethod(custom) clbreaks(-0.13 -0.015 0.016 0.04 0.15) ndsize(0.000 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentfiltered.png", as(png) name("Graph") replace

clear 




**** DYNAMIC MAPPING ****

** I. DATA PREPROCESSING **

cd "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata"

import delimited sentences_dep_month.csv

sort dep
destring dep, gen(dept) force
rename dep dept
drop if dept == .
duplicates drop dept, force

save sentences_dep_month.dta, replace


// Ratio to the population

clear
cd "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata"

import delimited Pop_BV.csv
destring bv2022, gen(bv2022_code) force
gen dept=int(bv2022_code/1000) 
merge m:1 dept using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/sentences_dep_month.dta"
drop _merge

keep populationtotale dept
egen department_population = total(populationtotale), by(dept)
keep department_population dept
duplicates drop 
sort dept
merge m:1 dept using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/sentences_dep_month.dta"
drop _merge

//cd "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata"
//use final_bv.dta
//keep Population_totale dept
//egen department_population = total(Population_totale), by(dept)
//keep department_population dept
//duplicates drop 
//sort dept
//merge m:1 dept using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/sentences_dep_month.dta"
//drop _merge

rename sentimentfiltered_201809filtered sentiment_fil_0918
rename sentimentfiltered_201810filtered sentiment_fil_1018
rename sentimentfiltered_201811filtered sentiment_fil_1118
rename sentimentfiltered_201812filtered sentiment_fil_1218
rename sentimentfiltered_201901filtered sentiment_fil_0119 
rename sentimentfiltered_201902filtered sentiment_fil_0219 
rename sentimentfiltered_201903filtered sentiment_fil_0319  

rename sentimentgeo_201809geo sentiment_geo_0918
rename sentimentgeo_201810geo sentiment_geo_1018
rename sentimentgeo_201811geo sentiment_geo_1118
rename sentimentgeo_201812geo sentiment_geo_1218
rename sentimentgeo_201901geo sentiment_geo_0119
rename sentimentgeo_201902geo sentiment_geo_0219
rename sentimentgeo_201903geo sentiment_geo_0319

gen mess_fil_0918 = totalmessagesfiltered_201809filt*10^6/department_population
gen mess_fil_1018 = totalmessagesfiltered_201810filt*10^6/department_population
gen mess_fil_1118 = totalmessagesfiltered_201811filt*10^6/department_population
gen mess_fil_1218 = totalmessagesfiltered_201812filt*10^6/department_population
gen mess_fil_0119 = totalmessagesfiltered_201901filt*10^6/department_population
gen mess_fil_0219 = totalmessagesfiltered_201902filt*10^6/department_population
gen mess_fil_0319 = totalmessagesfiltered_201903filt*10^6/department_population

gen mess_geo_0918 = totalmessagesgeo_201809geo*10^6/department_population
gen mess_geo_1018 = totalmessagesgeo_201810geo*10^6/department_population
gen mess_geo_1118 = totalmessagesgeo_201811geo*10^6/department_population
gen mess_geo_1218 = totalmessagesgeo_201812geo*10^6/department_population
gen mess_geo_0119 = totalmessagesgeo_201901geo*10^6/department_population
gen mess_geo_0219 = totalmessagesgeo_201902geo*10^6/department_population
gen mess_geo_0319 = totalmessagesgeo_201903geo*10^6/department_population

gen sent_fil_0918 = totalsentencesfiltered_201809fil*10^6/department_population
gen sent_fil_1018 = totalsentencesfiltered_201810fil*10^6/department_population
gen sent_fil_1118 = totalsentencesfiltered_201811fil*10^6/department_population
gen sent_fil_1218 = totalsentencesfiltered_201812fil*10^6/department_population
gen sent_fil_0119 = totalsentencesfiltered_201901fil*10^6/department_population
gen sent_fil_0219 = totalsentencesfiltered_201902fil*10^6/department_population
gen sent_fil_0319 = totalsentencesfiltered_201903fil*10^6/department_population

gen sent_geo_0918 = totalsentencesgeo_201809geo*10^6/department_population
gen sent_geo_1018 = totalsentencesgeo_201810geo*10^6/department_population
gen sent_geo_1118 = totalsentencesgeo_201811geo*10^6/department_population
gen sent_geo_1218 = totalsentencesgeo_201812geo*10^6/department_population
gen sent_geo_0119 = totalsentencesgeo_201901geo*10^6/department_population
gen sent_geo_0219 = totalsentencesgeo_201902geo*10^6/department_population
gen sent_geo_0319 = totalsentencesgeo_201903geo*10^6/department_population

drop total*
save sentences_dep_month.dta, replace


** II. MAP PREPROCESSING **

cd "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes"
spshape2dta bv2022_2022.shp, replace saving(bv2022)

use "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022.dta", clear
destring bv2022, gen(bv2022_code) force
//We drop municipalities outside of mainland France
drop if bv2022_code == . | bv2022_code>97000

gen dept=int(bv2022_code/1000) 

merge m:1 dept using "/Users/clementineabed-meraim/Documents/Memoire/Data/Stata/sentences_dep_month.dta", keep(master match)


colorpalette w3 blue, n(2) nograph
local colors `r(p)'

** III. MAPPING **

// a. TOTAL GEOLOCATED DATASET 

///// Total sentences evolution 

// sept 2018
spmap sent_geo_0918 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 50 100 200 300 400 600 2050)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesgeo-09-18.png", as(png) name("Graph") replace 

// oct 2018
spmap sent_geo_1018 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))  clmethod(custom) clbreaks(0 10 50 100 200 300 400 600 2050)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesgeo-10-18.png", as(png) name("Graph") replace 

// nov 2018
spmap sent_geo_1118 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 50 100 200 300 400 600 2050)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesgeo-11-18.png", as(png) name("Graph") replace 

// dec 2018
spmap sent_geo_1218 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 50 100 200 300 400 600 2050)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesgeo-12-18.png", as(png) name("Graph") replace 

// jan  2019
spmap sent_geo_0119 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 50 100 200 300 400 600 2050)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesgeo-01-19.png", as(png) name("Graph") replace 

// fev  2019
spmap sent_geo_0219 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 50 100 200 300 400 600 2050)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesgeo-02-19.png", as(png) name("Graph") replace 


// mar  2019
spmap sent_geo_0319 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 50 100 200 300 400 600 2050)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesgeo-03-19.png", as(png) name("Graph") replace 


///// Total messages evolution

// sept 2018 
spmap mess_geo_0918 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))  clmethod(custom) clbreaks(0 5 30 100 150 200 300 500 1300)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesgeo-09-18.png", as(png) name("Graph") replace 


// oct 2018
spmap mess_geo_1018 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom)  clbreaks(0 5 30 100 150 200 300 500 1300)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesgeo-10-18.png", as(png) name("Graph") replace 

// nov 2018
spmap mess_geo_1118 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom)  clbreaks(0 5 30 100 150 200 300 500 1300)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesgeo-11-18.png", as(png) name("Graph") replace 

// dec 2018
spmap mess_geo_1218 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom)  clbreaks(0 5 30 100 150 200 300 500 1300)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesgeo-12-18.png", as(png) name("Graph") replace 

// jan  2019
spmap mess_geo_0119 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom)  clbreaks(0 5 30 100 150 200 300 500 1300)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesgeo-01-19.png", as(png) name("Graph") replace 

// fev  2019
spmap mess_geo_0219 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom)  clbreaks(0 5 30 100 150 200 300 500 1300)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesgeo-02-19.png", as(png) name("Graph") replace 

// mar  2019
spmap mess_geo_0319 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom)  clbreaks(0 5 30 100 150 200 300 500 1300)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesgeo-03-19.png", as(png) name("Graph") replace 




///// Total sentiment evolution

colorpalette viridis, n(12) nograph reverse
local colors `r(p)'

// sept 2018 : 
spmap sentiment_geo_0918 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentgeo-09-18.png", as(png) name("Graph") replace 


// oct 2018
spmap sentiment_geo_1018 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentgeo-10-18.png", as(png) name("Graph") replace 


// nov 2018
spmap sentiment_geo_1118  using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentgeo-11-18.png", as(png) name("Graph") replace 

// dec 2018
spmap sentiment_geo_1218  using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentgeo-12-18.png", as(png) name("Graph") replace 

// jan  2019
spmap sentiment_geo_0119 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks( -0.8 -0.4 -0.2 -0.1 -0.05 0 0.05 0.10 0.2 0.4 0.8)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentgeo-01-19.png", as(png) name("Graph") replace 

// fev  2019
spmap sentiment_geo_0219 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks( -0.8 -0.4 -0.2 -0.1 -0.05 0 0.05 0.10 0.2 0.4 0.8)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentgeo-12-02.png", as(png) name("Graph") replace 

// mar  2019
spmap sentiment_geo_0319 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks( -0.8 -0.4 -0.2 -0.1 -0.05 0 0.05 0.10 0.2 0.4 0.8)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentgeo-03-19.png", as(png) name("Graph") replace 



// b. FILTERED GEOLOCATED DATASET  

//// Filtered sentences 

// sept 2018
spmap sent_fil_0918 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 5 10 20 40 60 100 200 500)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesfil-09-18.png", as(png) name("Graph") replace 

// oct 2018
spmap sent_fil_1018 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 5 10 20 40 60 100 200 500)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesfil-10-18.png", as(png) name("Graph") replace 

// nov 2018
spmap sent_fil_1118 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 5 10 20 40 60 100 200 500)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesfil-11-18.png", as(png) name("Graph") replace 

// dec 2018
spmap sent_fil_1218 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 5 10 20 40 60 100 200 500)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesfil-12-18.png", as(png) name("Graph") replace  

// jan  2019
spmap sent_fil_0119 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 5 10 20 40 60 100 200 500)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesfil-01-19.png", as(png) name("Graph") replace 

// fev  2019
spmap sent_fil_0219  using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 5 10 20 40 60 100 200 500)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesfil-02-19.png", as(png) name("Graph") replace 

// mar  2019
spmap sent_fil_0319  using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 5 10 20 40 60 100 200 500)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalsentencesfil-03-19.png", as(png) name("Graph") replace 



//// Filtered messages 


// sept 2018
spmap sent_geo_0918 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 20 30 40 60 80 300 500)  
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesfil-09-18.png", as(png) name("Graph") replace 

// oct 2018
spmap mess_fil_1018 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 20 30 40 60 80 300 500) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesfil-10-18.png", as(png) name("Graph") replace 

// nov 2018
spmap mess_fil_1118 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 20 30 40 60 80 300 500) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesfil-11-18.png", as(png) name("Graph") replace 

// dec 2018
spmap mess_fil_1218 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 20 30 40 60 80 300 500) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesfil-12-18.png", as(png) name("Graph") replace  

// jan  2019
spmap mess_fil_0119 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 20 30 40 60 80 300 500) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesfil-01-19.png", as(png) name("Graph") replace 

// fev  2019
spmap mess_fil_0219 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))  clmethod(custom) clbreaks(0 10 20 30 40 60 80 300 500) 
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesfil-02-19.png", as(png) name("Graph") replace 

// mar  2019
spmap mess_fil_0319 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor(Blues2) ocolor(Blues2) ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks(0 10 20 30 40 60 80 300 500)  
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/totalmessagesfil-03-19.png", as(png) name("Graph") replace 



///// Filtered sentiment polarity 
clear 


colorpalette viridis, n(12) nograph reverse
local colors `r(p)'


// sept 2018 : 
// spmap sentiment_fil_0918 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium)) clmethod(custom) clbreaks( -0.8 -0.4 -0.2 -0.1 -0.05 0 0.05 0.10 0.2 0.4 0.8)
//graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentfil-09-18.png", as(png) name("Graph") replace 

// oct 2018
spmap sentiment_fil_1018 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))  clmethod(custom) clbreaks( -1 -0.4 -0.2 -0.1 -0.05 0 0.05 0.10 0.2 0.4 1)
 graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentfil-10-18.png", as(png) name("Graph") replace 

// nov 2018
spmap sentiment_fil_1118 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))  clmethod(custom) clbreaks( -1 -0.4 -0.2 -0.1 -0.05 0 0.05 0.10 0.2 0.4 1)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentfil-11-18.png", as(png) name("Graph") replace 

// dec 2018
spmap sentiment_fil_1218 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))  clmethod(custom) clbreaks( -1 -0.4 -0.2 -0.1 -0.05 0 0.05 0.10 0.2 0.4 1)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentfil-12-18.png", as(png) name("Graph") replace 

// jan  2019
spmap sentiment_fil_0119 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))  clmethod(custom) clbreaks( -1 -0.4 -0.2 -0.1 -0.05 0 0.05 0.10 0.2 0.4 1)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentfil-01-19.png", as(png) name("Graph") replace 

// fev  2019
spmap sentiment_fil_0219 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))  clmethod(custom) clbreaks( -1 -0.4 -0.2 -0.1 -0.05 0 0.05 0.10 0.2 0.4 1)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentfil-02-19.png", as(png) name("Graph") replace 

// mar  2019
spmap sentiment_fil_0319 using "/Users/clementineabed-meraim/Documents/Memoire/Data/Sources/Cartes/bv2022_shp" , id(_ID) fcolor("`colors'") ocolor("`colors'") ndsize(0.020 ..) legstyle(2) legend(symxsize(*3)) legend(size(medium))  clmethod(custom) clbreaks( -1 -0.4 -0.2 -0.1 -0.05 0 0.05 0.10 0.2 0.4 1)
graph export "/Users/clementineabed-meraim/Documents/Memoire/Output/Maps/sentimentfil-03-19.png", as(png) name("Graph") replace 


