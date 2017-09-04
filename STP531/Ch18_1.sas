*** Ch18. Checking Assumptions;

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


******************************************************
*** 0. plot against fitted value
******************************************************;
proc glm data=food;
  class design;
  model sales=design;
  output out=tmp r=residual p=fittedvalue;
run;

goptions reset = all; * reset all the options set for graphs; 
goptions htext = 4 pct;
symbol1 value=dot color=blue height=2;  
axis1 label=('Fitted values');
axis2 order=(-6 to 6 by 1) label=(angle=90  'Residuals');
proc gplot data=tmp;
 plot residual*fittedvalue / haxis=axis1 vaxis=axis2;
run;

quit;

