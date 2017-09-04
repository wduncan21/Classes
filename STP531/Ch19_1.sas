*** Ch19 two-factor ANOVA;
*** Food data example;

dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data food;
  input sales color cartoon design store;
cards;
  11  3 1 1  1
  17  3 1 1  2
  16  3 1 1  3
  14  3 1 1  4
  15  3 1 1  5
  12  3 0 2  1
  10  3 0 2  2
  15  3 0 2  3
  19  3 0 2  4
  11  3 0 2  5
  23  5 1 3  1
  20  5 1 3  2
  18  5 1 3  3
  17  5 1 3  4
  18  5 1 3  4
  27  5 0 4  1
  33  5 0 4  2
  22  5 0 4  3
  26  5 0 4  4
  28  5 0 4  5
;
run;

** consider a two-way ANOVA analysis;
proc glm data=food plots=DIAGNOSTICS;
  class color cartoon;
  model sales=color cartoon color*cartoon; 
  * model sales= color|cartoon; ** note. the two model statements yeild the same result;
  lsmeans color*cartoon;
  * lsmeans color cartoon; * can also obtain the average for each level of each factor;
  ods output LSMeans=Means;
run;

*** use means to create interaction plot;
goptions reset = all;
symbol1 c=blue i=join;
symbol2 c=red i=join;
proc gplot data = Means;
 plot salesLSMean*color=cartoon; 
run;

*** another way to create interaction plot;
ods graphics on;
proc glm data=food plot=INTPLOT; 
  class color cartoon;
  model sales=color cartoon color*cartoon; 
run;
ods graphics off;

quit;
