data sales;
input x y;
cards;
0 98
1 135
2 162
3 178
4 221
5 232
6 283
7 300
8 374
9 395
;
run;
symbol v=dot;
proc gplot data=sales;
plot y*x;
run;

%include 'B:\dropbox\class\STP530\boxcox.sas';
%boxcox(resp=y,model=x,data=sales,lopower=-1,hipower=2,npower=31,outplot=boxcox,gplot=none);

data boxcox;
set boxcox;
SSE=(_RMSE_)**2*8;
run;
proc print data=boxcox;
run;

*plot sqrt(y) regression;
data sales;
set sales;
ysqrt=sqrt(y);
run;
proc reg data=sales;
model ysqrt=x;
output out=regout r=r p=yhat;
run;

*plot residual against yhat;
proc gplot data=regout;
plot r*yhat;
run;
quit;
