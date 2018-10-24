*IHDS wave1 and wave2 merged
*Previous cleaning
gen byte clstatus=0
replace clstatus=1 if xchildlabour_bi==0 & childlabour_bi==0
replace clstatus=2 if xchildlabour_bi==0 & childlabour_bi==1
replace clstatus=3 if xchildlabour_bi==0 & childlabour_bi==2
replace clstatus=4 if xchildlabour_bi==1 & childlabour_bi==0
replace clstatus=5 if xchildlabour_bi==1 & childlabour_bi==1
replace clstatus=6 if xchildlabour_bi==1 & childlabour_bi==2
replace clstatus=7 if xchildlabour_bi==2 & childlabour_bi==0
replace clstatus=8 if xchildlabour_bi==2 & childlabour_bi==1
replace clstatus=9 if xchildlabour_bi==2 & childlabour_bi==2


** wave1 -10 wave2 5-17
tab RO5 if childlabour_bi==1 & xRO5<=15 & HHWAVES==11 & RO5<18
tab xchildlabour_bi if childlabour_bi==1 & xRO5<=15 & HHWAVES==11 & RO5<18
tab xRO5 if childlabour_bi==1 & HHWAVES==15 & RO5<18
tab xRO5 if xchildlabour_bi==1 & xRO5<=15 & HHWAVES==11 & RO5<18

** (to be child labour in wave2) no.2,5,8 
** (to be non child labour in wave2)no 1,4,7
** (to be nowherechildren) no 3,6,9

rename FM4A land
rename FM4 xland

*start from here!!*
use "E:\PhD 1st year\2-3 Paper2\R\paper02_merge_0530.dta", clear
*number of silibing

replace childlabour_bi=0 if childlabour_bi==2
replace xchildlabour_bi=0 if xchildlabour_bi==2

drop count count2 count3 xcount1 xcount2 xcount3
drop xsiblings siblings xsiblings2 siblings2

*by xIDHH (xCASEID), sort: gen xpid = _n
*gen xc=1 if xRO4==3
*gen xd=1 if xRO4==5
*gen xh=1 if (xRO4==1|xRO4==7)
bysort xIDHH:  egen byte xcount1 = total(xc) if xc==1 & xRO4==3
bysort xIDHH xRO8:  egen byte xcount2 = total(xd) if xd==1 & xRO4==5
bysort xIDHH xRO8:  egen byte xcount3 = total(xh) if xh==1
by xIDHH, sort: gen xsiblings=xcount1 if xc==1 & xRO4==3
by xIDHH xRO8, sort: replace xsiblings=xcount2 if xd==1 & xRO4==5
by xIDHH xRO8, sort: replace xsiblings=xcount3 if xh==1
gen xsiblings2=xsiblings-1

bysort IDHH:  egen byte count1 = total(c) if c==1 & RO4==3
bysort IDHH RO9:  egen byte count2 = total(d) if d==1 & RO4==5
bysort IDHH RO9:  egen byte count3 = total(h) if h==1

by IDHH, sort: gen siblings=count1 if c==1 & RO4==3
by IDHH RO9, sort: replace siblings=count2 if d==1 & RO4==5
by IDHH RO9, sort: replace siblings=count3 if h==1
gen siblings2=siblings-1

*social group
replace GROUPS=0 if (GROUPS==1 | GROUPS==2 | GROUPS==.)
replace GROUPS=1 if GROUPS==3
replace GROUPS=2 if GROUPS==4
replace GROUPS=3 if GROUPS==5
replace GROUPS=4 if GROUPS==6
replace GROUPS=5 if GROUPS==7
label drop GROUPS
label define GROUPS 0 "Upper caste" 1 "OBC"  2 "Dalit" 3  "Adivasi" 4 "Muslim" 5 "Christianity"
label values  GROUPS  GROUPS

*firstone's gender
gen neg_age = - RO5
bysort IDHH (neg_age): egen order1=rank(neg_age) if c==1 & RO4==3, unique
bysort  IDHH RO9 (neg_age): egen order2=rank(neg_age) if d==1 & RO4==5, unique
bysort  IDHH RO9 (neg_age): egen order3=rank(neg_age) if h==1, unique

by IDHH, sort: gen firstgender = 0 if order1==1 & sex==0 & c==1 & RO4==3
replace firstgender = 0 if order2==1 & sex==0 & d==1 & RO4==5
replace firstgender = 0 if order3==1 & sex==0 & h==1

replace firstgender = 1 if order1==1 & sex==1 & c==1 & RO4==3
replace firstgender = 1 if order2==1 & sex==1 & d==1 & RO4==5
replace firstgender = 1 if order3==1 & sex==1 & h==1

bysort IDHH: replace firstgender = sum(firstgender) if c==1 & RO4==3
bysort IDHH RO9: replace firstgender = sum(firstgender) if d==1 & RO4==5
bysort IDHH RO9: replace firstgender = sum(firstgender) if h==1

*first male-female
gen genderdiff1 = 1 if firstgender==0 & xsex==1
replace genderdiff1 = 0 if genderdiff1==.
*first female-male
gen genderdiff2 = 1 if firstgender==1 & xsex==0
replace genderdiff2 = 0 if genderdiff2==.

*Age rank
by IDHH, sort: gen agerank2=order1 if c==1 & RO4==3
by IDHH RO9, sort: replace agerank2=order2 if d==1 & RO4==5
by IDHH RO9, sort: replace agerank2=order3 if h==1

*female headed households
gen femheaded2 = 1  if RO4==1 & sex==1
bysort IDHH: egen sumfemheaded2=total(femheaded2) 
by IDHH, sort: gen femheadedhh2=1 if sumfemheaded2>= 1
replace femheadedhh2=0 if femheadedhh2==.


*10/2, variable renames
rename childlabour_bi childlabour2
rename xchildlabour_bi childlabour1
rename GROUPS socialgroup
rename agec2 agecsq2
rename agec agec2
rename xagec2 agecsq1
rename xagec agec1
drop age2
rename RO5 age2
rename xRO5 age1
rename siblings2 numsibling2
rename xsiblings2 numsibling1
rename INCOME income2
rename xINCOME income1
rename land land2
rename xland land1
rename URBAN2011 ruralurban2
rename xURBAN ruralurban1
rename xtotal_hours total_hours1
rename Total_hours total_hours2
rename firstgender firstgender2


*missing1
replace land1=0 if land1==.
replace land2=0 if land2==.
replace numsibling1=0 if numsibling1==.
replace numsibling2=0 if numsibling2==.
 

*social group  dummy
gen socialgroup0=1 if socialgroup==0
replace socialgroup0=0 if socialgroup!=0
gen socialgroup1=1 if socialgroup==1
replace socialgroup1=0 if socialgroup!=1
gen socialgroup2=1 if socialgroup==2
replace socialgroup2=0 if socialgroup!=2
gen socialgroup3=1 if socialgroup==3
replace socialgroup3=0 if socialgroup!=3
gen socialgroup4=1 if socialgroup==4
replace socialgroup4=0 if socialgroup!=4
gen socialgroup5=1 if socialgroup==5
replace socialgroup5=0 if socialgroup!=5

*age centered
drop agec1 agec2 agecsq1 agecsq2
egen meanage1 = mean(age1)
egen meanage2 = mean(age2)
gen agec1= age1 - meanage1
gen agec2= age2 - meanage2
gen agecsq1=agec1*agec1
gen agecsq2=agec2*agec2


*num of sibling under 18
gen cc18=1 if RO4==3 & age2<18 & age2>4
bysort IDHH:  egen byte count4 = total(cc18) if cc18==1 & RO4==3 

gen dd18=1 if RO4==5 & age2<18 & age2>4
bysort IDHH RO9:  egen byte count5 = total(dd18) if dd18==1 & RO4==5 

gen hh18=1 if (RO4==1|RO4==7) & age2<18 & age2>4
bysort IDHH RO9:  egen byte count6 = total(hh18) if hh18==1 

by IDHH, sort: gen siblingsunder18=count4 if cc==1 & RO4==3
by IDHH RO9, sort: replace siblingsunder18=count5 if dd==1 & RO4==5
by IDHH RO9, sort: replace siblingsunder18=count6 if hh==1


*eldest one' working status
by IDHH, sort: gen firstworking0=0 if childlabour2==0 & (order1==1 |order2==1 |order3==1) & age2<18 & age2>4
replace firstworking0=1 if childlabour2==1 & (order1==1 |order2==1 |order3==1) & age2<18 & age2>4
bysort IDHH: egen firstworking1=total(firstworking0) if c==1 & RO4==3
bysort IDHH RO9: egen firstworking2=total(firstworking0) if d==1 & RO4==5
bysort IDHH RO9: egen firstworking3=total(firstworking0) if h==1
egen firstworking=rowmax(firstworking1 firstworking2 firstworking3)
replace firstworking=0 if firstworking==.


gen xneg_age = - age1
bysort xIDHH (xneg_age): egen xorder1=rank(xneg_age) if xc==1 & xRO4==3, unique
bysort  xIDHH xRO8 (xneg_age): egen xorder2=rank(xneg_age) if xd==1 & xRO4==5, unique
bysort  xIDHH xRO8 (xneg_age): egen xorder3=rank(xneg_age) if xh==1, unique
by xIDHH, sort: gen xfirstworking0=0 if childlabour1==0 & (xorder1==1 |xorder2==1 |xorder3==1) & age1<18 & age1>4
replace xfirstworking0=1 if childlabour1==1 & (xorder1==1 |xorder2==1 |xorder3==1)  & age1<18 & age1>4
bysort xIDHH: egen xfirstworking1=total(xfirstworking0) if xc==1 & xRO4==3
bysort xIDHH xRO8: egen xfirstworking2=total(xfirstworking0) if xd==1 & xRO4==5
bysort xIDHH xRO8: egen xfirstworking3=total(xfirstworking0) if xh==1
egen xfirstworking=rowmax(xfirstworking1 xfirstworking2 xfirstworking3)
replace xfirstworking=0 if xfirstworking==.

*eldest one' working hours
by IDHH, sort: gen firstworkinghours0=total_hours1 if (order1==1 |order2==1 |order3==1) 
bysort IDHH: egen firstworkinghours1=total(firstworkinghours0) if c==1 & RO4==3
bysort IDHH RO9: egen firstworkinghours2=total(firstworkinghours0) if d==1 & RO4==5
bysort IDHH RO9: egen firstworkinghours3=total(firstworkinghours0) if h==1
egen firstworkinghours=rowmax(firstworkinghours1 firstworkinghours2 firstworkinghours3)
replace firstworkinghours=0 if firstworkinghours==.

by xIDHH, sort: gen xfirstworkinghours0=total_hours2 if (xorder1==1 |xorder2==1 |xorder3==1)
bysort xIDHH: egen xfirstworkinghours1=total(xfirstworkinghours0) if xc==1 & xRO4==3
bysort xIDHH xRO8: egen xfirstworkinghours2=total(xfirstworkinghours0) if xd==1 & xRO4==5
bysort xIDHH xRO8: egen xfirstworkinghours3=total(xfirstworkinghours0) if xh==1
egen xfirstworkinghours=rowmax(xfirstworkinghours1 xfirstworkinghours2 xfirstworkinghours3)
replace xfirstworkinghours=0 if xfirstworkinghours==.

save "E:\PhD 1st year\2-3 Paper2\R\practice1018.dta", clear

**saving careful!
use "E:\PhD 1st year\2-3 Paper2\R\practice1018.dta", clear
keep if age2>4 & age2<18
keep WShours domestic_hours agerank2 firstgender childlabour1 childlabour2 order1 order2 order3 CS10 WT WS5 xWS5 socialgroup STATEID DISTRICT age2 age1 total_hours2 sex agec2 agecsq2  agerank2 ruralurban2 income2 land2 numsibling2 socialgroup1 socialgroup2 socialgroup3 socialgroup4 socialgroup5 femheadedhh2 firstworkinghours xfirstworkinghours genderdiff1 genderdiff2 
save "E:\PhD 1st year\2-3 Paper2\R\practice1022.dta", replace
label drop _all
destring _all, replace

*descriptive

sum total_hours2 sex age2 agerank2 ruralurban2 income2 land2 numsibling2 i.socialgroup femheadedhh2 firstworkinghours xfirstworkinghours  firstgender if age2>4 & age2<18 & agerank2!=1
corr total_hours2 sex age2 agerank2 ruralurban2 income2 land2 numsibling2 socialgroup femheadedhh2 firstworkinghours xfirstworkinghours  firstgender if age2>4 & age2<18 & agerank2!=1
graph bar total_hours2, by(agerank2)
twoway (scatter total_hours2 age2), by(sex)



*Not in use***********************************************************************
*Age gap
by IDHH (neg_age), sort: gen agegap2=RO5[_n] - RO5[_n+1] if c==1 & siblings> 1 & siblings!=.
by IDHH RO9 (neg_age), sort: replace agegap2=RO5[_n] - RO5[_n+1] if d==1 & siblings> 1 & siblings!=.
by IDHH RO9 (neg_age), sort: replace agegap2=RO5[_n] - RO5[_n+1] if h==1 & siblings> 1 & siblings!=.

*child headed households
gen childheaded = 1  if RO5>4 & RO5<18 & RO4==1
by IDHH, sort: gen childheadedhh=1 if sum(childheaded)>= 1

*next youngest sibling- female
sort IDHH order1 (neg_age)
by IDHH (neg_age), sort: gen nysis1=1 if c==1 & sex==0 & sex[_n]!=sex[_n+1] & sex[_n+1]!=.
by IDHH (neg_age), sort: gen nysis2=1 if c==1 & sex==1 & sex[_n]==sex[_n+1] & sex[_n+1]!=.
by IDHH RO9 (neg_age), sort: gen nysis3=1 if d==1 & sex==0 & sex[_n]!=sex[_n+1] & sex[_n+1]!=.
by IDHH RO9 (neg_age), sort: gen nysis4=1 if d==1 & sex==1 & sex[_n]==sex[_n+1] & sex[_n+1]!=.
by IDHH RO9 (neg_age), sort: gen nysis5=1 if h==1 &  sex==0 & sex[_n]!=sex[_n+1] & sex[_n+1]!=.
by IDHH RO9 (neg_age), sort: gen nysis6=1 if h==1 & sex==1 & sex[_n]==sex[_n+1] & sex[_n+1]!=.
egen nysis=rowmax(nysis1  nysis2  nysis3  nysis4  nysis5  nysis6)

*next youngest siblings - male
by IDHH (neg_age), sort: gen nybro1=1 if c==1 & sex==1 & sex[_n]!=sex[_n+1] & sex[_n+1]!=.
by IDHH (neg_age), sort: gen nybro2=1 if c==1 & sex==0 & sex[_n]==sex[_n+1] & sex[_n+1]!=.
by IDHH RO9 (neg_age), sort: gen nybro3=1 if d==1 & sex==1 & sex[_n]!=sex[_n+1] & sex[_n+1]!=.
by IDHH RO9 (neg_age), sort: gen nybro4=1 if d==1 & sex==0 & sex[_n]==sex[_n+1] & sex[_n+1]!=.
by IDHH RO9 (neg_age), sort: gen nybro5=1 if h==1 & sex==1 & sex[_n]!=sex[_n+1] & sex[_n+1]!=.
by IDHH RO9 (neg_age), sort: gen nybro6=1 if h==1 & sex==0 & sex[_n]==sex[_n+1] & sex[_n+1]!=.
egen nybro=rowmax(nybro1  nybro2  nybro3  nybro4  nybro5  nybro6)


*Number of younger siblings by individuals
bysort IDHH (neg_age): egen ysibling1=max(order1) if c==1 & RO4==3
bysort  IDHH RO9 (neg_age): egen ysibling2=max(order2) if d==1 & RO4==5
bysort  IDHH RO9 (neg_age): egen ysibling3=max(order3) if h==1
by IDHH (neg_age), sort: gen ysibling4=ysibling1 - order1 if c==1 & RO4==3
by IDHH RO9 (neg_age), sort: gen ysibling5=ysibling2 - order2 if d==1 & RO4==5
by IDHH RO9 (neg_age), sort: gen ysibling6=ysibling3 - order3 if  h==1
egen ysibling=rowmax(ysibling4 ysibling5 ysibling6)

bysort xIDHH (xneg_age): egen xysibling1=max(xorder1) if xc==1 & xRO4==3
bysort  xIDHH xRO8 (xneg_age): egen xysibling2=max(xorder2) if xd==1 & xRO4==5
bysort  xIDHH xRO8 (xneg_age): egen xysibling3=max(xorder3) if xh==1
by xIDHH (xneg_age), sort: gen xysibling4=xysibling1 - xorder1 if xc==1 & xRO4==3
by xIDHH xRO8 (xneg_age), sort: gen xysibling5=xysibling2 - xorder2 if xd==1 & xRO4==5
by xIDHH xRO8 (xneg_age), sort: gen xysibling6=xysibling3 - xorder3 if  xh==1
egen numyoungsibling1=rowmax(xysibling4 xysibling5 xysibling6)

*having first male or female 
gen xRO5re=-xRO5
bysort xIDHH: egen xfemsib1=rank(-xRO5) if xRO4==3 & xsex==1
bysort xIDHH xRO8: egen xfemsib2=rank(-xRO5) if xRO4==5 & xsex==1
bysort xIDHH xRO8: egen xfemsib3=rank(-xRO5) if (xRO4==1|xRO4==7) & xsex==1

bysort xIDHH: egen xmsib1=rank(-xRO5) if xRO4==3 & xsex==0
bysort xIDHH xRO8: egen xmsib2=rank(-xRO5) if xRO4==5 & xsex==0
bysort xIDHH xRO8: egen xmsib3=rank(-xRO5) if (xRO4==1|xRO4==7) & xsex==0

replace xfemsib1=0 if xfemsib1!=1
replace xfemsib2=0 if xfemsib1!=1
replace xfemsib3=0 if xfemsib1!=1
replace xmsib1=0 if xmsib1!=1
replace xmsib2=0 if xmsib1!=1
replace xmsib3=0 if xmsib1!=1

bysort xIDHH:  egen xhfemsib1 = total(xfemsib1) if xRO4==3 
bysort xIDHH xRO8:  egen xhfemsib2 = total(xfemsib2) if xRO4==5 
bysort xIDHH xRO8:  egen xhfemsib3 = total(xfemsib3) if (xRO4==1|xRO4==7)
egen xhfemsib=rowmax(xhfemsib1 xhfemsib2 xhfemsib3)

bysort xIDHH:  egen xhmsib1 = total(xmsib1) if xRO4==3 
bysort xIDHH xRO8:  egen xhmsib2 = total(xmsib2) if xRO4==5 
bysort xIDHH xRO8:  egen xhmsib3 = total(xmsib3) if (xRO4==1|xRO4==7) 
egen xhmsib=rowmax(xhmsib1 xhmsib2 xhmsib3)

gen RO5re=-RO5
bysort IDHH: egen femsib1=rank(-RO5) if RO4==3 & sex==1
bysort IDHH RO9: egen femsib2=rank(-RO5) if RO4==5 & sex==1
bysort IDHH RO9: egen femsib3=rank(-RO5) if (RO4==1|RO4==7) & sex==1
bysort IDHH: egen msib1=rank(-RO5) if RO4==3 & sex==0
bysort IDHH RO9: egen msib2=rank(-RO5) if RO4==5 & sex==0
bysort IDHH RO9: egen msib3=rank(-RO5) if (RO4==1|RO4==7) & sex==0

replace femsib1=0 if femsib1!=1
replace femsib2=0 if femsib1!=1
replace femsib3=0 if femsib1!=1
replace msib1=0 if msib1!=1
replace msib2=0 if msib1!=1
replace msib3=0 if msib1!=1

bysort IDHH:  egen hfemsib1 = total(femsib1) if RO4==3
bysort IDHH RO9:  egen hfemsib2 = total(femsib2) if RO4==5
bysort IDHH RO9:  egen hfemsib3 = total(femsib3) if (RO4==1|RO4==7)
egen hfemsib=rowmax(hfemsib1 hfemsib2 hfemsib3)

bysort IDHH:  egen hmsib1 = total(msib1) if xRO4==3
bysort IDHH RO9:  egen hmsib2 = total(msib2) if RO4==5
bysort IDHH RO9:  egen hmsib3 = total(msib3) if (RO4==1|RO4==7)
egen hmsib=rowmax(hmsib1 hmsib2 hmsib3)

replace xhfemsib=0 if xhfemsib==.
replace xhmsib=0 if xhmsib==.
replace hmsib=0 if hmsib==.
replace hfemsib=0 if hfemsib==.

*interaction
gen agegender=agec*sex
gen siblinggender=genderunequal*siblingunequal
keep genderunequal siblingunequal agegender siblinggender HHWAVES RO5 childlabour_bi agec agec2 sex siblings2 INCOME land GROUPS firstgender xfirstworking oldest oldestfem agerank femheadedhh childheadedhh nysis nybro agegap  ysibling 
sum genderunequal siblingunequal childlabour_bi agec agec2 sex siblings2 INCOME land i.GROUPS firstgender xfirstworking oldest oldestfem agerank femheadedhh childheadedhh nysis nybro agegap  ysibling if HHWAVES==11 & RO5<18

logit childlabour_bi agec agec2 i.sex siblings2 INCOME land i.GROUPS if HHWAVES==11 & RO5<18
logit childlabour_bi agec agec2 i.sex siblings2 INCOME land i.GROUPS agerank i.firstworking i.xfirstworking   if HHWAVES==11 & RO5<18
logit childlabour_bi agec agec2 i.sex siblings2 INCOME land i.GROUPS agerank i.firstworking  i.xfirstworking  i.firstgender i.oldestfem i.femheadedhh if HHWAVES==11 & RO5<18
logit childlabour_bi agec agec2 i.sex siblings2 INCOME land i.GROUPS agerank i.firstworking  i.xfirstworking  i.firstgender i.oldestfem i.femheadedhh siblingunequal if HHWAVES==11 & RO5<18
logit childlabour_bi agec agec2 i.sex siblings2 INCOME land i.GROUPS agerank i.firstworking  i.xfirstworking i.firstgender i.oldestfem i.femheadedhh siblingunequal if HHWAVES==11 & RO5<18
logit childlabour_bi agec agec2 i.sex siblings2 INCOME land i.GROUPS agerank i.firstworking  i.xfirstworking i.firstgender i.oldestfem i.femheadedhh siblingunequal genderunequal if HHWAVES==11 & RO5<18
logit childlabour_bi agec agec2 i.sex siblings2 INCOME land i.GROUPS agerank i.firstworking  i.xfirstworking i.firstgender i.oldestfem i.femheadedhh siblingunequal genderunequal siblinggender if HHWAVES==11 & RO5<18

*siblings inequality

bysort IDHH: egen  siblinghours1=total(total_hours2) if cc==1 & siblings> 1  & age2<18
bysort IDHH RO9: egen  siblinghours2=total(total_hours2) if dd==1  & siblings> 1  & age2<18
bysort IDHH RO9: egen   siblinghours3=total(total_hours2) if hh==1 & siblings> 1  & age2<18

by IDHH, sort: gen siblingindex1=sqrt((total_hours2-(siblinghours1/siblingsunder18))^2) if cc==1 & siblings> 1  & age2<18
by IDHH RO9, sort: replace siblingindex1=sqrt((total_hours2-(siblinghours2/siblingsunder18))^2) if dd==1 & siblings> 1  & age2<18
by IDHH RO9, sort: replace siblingindex1=sqrt((total_hours2-(siblinghours3/siblingsunder18))^2) if hh==1 & siblings> 1  & age2<18

bysort IDHH: egen  siblingindex2=total(siblingindex1) if cc==1
bysort IDHH RO9: egen  siblingindex3=total(siblingindex1) if dd==1
bysort IDHH RO9: egen  siblingindex4=total(siblingindex1) if hh==1

by IDHH, sort: gen siblingindex=siblingindex2 if cc==1
by IDHH RO9, sort: replace siblingindex=siblingindex3 if dd==1
by IDHH RO9, sort: replace siblingindex=siblingindex4 if hh==1


*gender inequality 
bysort IDHH: egen femalework1=total(total_hours2) if sex==1
bysort IDHH RO9: egen femalework2=total(total_hours2) if sex==1
bysort IDHH RO9: egen femalework3=total(total_hours2) if sex==1

bysort IDHH: egen malework1=total(total_hours2) if sex==0
bysort IDHH RO9: egen malework2=total(total_hours2) if sex==0
bysort IDHH RO9: egen malework3=total(total_hours2) if sex==0

bysort IDHH: egen femalework4=max(femalework1)
bysort IDHH RO9: egen femalework5=max(femalework2)
bysort IDHH RO9: egen femalework6=max(femalework3)

bysort IDHH: egen malework4=max(malework1)
bysort IDHH RO9: egen malework5=max(malework2)
bysort IDHH RO9: egen malework6=max(malework3)

bysort IDHH: egen female1=total(sex) if c==1 & siblings> 1 & age2<18 & age2>4
bysort IDHH RO9: egen female2=total(sex) if d==1 & siblings> 1 & age2<18 & age2>4
bysort IDHH RO9: egen female3=total(sex) if h==1 & siblings> 1 & age2<18 & age2>4

by IDHH, sort: gen male1=siblingsunder18-female1 if c==1 & siblings> 1 & age2<18 & age2>4
by IDHH RO9, sort: gen male2=siblingsunder18-female2 if d==1 & siblings> 1 & age2<18 & age2>4
by IDHH RO9, sort: gen male3=siblingsunder18-female3 if h==1 & siblings> 1 & age2<18 & age2>4

by IDHH, sort: gen femaleaverage12=femalework4/female1 
by IDHH RO9, sort: gen femaleaverage22=femalework5/female2
by IDHH RO9, sort: gen femaleaverage32=femalework6/female3

by IDHH, sort: gen maleaverage12=malework4/male1 if c==1 
by IDHH RO9, sort: gen maleaverage22=malework5/male2 if d==1 
by IDHH RO9, sort: gen maleaverage32=malework6/male3 if h==1 

by IDHH, sort: gen genderindex=(femaleaverage12-maleaverage12)/maleaverage12  if c==1
by IDHH RO9, sort: replace genderindex=(femaleaverage22-maleaverage22)/maleaverage22 if d==1 
by IDHH RO9, sort: replace genderindex=(femaleaverage32-maleaverage32)/maleaverage32  if h==1 



*siblings inequality (CS) 
bysort IDHH: egen  siblinghourscs1=total(CS10) if c==1 & siblings> 1  & age2<18
bysort IDHH RO9: egen  siblinghourscs2=total(CS10) if d==1  & siblings> 1  & age2<18
bysort IDHH RO9: egen   siblinghourscs3=total(CS10) if h==1 & siblings> 1  & age2<18

by IDHH, sort: gen siblingindexcs1=sqrt((CS10-(siblinghourscs1/siblingsunder18))^2) if c==1 & siblings> 1  & age2<18
by IDHH RO9, sort: replace siblingindexcs1=sqrt((CS10-(siblinghourscs2/siblingsunder18))^2) if d==1 & siblings> 1  & age2<18
by IDHH RO9, sort: replace siblingindexcs1=sqrt((CS10-(siblinghourscs3/siblingsunder18))^2) if h==1 & siblings> 1  & age2<18

bysort IDHH: egen  siblingindexcs2=total(siblingindexcs1) if c==1
bysort IDHH RO9: egen  siblingindexcs3=total(siblingindexcs1) if d==1
bysort IDHH RO9: egen  siblingindexcs4=total(siblingindexcs1) if h==1

by IDHH, sort: gen siblingindexcs=siblingindexcs2 if c==1
by IDHH RO9, sort: replace siblingindexcs=siblingindexcs3 if d==1
by IDHH RO9, sort: replace siblingindexcs=siblingindexcs4 if h==1


*gender inequality (CS)

bysort IDHH: egen femaleedu1=total(CS10) if sex==1
bysort IDHH RO9: egen femaleedu2=total(CS10) if sex==1
bysort IDHH RO9: egen femaleedu3=total(CS10) if sex==1

bysort IDHH: egen maleedu1=total(CS10) if sex==0
bysort IDHH RO9: egen maleedu2=total(CS10) if sex==0
bysort IDHH RO9: egen maleedu3=total(CS10) if sex==0

bysort IDHH: egen femaleedu4=max(femaleedu1)
bysort IDHH RO9: egen femaleedu5=max(femaleedu2)
bysort IDHH RO9: egen femaleedu6=max(femaleedu3)

bysort IDHH: egen maleedu4=max(maleedu1)
bysort IDHH RO9: egen maleedu5=max(maleedu2)
bysort IDHH RO9: egen maleedu6=max(maleedu3)

by IDHH, sort: gen femaleaverage1=femaleedu4/female1 
by IDHH RO9, sort: gen femaleaverage2=femaleedu5/female2
by IDHH RO9, sort: gen femaleaverage3=femaleedu6/female3

by IDHH, sort: gen maleaverage1=maleedu4/male1 if c==1 
by IDHH RO9, sort: gen maleaverage2=maleedu5/male2 if d==1 
by IDHH RO9, sort: gen maleaverage3=maleedu6/male3 if h==1 

by IDHH, sort: gen genderindexCS=(maleaverage1-femaleaverage1)/maleaverage1  if c==1
by IDHH RO9, sort: replace genderindexCS=(maleaverage1-femaleaverage2)/maleaverage2  if d==1 
by IDHH RO9, sort: replace genderindexCS=(maleaverage1-femaleaverage3)/maleaverage3  if h==1 

sum genderindex2 if age2>4 & age2<18

*NSDP
gen NSDP=.
replace NSDP=	42220	if STATEID==	1
replace NSDP=	74899	if STATEID==	2
replace NSDP=	74606	if STATEID==	3
replace NSDP=	140073	if STATEID==	4
replace NSDP=	82193	if STATEID==	5
replace NSDP=	108859	if STATEID==	6
replace NSDP=	175812	if STATEID==	7
replace NSDP=	47506	if STATEID==	8
replace NSDP=	30052	if STATEID==	9
replace NSDP=	23435	if STATEID==	10
replace NSDP=	121440	if STATEID==	11
replace NSDP=	62213	if STATEID==	12
replace NSDP=	56638	if STATEID==	13
replace NSDP=	32284	if STATEID==	14
replace NSDP=	48591	if STATEID==	15
replace NSDP=	50750	if STATEID==	16
replace NSDP=	52971	if STATEID==	17
replace NSDP=	33633	if STATEID==	18
replace NSDP=	54830	if STATEID==	19
replace NSDP=	35652	if STATEID==	20
replace NSDP=	46150	if STATEID==	21
replace NSDP=	46573	if STATEID==	22
replace NSDP=	38669	if STATEID==	23
replace NSDP=	75115	if STATEID==	24
replace NSDP=	.	if STATEID==	25
replace NSDP=	.	if STATEID==	26
replace NSDP=	101314	if STATEID==	27
replace NSDP=	71480	if STATEID==	28
replace NSDP=	68374	if STATEID==	29
replace NSDP=	192652	if STATEID==	30
replace NSDP=	83725	if STATEID==	32
replace NSDP=	84496	if STATEID==	33
replace NSDP=	95759	if STATEID==	34
