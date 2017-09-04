dm "output;clear;log;clear";
options nocenter nonumber nodate;

data insurance;
  input premium city region;
cards;
  140  1  1
  100  1  2
  210  2  1
  180  2  2
  220  3  1
  200  3  2
;
run;

%macro TukeyOneDfT(dataset=, X1=, X2=, Y=, alpha=0.1);  
%*** --- by Ming-Hung (Jason) Kao, Feb.2010;

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
 length NfactorA $1 NfactorB $1; 
 Omean = &Omean.;
 NfactorA = &X1;
 NfactorB = &X2;
 output;
run;

proc sql;
 create table TukTab
 as select A.*, B.&Y.LSMean as MeanA
 from TukTab as A left join LM as B
 on (A.NfactorA = B.&X1.);
quit;

proc sql;
 create table TukTab
 as select A.*, B.&Y.LSMean as MeanB
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
 end;
 numerator = numerator + &Y.*(MeanA - Omean)*(MeanB - Omean);
 denominator = denominator + ((MeanA - Omean)**2)*((MeanB - Omean)**2);
 SSA = SSA+(MeanA - Omean)**2;
 SSB = SSB+(MeanB - Omean)**2;
 SSTO = SSTO+(&Y. - Omean)**2;
 
 SSAB =  numerator**2/denominator; 
 if lastone then
  do;
   SSRem = SSTO - SSA - SSB - SSAB;
   a = put(NfactorA, 5.0);
   b = put(NfactorB, 5.0);
   df2 =  (a*b - a - b);
   F =  SSAB/(SSRem/df2);
   Finv = Finv(1 - &alpha., 1, df2);
   pvalue = 1 - probF(F, 1, df2);
  end;

 retain numerator denominator SSA SSB SSTO;
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

%TukeyOneDfT(dataset=insurance, X1=city, X2=region, Y=premium, alpha = 0.1);  *<--- use this to obtain the result;

quit;
