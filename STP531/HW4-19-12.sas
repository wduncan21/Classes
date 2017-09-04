dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data eye;
input rating eye gender id;
cards;
11.0      1      1      1
    7.0      1      1      2
   12.0      1      1      3
    6.0      1      1      4
   10.0      1      1      5
   15.0      1      2      1
   12.0      1      2      2
   14.0      1      2      3
   11.0      1      2      4
   16.0      1      2      5
   12.0      2      1      1
   16.0      2      1      2
   10.0      2      1      3
   13.0      2      1      4
   14.0      2      1      5
   14.0      2      2      1
   17.0      2      2      2
   13.0      2      2      3
   20.0      2      2      4
   18.0      2      2      5
;
run;

proc glm data=eye  plots=DIAGNOSTICS;
  class gender eye;
  model rating=gender eye gender*eye; 
  lsmeans gender*eye;
  output out=Means p=yhat r=r;

run;


data temp1;
set means;
run;

proc sort data=temp1;
by r;
data temp1;
set temp1;
k=_n_;
run;

proc rank data=temp1 normal=blom out=temp2;
var r;
ranks k1;
run;

data temp3;
set temp2;
expected=k1*sqrt(6.075);
run;

proc sort data=temp3;
by id;
run;

proc corr data=temp3; var r expected;run;

data res;
set means;
order=_n_;
run;

proc gplot data=res;
  plot r*order;
  title2 "Sequence plot of the residuals";
  axis1 label = (a=90 'Residual');
  axis2 label=('Order');
  symbol1 v=dot h=.1 cv=blue ci=red i=join;
run;
