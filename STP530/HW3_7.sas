data mass;
infile'B:\Dropbox\class\STP530\C1E27.txt';
input y x;
run;

proc univariate plots data=mass;
var x;
run;
** plot residual against x and y;
proc reg graphics;
model y=x;
plot residual.*x;
plot residual.*y;
output out=regout p=yhat r=r;
run;

proc sort data=regout;
by r;
run;

data regout2;
set regout;
k=_n_;
run;

proc rank data=regout2 normal=blom out=regout3;
var r;
ranks k1;
run;
**get the MSE;
proc model data=mass  ;
parms const beta;
y=const+beta*x;
fit y;
run;

data regout3;
 set regout3;
 expected=k1*8.1732;
 run;

 proc sort data=regout3;
 by id;
 run;
*reg correlation;
 proc corr data=regout3;
 var r expected;
 run;
*B-P test;
ods listing close;
proc reg data=mass;
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
run;
ods listing close;
proc reg data=temp2;
model e2=x;
ods output anova=temp3;
run;
quit;
ods listing;
data temp3;
set temp3;
if source='Model' then call symput('ssr', ss);
run;
data tempf;
set temp3;
pvalue=1-probchi((&ssr/2)/(&sse/60)**2,1);
ssr=&ssr;
sse=&sse;
run;
proc print data=tempf;
var ssr sse pvalue;
run;