data test;
infile'B:\dropbox\class\Fall 2013\STP530\C9E15.txt';
input y x1 x2 x3;
run;

proc sgscatter data=test;
matrix y x1 x2 x3;
run;
quit;

proc corr data=test;
var x1-x3;
run;

proc reg data=test plots=none;
model y=x1-x3;
run;
