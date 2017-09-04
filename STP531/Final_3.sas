data test;
infile' B:\Dropbox\class\Fall 2013\STP531\diet.txt' delimiter='09'x;
input diet age weight gain;
run;

proc glm data=test plots=diagnostics;
  class  diet age;
  model gain=diet age weight age*diet/clparm;
  estimate 'estimate new obs' intercept 1 age 0.7 0.3 diet 0 1 0 0  weight 58 age*diet 0 0 0.7 0.3 0 0 0 0 ;
run; 
quit;
