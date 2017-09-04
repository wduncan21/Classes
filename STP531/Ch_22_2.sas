dm "output;clear;log;clear";

*** The flower exampe:
*** to study the effects of flower variety (factor A) and
***                         moisture level (factor B)  
***                      on yield of salable flowers (Y). 
*** The plot size (X) was also recorded;
*** Six replications were made for each treatment;

data flower;
 input Y X a b rep;
 cards;
  98  15  1  1  1
  60   4  1  1  2
  77   7  1  1  3
  80   9  1  1  4
  95  14  1  1  5
  64   5  1  1  6
  55   4  2  1  1
  60   5  2  1  2
  75   8  2  1  3
  65   7  2  1  4
  87  13  2  1  5
  78  11  2  1  6
  71  10  1  2  1
  80  12  1  2  2
  86  14  1  2  3
  82  13  1  2  4
  46   2  1  2  5
  55   3  1  2  6
  76  11  2  2  1
  68  10  2  2  2
  43   2  2  2  3
  47   3  2  2  4
  62   7  2  2  5
  70   9  2  2  6
;
run;

proc glm data=flower;
 class a b;
 model y = a|b x / SS3 clparm alpha=0.025;
 means a b a*b;
 lsmeans a b a*b;
* estimate 'L1 (WP - LP)' A 1 -1; 
* estimate 'L2 (high - low)' B -1 1;
run;

*** 1. create the ANOVA table;
ods graphics on;
proc glm plots=DIAGNOSTICS residuals;
 class a b;
 model y = a|b x / SS3 clparm alpha=0.025;
 means a;
 lsmeans a;
 estimate 'L1 (WP - LP)' A 1 -1; 
 estimate 'L2 (hihg - low)' B -1 1;
run;
ods graphics off;

*** 2. use different slopes for different groups (cells) ;

** What if we also need to consider X^2 in the model;
data flower;
 set flower;
 x2 = x**2; *<--- x^2;
run;

proc glm data=flower plots=DIAGNOSTICS residuals;
 class a b;
 model y = a|b x x2; *<-- include it in the model;
run;

*** estimating the mean response at a given x (here, we use x=mean(x));
proc glm;
 class a b;
 model y = a|b x / SS3 clparm;
 means a b a*b;
 lsmeans a b a*b;
 estimate 'A1' intercept 1 a 1 0 b .5 .5 a*b .5 .5 0 0 x 8.25;
 estimate 'A2' intercept 1 a 0 1 b .5 .5 a*b 0 0 .5 .5 x 8.25;
 estimate 'B1' intercept 1 a .5 .5 b 1 0 a*b .5 0 .5 0 x 8.25;
 estimate 'B2' intercept 1 a .5 .5 b 0 1 a*b  0 .5 0 .5 x 8.25;
 estimate 'A1B1' intercept 1 a 1 0 b 1 0 a*b 1 0 0 0 x 8.25;
run;


************************************************
****** some skills for data processing (optinal); 
************************************************
 
** the use of format, infile and label;
proc format;
 value fa 1 = 'LP'
          2 = 'WB';
 value fb 1 = 'low'
          2 = 'high';
run;

data flower;
 infile "C:\ASUKao\Teaching\STP531Spring2013\SAS\Ch22\A06.txt";
 format A fa. B fb.;
 input Y X A B rep;
 label y = 'yield'
       x = 'plot size'
  	   a = 'variety'
	   b = 'moisture';
run;
 
proc print label;
run;

** save SAS data set as a physical file;
libname F 'C:\ASUKao\Teaching\STP531Spring2013\SAS\Ch22\'; * assign directory;

data F.flower;
 set flower;
run;

** retrieve the the data set, remember to include the libname statement; 

data flower;
 set F.flower;
run;

quit;
