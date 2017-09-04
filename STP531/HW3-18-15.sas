data heli;
infile'B:\dropbox\class\STP531\C18E15.txt';
input count shift id;
run;

proc glm data=heli plots=DIAGNOSTICS;
  class shift;
  model count=shift;
  output out=tmp r=residual p=fittedvalue;
run;
quit;

proc print data=tmp;
run;
 
ods trace on; 

proc glm data=heli;
  class shift;
  model count=shift;
  means shift /HOVTEST=BF; 
  ods select HOVFTest Means;
run;

ods trace off;
quit;

data test;
input yhat std;
cards;
3.90000000 1.97084006 
1.15000000 1.08942283 
2.00000000 1.45095250 
3.40000000 1.78885438 
run;
data test;
set test;
test1=std**2/yhat;
test2=std/yhat;
test3=std/(yhat**2);
run;

data temp;
set heli;
count=count+1;
run;
proc transreg data=temp;
 model boxcox(count/ lambda=-1 to 1 by 0.1)=class(shift);
run; 
