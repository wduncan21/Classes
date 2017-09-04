dm "output;clear;log;clear";

*** Example on Table 22.1 ;
***  Effects of three different types of promotions on sales of crackers (Y)
***  Fifteen stores are completely randomized to the three treatments
***  The sales in the preceding period is also recorded (X);

data cracker;
   input y x treat store;
cards;
  38  21  1  1
  39  26  1  2
  36  22  1  3
  45  28  1  4
  33  19  1  5
  43  34  2  1
  38  26  2  2
  38  29  2  3
  27  18  2  4
  34  25  2  5
  24  23  3  1
  32  29  3  2
  31  30  3  3
  21  16  3  4
  28  29  3  5
;
run;

proc glm data=cracker;
 class treat;
 model y = x treat /solution;
run;



*** 0) create a scatter plot of Y vs. X,  ; 
***    Create three variables for the three treatments so that SAS 
***    can assign different 'symbols' to these variables in the plot;
***  reference. Introduction to SAS.  UCLA: Academic Technology Services, Statistical Consulting Group. 
***             from http://www.ats.ucla.edu/stat/sas/notes2/ (accessed March, 2010).;

data cplot;
  set cracker;
  if treat=1 then treat1 = y;
  else if treat=2 then treat2=y;
  else treat3=y;
run;

 
goptions reset=all;
symbol1 c=blue v=dot h=.8;
symbol2 c=red v=dot h=.8;
symbol3 c=green v=dot h=.8;
axis1 order=(10 to 50 by 10) label=(a=90 'Sales in Promotion Period');
axis2 order=(15 to 35 by 5) label=('Sales in Preceding Period');
legend1 label=none value=(height=1 font=swiss 'Treatment 1' 'Treatment 2' 'Treatment 3' ) 
        position=(bottom right inside) mode=share cborder=black;
proc gplot data=cplot;
  plot (treat1 treat2 treat3)*x/overlay legend=legend1 vaxis=axis1 haxis=axis2;
run;


*** single-factor ANCOVA with parallel lines; 
***  1) Creat an ANOVA table;
***     1a) estimate the parameters including the slope. ;
***     1b) use the output to test for treatment effects --- Use type III SS and read the F value and p-value for `treat';
***             the result is the same as the goodness-of-fit test on page 929.	(see below goodness-of-fit test);
***     1c) How to check if the slope is statistically significantly different from zero? (hint. using a similar way as in 1b);
title "full model --- single factor ANCOVA";
proc glm data=cracker;
 class treat;
 model y = treat x /solution ;
run;


*****************************;
****** goodness-of-fit test;
*****************************;

******* Step 1. fit the full model and obtain SSE(F)= 38.5713085  and df(F) = 11;
title "full model";
proc glm data = cracker;
 class treat;
 model y = x treat;
run;

******* Step 2. fit the reduced model (with no treatment effect) and obtain SSE(R)= 455.7222222 and df(R) = 13;
title "reduced model --- with no treatment effect";
proc glm data = cracker;
 class treat;
 model y = x;
run;
 
****** Use the result to calculate F* = [(SSE(R) - SSE(F))/(df(R) - df(F))] / [SSE(F)/df(F)];
****** The F* =  59.48 should be the same as the F-value for `treat' when TYPE III SS is considered for the full model --- see 1b) above;
****** Note. F* should follow a F distributino with d.f.'s (df(R) - df(F) = 2) and df(F) = 11; 
******       These d.f.'s can also be obtained from the output for the full model in 1);
***************************************************** ;


***  2) Study treatment effect L
***    hint rewite L in terms of the parameters in the model used by SAS; 

proc glm data=cracker;
 class treat;
 model y = treat x /solution clparm alpha =0.1;

***     2a) obtain estimates and SDs for
***          (tau1 - tau2), (tau1 - tau3), and (tau2-tau3);

 estimate 'tau_1 - tau_2' treat 1 -1 0;
 estimate 'tau_1 - tau_3' treat 1 0 -1 ;
 estimate 'tau_2 - tau_3' treat 0 1 -1;

***     2b) study L = tau1 - ((tau2+tau3)/2);
***          how to constrcut 90% confidence intervals using the output? ;

 estimate 'L=tau_1 - (tau_2 + tau_3)/2' treat 1 -.5 -.5;


***     2c) study the mean response with the ith treatment for a "typical" value of X (x=mean x);

 estimate 'mu_1(xbar)' intercept 1 treat 1 0 0 x 25;
 estimate 'mu_2(xbar)' intercept 1 treat 0 1 0 x 25;
 estimate 'mu_3(xbar)' intercept 1 treat 0 0 1 x 25;

***     something fun to learn: estimates of the parameters of the model in the textbook;

 estimate 'mu_dot' intercept 3 treat 1 1 1 x 75/divisor=3; 

run;

proc glm data=cracker;
 class treat;
 model y = treat x /solution clparm alpha =0.1;
 estimate 'mu_dot' intercept 3 treat 1 1 1 x 75/divisor=3;

 estimate 'tau_1_hat = mu_1(xbar) - mu_dot' treat 2 -1 -1/divisor=3; 
 estimate 'tau_2_hat' treat -1 2 -1/divisor=3; 
 estimate 'tau_3_hat' treat -1 -1 2/divisor=3; 
run;

quit;


**** how to btain the mean;
proc means data=cracker mean;
 var x;
run;

***  3) multiple comparison procedures --- 
***          note. Tukey method is not appropriate for covariance analysis; * <----------important;
***          Use Sheffe procedure to find C.I.'s for all pairwise comparisons
***          Compare it with Bonferroni procedure. Which one is more efficient?;

title "full model: multiple comparisons";
proc glm data = cracker;
 class treat;
 model y = x treat;
 lsmeans treat / cl adjust=scheffe;
 lsmeans treat / cl adjust=bon;
run;

***  4) fitted value
***     4a) obtain fitted values, their SDs and C.I.s;
proc glm data=cracker; 
class treat;
 model y = treat x /p clm alpha=0.1;
 output out=out r=r p=p stdp=stdp lclm =lclm uclm=uclm; 
run;

quit;

*** plot of  r vs. p;
proc gplot data=out;
 plot r*p;
run;

*** Extra (we've seem similar stuff before): plot of  r vs. p by group;
***** we can also use this skill to plot y vs. x by group without using overlay (how?);
***** how about p vs. x by group (thsee dots follow the lines described by the ANCOVA model);

goptions reset=all;
symbol1 c=blue v=dot h=.8;
symbol2 c=red v=dot h=.8;
symbol3 c=green v=dot h=.8;
legend1 label=none value=(height=1 font=swiss 'Treatment 1' 'Treatment 2' 'Treatment 3' ) 
        position=(bottom right inside) mode=share cborder=black;

proc gplot data=out;
 plot r*p=treat / legend=legend1 vaxis=axis1 haxis=axis2;
run;


***  5) Diagnosis:
***     5a) Test for parallel slopes;

*** look at type III SS: the p-value obtained for treat*x can be used to check
            if "H0: the slopes are the same" is reasonable or not ***;
*** if treat*x is significant, we cannot use the ANCOVA introduced here. 
****   See page 923 (constancy of slopes) for further discussiosn.;  

title "full model: test for parallel slopes";
proc glm data=cracker;
 class treat;
 model y=treat x treat*x;
run;

***     5b) Study the residual;
ods graphics on;
proc glm data=cracker plots=DIAGNOSTICS residuals;
 class treat;
 model y = x treat;
run;
ods graphics off;


**************Appendix************
***** use sql and macro (optional);

**** Step 1. calculate the mean of X and put it to a macro variable, &xavg;
 
proc sql noprint;
  select mean(x) into :xavg
  from cracker;
quit;

%put check log for this macro value: &xavg.;

**** Step 2. Use this macro variable in the code;

proc glm data = cracker;
 class treat;
 model y = x treat;
 estimate "mean response for tx 1 at X=&xavg" intercept 1 treat 1 0 0 x &xavg;
 estimate "mean response for tx 2 at X=&xavg." intercept 1 treat 0 1 0 x &xavg.;
 estimate "mean response for tx 3 at X=&xavg." intercept 1 treat 0 0 1 x &xavg.;
run;

quit;




 
