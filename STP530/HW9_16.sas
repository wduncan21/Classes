data test;
infile'B:\dropbox\class\Fall 2013\STP530\C9E15.txt';
input y x1 x2 x3;
run;


proc means data = test mean noprint;
var x1-x3;
output out = mean mean=mu1 mu2 mu3;
run;

data test;
merge test mean;
retain m1 m2 m3;
if _n_=1 then do;
m1=mu1;
m2=mu2;
m3=mu3;
end;
x1cen=x1-m1;
x2cen=x2-m2;
x3cen=x3-m3;
x1sq=x1cen**2;
x2sq=x2cen**2;
x3sq=x3cen**2;
x1x2=x1cen*x2cen;
x1x3=x1cen*x3cen;
x2x3=x2cen*x3cen;
run;

proc reg data=test plots=none;
model y= x1cen x2cen x3cen x1sq x2sq x3sq x1x2 x1x3 x2x3/selection=cp BEST=3;
run;
quit;

proc reg data=test plots=none outtest=new noprint;
model y= x1cen x2cen x3cen x1sq x2sq x3sq x1x2 x1x3 x2x3/selection=stepwise slentry=0.1 slstay=0.15 adjrsq ;
run;
quit;
proc print data=new;
run;
