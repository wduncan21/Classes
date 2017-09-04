dm "output;clear;log;clear;";

data test;
 input y block treat;
 cards;
    73.0      1      1
   81.0      1      2
   92.0      1      3
   76.0      2      1
   78.0      2      2
   89.0      2      3
   75.0      3      1
   76.0      3      2
   87.0      3      3
   74.0      4      1
   77.0      4      2
   90.0      4      3
   76.0      5      1
   71.0      5      2
   88.0      5      3
   73.0      6      1
   75.0      6      2
   86.0      6      3
   68.0      7      1
   72.0      7      2
   88.0      7      3
   64.0      8      1
   74.0      8      2
   82.0      8      3
   65.0      9      1
   73.0      9      2
   81.0      9      3
   62.0     10      1
   69.0     10      2
   78.0     10      3
 ;
run;

proc glm data=test plots=DIAGNOSTICS;
 class treat block;
 model y = treat block;
lsmeans treat/adjust=tukey cl alpha=0.1;
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
plot y*treat=block;
run;
quit;

%macro TukeyOneDfT(dataset=, X1=treat, X2=block, Y=y, alpha=0.01);  
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


%TukeyOneDfT(dataset=test, X1=treat, X2=block, Y=y, alpha = 0.01);  *<--- use this to obtain the result;

quit;
