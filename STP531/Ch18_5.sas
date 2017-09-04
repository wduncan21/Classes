****************************************************** ;
*** sequence plot of the residuals
****************************************************** ;

dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

*The example on page 783;
data ABT;
  input y group j;
cards;

  14.87  1  1
  16.81  1  2
  15.83  1  3
  15.47  1  4
  13.60  1  5
  14.76  1  6
  17.40  1  7
  14.62  1  8
  18.43  2  1
  18.76  2  2
  20.12  2  3
  19.11  2  4
  19.81  2  5
  18.43  2  6
  17.16  2  7
  16.40  2  8
  16.95  3  1
  12.28  3  2
  12.00  3  3
  13.18  3  4
  14.99  3  5
  15.76  3  6
  19.35  3  7
  15.52  3  8
   8.59  4  1
  10.90  4  2
   8.60  4  3
  10.13  4  4
  10.28  4  5
   9.98  4  6
   9.41  4  7
  10.04  4  8
  11.55  5  1
  13.36  5  2
  13.64  5  3
  12.16  5  4
  11.62  5  5
  12.39  5  6
  12.05  5  7
  11.95  5  8
;
run;


proc glm data=ABT;
 class group;
 model y = group;
 output out=tmp r=r;
run;

 *** create the plot for all observations;

data tmp;
 set tmp;
 id = _n_; *** assign the index to the residual;
run;

symbol1 value=dot height=2;
proc gplot data=tmp;
 plot r*id;
run;

 *** create the plot for each group;

symbol1 value=dot height=2;
proc gplot data=tmp;
 by group;
 plot r*j;
run;



quit;