cd "\\Client\C$\Users\...\Stata Data"
clear
local myfilelist : dir . files"*.csv"

foreach file of local myfilelist {
drop _all
import delimited `file', varnames(3) encoding(UTF-8) clear
gen id = "`file'"
encode(id), gen(county)
drop id

*convert to date
destring textbox7, generate(date2) ignore("Period Ending" "/")
generate date3 = string(date2, "%08.0f")
generate date = date(date3,"MDY")
format date %td
drop textbox7
drop date2
drop date3

*convert dummy
encode policy_type_nm, generate(policy_type)
drop policy_type_nm

*convert to numeric
destring *tot, replace ignore(",")
destring textbox*, replace ignore(",")

*rename variables
rename textbox1 pif_exw 
rename textbox3 exp_pif_inw
rename textbox4 pif_inw
rename textbox5 exp_pif_exw
rename textbox6 prem_inw_tot
rename pexw_tot prem_exw_tot
rename textbox9 transfer_policy
rename textbox10 receive_policy

*drop unknown variables
drop textbox*

*label, too much work though
label variable pif_tot "Policies in Force"
label variable churr_tot "Policies Cancelled due to Hurricane Risk"

label variable pif_tot "Policies in force"
label variable can_tot "Number of policies canceled"
label variable nonr_tot "Number of policies nonrenewed"
label variable churr_tot "Number of policies canceled due to hurricane risk"
label variable nrhurr_tot "Number of policies nonrenewed due to hurricane risk"
label variable new_tot "Number of new policies written"
label variable pif_exw "Policies in force that exclude wind coverage"
label variable exp_pif_inw "Total $ value of exposure for policies in force that include wind coverage"
label variable prem_tot "Total premiums written"
label variable pif_inw "Policies in force that include wind coverage"
label variable exp_pif_exw "Total $ value of exposure for policies in force that exclude wind coverage"
label variable prem_inw_tot "Direct premium written for policies in force that include wind coverage"
label variable prem_exw_tot "Direct premium written for policies in force that exclude wind coverage"
label variable transfer_policy "Number of policies transferred to other insurers"
label variable receive_policy "Number of policies received from other insurers"


*key definitions
*Total Premiums Written: The dollar amount of premiums written for all policies in force.
*Wind Coverage: Insurance coverage for the perils of windstorm.
*(Policies) In Force: The number of policies including policies assumedthrough Citizens Property Insurance Corporation thatare in force through the last day of the reporting period. Also known as PIF.

*generate per capita
gen prem_pc = prem_tot/pif_tot
replace prem_pc = 0 if missing(prem_pc)


local outfile = subinstr("`file'",".csv","",.)
save "`outfile'", replace
}
drop _all
use qsrtotalall
append using qsrtotalmiamidade qsrtotalbroward qsrtotalmonroe qsrtotalbrevard qsrtotalcharlotte qsrtotalcollier qsrtotaldesoto qsrtotalglades qsrtotalhardee qsrtotalhendry qsrtotalhighlands qsrtotalhillsborough qsrtotalindianriver qsrtotallee qsrtotalmanatee qsrtotalmartin qsrtotalokeechobee qsrtotalorange qsrtotalosceola qsrtotalpalm qsrtotalpinellas qsrtotalpolk qsrtotalsarasota qsrtotalstlucie, gen(id)

drop county
gen county = "all" if id==0
replace county = "miami dade" if id==1
replace county = "broward" if id==2
replace county = "monroe" if id==3
replace county = "brevard" if id==4
replace county = "charlotte" if id==5
replace county = "collier" if id==6
replace county = "de soto" if id==7
replace county = "glades" if id==8
replace county = "hardee" if id==9
replace county = "hendry" if id==10
replace county = "highlands" if id==11
replace county = "hillsborough" if id==12
replace county = "indian river" if id==13
replace county = "lee" if id==14
replace county = "manatee" if id==15
replace county = "martin" if id==16
replace county = "okeechobee" if id==17
replace county = "orange" if id==18
replace county = "osceola" if id==19
replace county = "palm" if id==20
replace county = "pinellas" if id==21
replace county = "polk" if id==22
replace county = "sarasota" if id==23
replace county = "st lucie" if id==24

*add percentage of population with property less than 4 ft above mean sea level according to 2010 Census
gen slr_perc_pop = 12.5 if county == "broward"
replace slr_perc_pop = 0.3 if county == "hendry"
replace slr_perc_pop = 2.5 if county == "hillsborough" 
replace slr_perc_pop = 6.1 if county == "lee"
replace slr_perc_pop = 3.8 if county == "sarasota"
replace slr_perc_pop = 0 if county == "orange"
replace slr_perc_pop = 0 if county == "okeechobee"
replace slr_perc_pop = 1.9 if county == "palm"
replace slr_perc_pop = 2.4 if county == "st lucie"
replace slr_perc_pop = 0.1 if county == "de soto"
replace slr_perc_pop = 3.1 if county == "indian river"
replace slr_perc_pop = 8.6 if county == "pinellas"
replace slr_perc_pop = 2.8 if county == "brevard"
replace slr_perc_pop = 10.7 if county == "miami dade"
replace slr_perc_pop = 66.5 if county == "monroe"
replace slr_perc_pop = 3.3 if county == "martin"
replace slr_perc_pop = 7.4 if county == "manatee"
replace slr_perc_pop = 8.7 if county == "collier"
replace slr_perc_pop = 9.2 if county == "charlotte"

save QSRmaster, replace
