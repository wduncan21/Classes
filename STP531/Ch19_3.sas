*** Ch19 two-factor ANOVA;
*** Castle Bakery Company problem (page 833)
*** response: sales of this bakery's bread (in cases)
*** factor A: height of the shelf display (three levels: bottom, middle, top)
*** factor B: width of the shelf display (two levels: regular, wide);
 
dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data bakery;
  input sales height width stores;
cards;
  47  1  1  1
  43  1  1  2
  46  1  2  1
  40  1  2  2
  62  2  1  1
  68  2  1  2
  67  2  2  1
  71  2  2  2
  41  3  1  1
  39  3  1  2
  42  3  2  1
  46  3  2  2
;
run;

** 1. ANOVA with interaction;
proc glm data=bakery;
  class height width;
  model sales=height width height*width;  
  lsmeans height /cl adjust=Tukey;
run;

*** 2. ANOVA with no interaction (pooling);
proc glm data=bakery;
  class height width;
  model sales=height width;  
  lsmeans height /cl adjust=Tukey;
run;

quit;
