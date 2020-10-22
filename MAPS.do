**With only this file you can run th whole do-file
**use the address to the following folder: FARA DATA>HiTech Digitalization>STATA
global Hitech_stata "C:\Users\verop\Dropbox\FARA DATA\HiTech Digitalization\STATA"


global TABLES "C:\Users\verop\Veronica Dropbox\Veronica Perez\FARA DATA\HiTech Digitalization\STATA\Files\Presentation\TABLES"

cd "C:\Users\verop\Veronica Dropbox\Veronica Perez\FARA DATA\HiTech Digitalization\STATA\do\Maps"


shp2dta using "$Hitech_stata\do\Maps\databases\ne_10m_admin_0_countries\ne_10m_admin_0_countries"  ////
, data(worlddata2) coor(worldcoor2) genid(id) replace


***using the database created previously
use "$Hitech_stata\do\Maps\databases\worlddata2", clear

**we change the name so its the same as in the data
gen Country_Namesn9_ = upper(ADMIN)
sort Country_Namesn9_
merge 1:1 Country_Namesn9_ using "$Hitech_stata\Files\Presentation\FARA_MAPS_2"
tab Country_Namesn9_  if _merge == 2

replace n = 0 if n == .
replace n = . if Country_Namesn9_ == "UNITED STATES OF AMERICA"


spmap n using worldcoor2.dta if ADMIN!="Antarctica", id(id) fcolor(Blues) ndfcolor(red) clnumber(5) legend(symy(*2) symx(*2) size(*2)) legorder(lohi) clmethod(custom) clbreaks(0,2,3,6,8,79) legend(label(2 "0-2") label(3 "3") label(4 "4-6") label(5 "7-8") label(6 "9-79") label(1 "United States"))

graph export "$Hitech_stata\Files\Presentation\MAP_FP.png", replace

tabout Country_Namesn9_ using "$Hitech_stata\Files\Presentation\TABLES\between8and9.tex" if n > 8, replace ///
style(tex) font(bold) twidth(20) ///
title(Table 2: Countries with 9 or more Foreign Principals) 

********************************************************************************
	
use "$Hitech_stata\do\Maps\databases\worlddata2", clear

**we change the name so its the same as in the data
gen Country_Namesn9_ = upper(ADMIN)
sort Country_Namesn9_
merge 1:1 Country_Namesn9_ using "$Hitech_stata\Files\FARA_MAPS_1"
tab Country_Namesn9_  if _merge == 2

keep if _merge == 3

spmap n using worldcoor2.dta if ADMIN!="Antarctica", id(id) fcolor(Blues) clnumber(5) legend(symy(*2) symx(*2) size(*2)) legorder(lohi) clmethod(q)
graph export "$Hitech_stata\Files\Presentation\MAP_FP_2.png", replace


	
	
*******SECOND MAP
use "$Hitech_stata\do\Maps\databases\worlddata2", clear

**we change the name so its the same as in the data
gen Country_Namesn9_ = upper(ADMIN)
sort Country_Namesn9_
merge 1:1 Country_Namesn9_ using "$presentation\FARA2"
drop _merge
merge 1:1 Country_Namesn9_ using "$presentation\FARA_MAPS_1"

replace Money_million = 0 if Money_million == .

gen average = Money_million/n
replace average = 0 if average == .
replace average = . if Country_Namesn9_ == "UNITED STATES OF AMERICA"

spmap average using worldcoor2.dta if ADMIN!="Antarctica", id(id) ndfcolor(red) fcolor(Blues) clnumber(5) legend(symy(*2) symx(*2) size(*2)) legorder(lohi) clmethod(q) legend(label(1 "United States"))
graph export "$Hitech_stata\Files\Presentation\MAP_MONEY.png", replace

tabout Country_Namesn9_ using "$Hitech_stata\Files\Presentation\TABLES\moremoney.tex" if Money_million > 213.439, replace ///
style(tex) font(bold) twidth(20) ///
title(Table 3: Countries that spent more money) 
