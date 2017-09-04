data test;
input y x;
cards;
 28.0  200.0
   75.0  400.0
   37.0  300.0
   53.0  400.0
   22.0  200.0
   58.0  300.0
   40.0  300.0
   96.0  400.0
   46.0  200.0
   52.0  400.0
   30.0  200.0
   69.0  300.0
  ;
run;

ods listing close;
proc reg data=test;
model y=x;
ods output ANOVA=temp1;
output out=temp r=e;
run;quit;ods listing;
data temp1;
set temp1;
if source='Error' then call symput('sse', ss);
run;
data temp2;
set temp nobs=total;
e2=e**2;
abse=abs(e);
run;
ods listing close;
proc reg data=temp2;
model e2=x;
ods output anova=temp3;
model abse=x;
output out=temp4 p=s;
plot e2*x;
run;
quit;
ods listing;
data temp3;
set temp3;
if source='Model' then call symput('ssr', ss);
run;
data tempf;
set temp3;
pvalue=1-probchi((&ssr/2)/(&sse/12)**2,1);
ssr=&ssr;
sse=&sse;
run;
proc print data=tempf;
var ssr sse pvalue;
run;
data temp4;
set temp4;
weight=1/(s**2);
run;
proc print data=temp4;
var weight;
run;

proc reg data=temp4 plots=none;
model y=x;
weight weight;
output out=temp5 r=e;
run;
quit;

data temp5;
set temp nobs=total;
e2=e**2;
abse=abs(e);
run;
ods listing close;
proc reg data=temp5;
model abse=x;
output out=temp6 p=s;
run;
quit;

data temp6;
set temp6;
weight=1/(s**2);
run;

proc reg data=temp6 plots=none;
model y=x;
weight weight;
run;
quit;

