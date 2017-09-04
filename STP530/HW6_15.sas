data sat;
infile 'B:\dropbox\class\Fall 2013\STP530\C6E15.txt';
input y x1 x2 x3;
run;
proc reg data=sat alpha=0.016667;
  model y=x1 x2 x3/clb;
  output out=temp r=r p=yhat;
  ods output ANOVA=temp1;
run;

data temp;
set temp;
group=1;
run;

proc template ;
define statgraph scatterbox;
begingraph;
layout overlay ;
boxplot x=group y=r; /* display =(mean median c ap s );*/
scatterplot x=group y=r;
endlayout ;
endgraph ;
end;
proc sgrender data=temp template=scatterbox ;
run ;


proc gplot data=temp;
plot r*yhat;
plot r*x1;
plot r*x2;
plot r*x3;
plot r*x1x2;
plot r*x2x3;
plot r*x3x1;
run;


data temp1;
set temp1;
if source='Error' then call symput('sse', ss);
run;
data temp2;
set temp nobs=total;
e2=r**2;
run;
ods listing close;
proc reg data=temp2;
model e2=x1 x2 x3;
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
