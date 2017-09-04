*** Ch18. Checking Assumptions;

dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data food;
  input sales design store;
cards;
  11  1  1
  17  1  2
  16  1  3
  14  1  4
  15  1  5
  12  2  1
  10  2  2
  15  2  3
  19  2  4
  11  2  5
  23  3  1
  20  3  2
  18  3  3
  17  3  4
  27  4  1
  33  4  2
  22  4  3
  26  4  4
  28  4  5
;
run;

******************************************************
*** ods creates graphics for ANOVA diagnostics;
******************************************************

***  On the Results window: 
***          1) Expand the Analysis of Variance folder, 
***          2) Expand the sales (the response) folder,
***          3) click on the Diagnostics Panel
***  We've looked at:
***    (1,1): residual plot vs. fitted values
***    (2,1): normal probability plot (QQplot)
***    (3,1): provides the histogram of the residual
***    (1,2): studentized delted residual vs. fitted value;

ods graphics on;
proc glm data=food plots=DIAGNOSTICS residuals;
  class design;
  model sales=design;
  output out=tmp r=r;
run;
ods graphics off;


****************************************************** ;
*** a macro function to create the correlation coefficient test;
******************************************************;

%macro corrTest(data=, residual=r, plot=on);
%*** data= (name of the data set that contains the residual);
%*** residual= (variable name of the residual in the data set, default is 'r');
%*** plot = (on/off), the normal probability will not be created if plot=off; 

%************************************************
 
%*** order the residual;
 proc sort data=&data. out=s&data.;
   by &residual.;
 run;

%*** use sql to obtain the size of the data and assign the size to a macro variable n;
proc sql noprint;
 select count(*) into :n 
 from s&data.;
quit;
 
data s&data.;
 set s&data.;
 kID = _n_; %** create a cloumn indicating the rank of the response;
 rankit = quantile('NORMAL', (kID-(3/8))/(&n.+.25)); %** create the rankit;
run;

%*** normal probability plot, can be turned off by assign plot=off;
%if &plot=on %then
 %do;
  goptions reset=all;
  symbol1 value=dot color=blue height=2;  
  proc gplot;
   plot &residual.*rankit;
  run;
  goptions reset=all;
 %end;

 %*** obtain the correlation coefficient;
proc corr;
 var &residual. rankit;
 ods select PearsonCorr;
run;
%mend;

**** To use the macro function, just enter the data name that contains the residual;
**** You can change the value of one or more parameters, as in the example below; 
 
%corrTest(data=tmp);

**** or change some inputs;
* %corrTest(data=tmp, plot=off);

