dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data test;
  input Effect $ Dependent $ A B LSMean;
cards;
AB value 1 1 250
AB value 1 2 265
AB value 1 3 268
AB value 1 4 269
AB value 2 1 288
AB value 2 2 273
AB value 2 3 270
AB value 2 4 269

;
run;


*** use means to create interaction plot;
goptions reset = all;
symbol1 c=blue i=join;
symbol2 c=red i=join;
proc gplot data = test;
 plot LSMean*B=A; 
run;

data lgtest;
set test;
lgLSMean=log(LSMean);
run;

*** use means to create interaction plot;
goptions reset = all;
symbol1 c=blue i=join;
symbol2 c=red i=join;
proc gplot data = lgtest;
 plot lgLSMean*B=A; 
run;
