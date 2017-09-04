data test;
infile 'B:\dropbox\class\Fall 2013\STP530\C11E11.txt';
input y x;
run;

proc reg data=test;
model y=x;
output out=all p=olsy;
run;

proc robustreg data=test method=m(wf=huber) plots=none;
model y=x;
output out=new1 weight=weight;
run;

proc print data=new1;
run;

proc reg data=new1 plots=none;
model y=x;
weight weight;
run;

proc robustreg data=new1 method=m(wf=huber) plots=none;
model y=x;
output out=new2 weight=weight;
run;

proc reg data=new2 plots=none;
model y=x;
weight weight;
run;

proc robustreg data=new2 method=m(wf=huber) plots=none;
model y=x;
output out=new3 weight=weight;
run;

proc reg data=new3 plots=none;
weight weight;
model y=x;
output out=all2 p=irlsy;
run;
quit;
proc sort data=all;
by x y;
run;
proc sort data=all2;
by x y;
run;
data all;
merge all all2;
by x y;
run;
proc print data=all;
run;
symbol1 i=none;
symbol2 i=join color=green;
symbol3 i=join color=red;

proc gplot data=all;
plot y*x olsy*x irlsy*x/overlay;
run;
quit;
