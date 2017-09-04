dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data food;
  input sales design store;
cards;
  11  1  1
  17  1  2
  16  1  3
  14  1  4
  15  1  5
  12  2  1
  10  2  2
  15  2  3
  19  2  4
  11  2  5
  23  3  1
  20  3  2
  18  3  3
  17  3  4
  27  4  1
  33  4  2
  22  4  3
  26  4  4
  28  4  5
;
run;

proc glm data=food alpha=0.1;
  class design;
  model sales=design /clparm; *produces confidence limits for the parameter estimates;
  *lsmeans design;
  estimate '3- v 5-color' design .5 .5 -.5 -.5;	
run;
quit;
