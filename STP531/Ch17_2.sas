dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

*** The food example  
*** I've changed the Designs 1, 2, 3, and 4 (numeric) to Designs I, II, III, and IV (string);

data food;
  input sales design$ store; *** note. the 'design' variable is now followed by a dollar sign as it now a string variable now; 
  cards;
  11  I    1
  17  I    2
  16  I    3
  14  I    4
  15  I    5
  12  II   1
  10  II   2
  15  II   3
  19  II   4
  11  II   5
  23  III  1
  20  III  2
  18  III  3
  17  III  4
  27  IV   1
  33  IV   2
  22  IV   3
  26  IV   4
  28  IV   5
;
run;

proc glm data=food;
  class design;
  model sales=design; *produces confidence limits for the parameter estimates;
  lsmeans design /adjust=TUKEY cl pdiff; ** for the newer version we don't need to specify pdiff;
  lsmeans design /adjust=BON cl pdiff;
  lsmeans design /adjust=SCHEFFE cl pdiff;
run;

*** one way to obtain Bonferroni C.Is for other comparisons;
title 'Bonforrnoi for two comparisons';
proc glm data=food alpha = 0.025; ** Note that the alpha value is adjusted based on the Bonferroni method; 
  class design;
  model sales=design /clparm; *produces confidence limits for the parameter estimates;
  estimate 'd1,d2 v. d3,d4' design .5 .5 -.5 -.5;
  estimate 'd1,d3 v. d2,d4' design .5 -.5 .5 -.5;
run;

quit;


/*
*** the following code is one way to construct 
*** 95% C.I.'s for contrasts using Scheffe procedure
*** Completely understanding the code is optional --- 
***    but you will need to be able to make small revisions to run the results you need;

*** Roughly speaking, this code does the following things:
***   1) Perform ANOVA analysis and estimate the contrasts. 
***      the ANOVA table is stored in the data set called anova
***      the estimated results are in est
***   2) From anova, obtain d.f.'s for the model,
***       and assign these values to macro variables (&dfm. and &dfe.)
***       note. in the LOG window you can see these two d.f.'s
***   3) obtain the critival value of Scheffe procedure
***        and construct the C.I.; 

***   note. similarly, we can construct C.I.'s using Bonfferoni procedure;  
***
***  reference. Introduction to SAS.  UCLA: Academic Technology Services, Statistical Consulting Group. 
***             from http://www.ats.ucla.edu/stat/sas/notes2/ (accessed Feb 2, 2010).;

title 'Sheffe procedure';

ods output  Estimates=est overallanova=anova; *<-- ods output produces tables containing SAS outputs;
** Tips: Look for the two data sets est and anova;

*** 1. Create the ANOVA table and the estimates;
proc glm data=food;
  class design;
  model sales=design;
  *** suppose we want to find simutaneous C.Is for the follwong comparisons using Scheffe's method (TO CHANGE); 
  estimate 'd1,d2 v. d3,d4' design .5 .5 -.5 -.5;
  estimate 'd1,d3 v. d2,d4' design .5 -.5 .5 -.5;
run;
quit; ** to makre sure that the data sets are created;

%let alpha=0.05; ** (significance level: TO CHANGE, if necessary);


***2. use the anova table to obtain the required degree of freedoms;
data _null_;
  set anova;
  if source='Model' then call symput('dfm', df); * the macro variable &dfm now contains the degree of freedom for model;
  if source='Error' then call symput('dfe', df); * the macro variable &dfe now contains the degree of freedom for error;
run;

%put here are the numbers &dfm &dfe; ** the two d.f.'s required;

***3. use the est data set (that has the estimate and the standard errors) to calculate the CIs ;
data est1;
  set est;
  drop dependent tvalue probt;
  S2=&dfm*finv(1-&alpha. , &dfm, &dfe); *** obtain S^2 = (r-1)F(1-alpha, r-1, nT-r);
  S=sqrt(S2);                           *** obtain C = S; 
  lower=estimate - S* stderr;           *** lower limits of the CIs ;
  upper=estimate + S* stderr;           *** upper limits of the CIs;
run;

***4. show the CIs;
proc print data=est1;
run;

**** Try to obtain the CIs using the Bonferroni procedure: hint. instead of finv() use tinv();
quit;

*/
