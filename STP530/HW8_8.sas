data test;
infile 'B:\dropbox\class\Fall 2013\STP530\C8E8.txt';
input y x1 x2 x3 x4;
run;

proc means data = test mean;
var x1;
output out = mean mean=mu1;
run;

data test;
merge test mean;
retain mu;
if _n_=1 then do;
mu=mu1;
end;
x1cen=x1-mu;
x1sq=x1cen**2;
run;

proc reg data=test plots=none;
model y= x1cen x2 x4 x1sq/clm;
plot p.*y;
test x1sq=0;
run;
quit;
