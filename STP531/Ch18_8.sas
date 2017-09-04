dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

*** Box-cox procedure;
** Table 18.5: Time between computer failure at three locations;
data PC;
 input time location idx;
 cards;
    4.41  1  1
  100.65  1  2
   14.45  1  3
   47.13  1  4
   85.21  1  5
    8.24  2  1
   81.16  2  2
    7.35  2  3
   12.29  2  4
    1.61  2  5
  106.19  3  1
   33.83  3  2
   78.88  3  3
  342.81  3  4
   44.33  3  5
  ;
 run;

proc sort data=PC out=PC1;
 by time;
run;

data PC1;
 set PC1;
 ranktime = _n_;
run;

proc glm data=PC1;
  class location;
  model ranktime=location;
run;

quit;

