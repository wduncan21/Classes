data production;
infile'B:\dropbox\class\STP530\C3E18.txt';
input y x;
xsqrt=sqrt(x);
run;

*scatter plot;
proc gplot data=production;
 plot y*x;
 run;
*loess plot;
proc loess data=production;
model y=x/ degree=2 smoonth=0.85;
ods output outputstatistics=results;
run;

*regression;
proc reg data=production;
model y=xsqrt;
output out=regout p=yhat r=r;
run;

*plot residuals against yhat;
proc gplot data=regout;
 plot r*yhat;
run;
quit;
