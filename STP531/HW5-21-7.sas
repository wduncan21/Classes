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


proc glm data=lipid plots=DIAGNOSTICS;
 class age diet;
 model Level = age diet;
 *lsmeans treat/adjust=tukey cl alpha=0.1;
 output out=residual p=fit r=r;
run;
quit;

proc print data=residual;
run;

symbol i=NONE v=circle;
proc gplot data=residual;
plot r*fit;
run;
quit;

symbol  i=join v=circle;
proc gplot data=residual;
plot Level*diet=age;
run;

%macro TukeyOneDfT(dataset=, X1=, X2=, Y=, alpha=0.1);  
%*** --- by Ming-Hung (Jason) Kao, Nov.2012;

ods listing close;
proc glm data=&dataset.;
  class &X1 &X2;
  model &Y = &X1 &X2 /ss3;
  lsmeans &X1 &X2;
  ods output FitStatistics=FS LSMeans=LM;
run;
ods listing;

data FS;
 set FS;
 call symput('Omean',DepMean);
run;

data TukTab;
 set &dataset.;
 length NfactorA $5 NfactorB $5; 
 Omean = &Omean.;
 NfactorA = &X1;
 NfactorA = left(NfactorA);
 NfactorB = &X2;
 NfactorB = left(NfactorB);
 output;
run;

proc sql;
 create table TukTab
 as select A.*, B.LSMean as MeanA
 from TukTab as A left join LM as B
 on (A.NfactorA = B.&X1.);
quit;


proc sql;
 create table TukTab
 as select A.*, B.LSMean as MeanB
 from TukTab as A left join LM as B
 on (A.NfactorB = B.&X2)
 order by A.NfactorA, A.NfactorB;
quit; 

data TukTab;
 set TukTab end = lastone;
 if _n_ = 1 then do;
   numerator = 0;
   denominator = 0;
   SSA=0;
   SSB=0;
   SSTO = 0;
   r = 0;
   nb = 0;

 end;
 numerator = numerator + &Y.*(MeanA - Omean)*(MeanB - Omean);
 denominator = denominator + ((MeanA - Omean)**2)*((MeanB - Omean)**2);
 SSA = SSA+(MeanA - Omean)**2;
 SSB = SSB+(MeanB - Omean)**2;
 SSTO = SSTO+(&Y. - Omean)**2;
 a = put(NfactorA, 5.0);
 b = put(NfactorB, 5.0);
 if a > r then r=a;
 if b > nb then nb =b; 
 
 SSAB =  numerator**2/denominator; 
  if lastone then
  do;
   SSRem = SSTO - SSA - SSB - SSAB;
   df2 = (r*nb - r - nb);
   F =  SSAB/(SSRem/df2);
   Finv = Finv(1 - &alpha., 1, df2);
   pvalue = 1 - probF(F, 1, df2);
  end;
 retain numerator denominator SSA SSB SSTO r nb;
 if lastone;
run;

title "Tukey one degree of freedom test, with alpha = &alpha.";
proc print data = Tuktab noobs; 
 var SSAB SSRem df2 F Finv pvalue;
run;

proc datasets;
 delete LM FS TukTab;
run;

%mend;


%TukeyOneDfT(dataset=lipid, X1=age, X2=diet, Y=Level, alpha = 0.01);  *<--- use this to obtain the result;

quit;
quit;
