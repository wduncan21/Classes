data lipid;
input Level age diet;
cards;
   0.73      1      1
   0.67      1      2
   0.15      1      3
   0.86      2      1
   0.75      2      2
   0.21      2      3
   0.94      3      1
   0.81      3      2
   0.26      3      3
   1.40      4      1
   1.32      4      2
   0.75      4      3
   1.62      5      1
   1.41      5      2
   0.78      5      3
;
run;

proc glm data=lipid plots=DIAGNOSTICS alpha=0.025;
 class age diet;
 model Level = age diet;
 lsmeans diet/ cl pdiff;
 estimate 'diet1 vs. diet2' diet 1 -1 0;
 estimate 'diet2 vs. diet3' diet 0 1 -1;
 output out=residual p=fit r=r;
run;
quit;

title 'lsmeans by diet';
proc sgplot data=lipid;
  vbar diet / response=level stat=mean limitstat=clm;
 run;
