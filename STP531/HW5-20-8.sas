dm "output;clear;log;clear";

data sausage;
  input percent humidity temp;
cards;
  13.9      1      1
   14.2      1      2
   20.5      1      3
   24.8      1      4
   15.7      2      1
   16.3      2      2
   21.7      2      3
   23.6      2      4
   15.1      3      1
   15.4      3      2
   19.9      3      3
   26.1      3      4
;
run;

proc glm data=sausage alpha=0.0125;
  class humidity temp;
  model percent = humidity temp;
  lsmeans temp/cl pdiff;
  estimate 'temp2 vs. temp1' temp -1 1 0 0;
  estimate 'temp3 vs. temp2' temp 0 -1 1 0;
  estimate 'temp4 vs. temp3' temp 0 0 -1 1;
run;
quit;

symbol  i=join v=circle;
proc gplot data=sausage;
plot percent*humidity=temp;
run;
