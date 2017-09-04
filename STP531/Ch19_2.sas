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

** 1. ANOVA;

proc glm data=bakery plots=DIAGNOSTICS;
  class height width;
  model sales=height width height*width;  
run;


*** 2. The interaction and width effects are not significant.
***    However, the effect of heights is significant;
***    We will proceed to compare the level means for `height' using the Tukey's procedure;

proc glm data=bakery;
  class height width;
  model sales=height width height*width;  
  lsmeans height /cl adjust=tukey;
run;

*** 3. The following code provide two comparisons using the Bonferroni's method;
proc glm data=bakery alpha=0.025;
  class height width;
  model sales=height width height*width /clparm ;  
  estimate 'mu2. - mu1.' height -1 1 0;
  estimate 'mu2. - mu3.' height 0 1 -1;
run;


*** 4. Suppose we would like to conduct pairwise comparisons for both
       `height' and `width' families using a Tukey's procedure for each family. 
       We may follow the description in page 851 to adjust the overall type-I error rate
       using the Bonferroni's method. Now we have two sets of comparisons, the adjusted
       alpha should be 0.05/2 = 0.025.;
proc glm data=bakery alpha=0.025;
  class height width;
  model sales=height width height*width;  
  lsmeans height /cl adjust=tukey;
  lsmeans width /cl adjust=tukey;
run;

*** 5. We can also use SAS to obtain estimations of treatment means.
       The following code helps us to obtain 95% C.I.'s for the means for the (2,1) and (3,1) cells.
       Since we have two intervals, a Bonferroni adjustment is considered.;

proc glm data=bakery alpha=0.025; 
  class height width;
  model sales=height width height*width /clparm ;  
  estimate 'mu21' intercept 1 height 0 1 0 width 1 0  height*width 0 0 1 0 0 0;
  estimate 'mu31' intercept 1 height 0 0 1 width 1 0  height*width 0 0 0 0 1 0;
run;

*** 6. How to compare mu21 and mu31;
proc glm data=bakery ; 
  class height width;
  model sales=height width height*width /clparm ;  
  estimate 'mu21 - mu31' height 0 1 -1  height*width 0 0 1 0 -1 0;
run;


quit;

