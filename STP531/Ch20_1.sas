dm "output;clear;log;clear";

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

proc glm data=insurance;
  class city region;
  model premium = city region;
  lsmeans city region /pdiff cl adjust=tukey;
  estimate 'small vs. medium' city 1 -1 0;
  estimate 'small vs. large' city 1 0 -1;
  estimate 'medium vs. large' city 0 1 -1;
  estimate 'east vs. west' region 1 -1;
  output out=out p=p stdp = stdp uclm=uclm lclm=lclm;
run;

*** optional --- calculating CI's by hand;
data out;
 set out;
 a = 3;
 b = 2;
 ab = a*b;
 ste = sqrt(50*((a-1)*(1/a - 1/ab)**2 + (b-1)*(1/b - 1/ab)**2 + (a-1)*(b-1)*(1/ab)**2 + (1/a + 1/b - 1/ab)**2));
 CIL = p - tinv(.975,2)*stdp;
 CIU = p + tinv(.975,2)*stdp;
 output;
run;

proc print data=out;
var p stdp ste lclm uclm CIL CIU;
run;

*** optional --- use IML to obtain the variance of mu_{ij};
proc iml;
 X = {1 1 0 0 1 0,
      1 1 0 0 0 1,
	  1 0 1 0 1 0,
	  1 0 1 0 0 1,
	  1 0 0 1 1 0,
	  1 0 0 1 0 1};
 XtX =X`*X;  *** X'X;
 ginvX = sweep(XtX); *** obtain a generalized inverse for X'X;
 c = {1 1 0 0 1 0};	 *** c';
 stderr = sqrt(50*c*ginvX*c`); *** standard error;
 print stderr;
quit;


quit;
