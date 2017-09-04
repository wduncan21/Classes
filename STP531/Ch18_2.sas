*** Hartley test using the example on page 783;

dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data ABT;
  input y fluxtype joint;
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

ods trace on; * helps to see the table names of the outputs in the output window;
proc glm data=ABT;
 class fluxtype;
 model y = fluxtype;
 means fluxtype;
 ods output Means=Means;  * create a table for the output that we need;
run;
ods trace off;

data Means;
 set Means; *use the Means data set;
 s2 = SD_y**2; ** find the variance for each group;
run;

proc print data=Means;
  var SD_y s2;
run;

** There are many ways to find max and min, e.g., proc sort;
*** Here, we use proc sql to help to calcuate the H^*;
proc sql;
 select max(s2)/min(s2) as Hstar
   from Means;
quit;

** We then compare Hstar with the critical value obtained from Table B.10.
(see page 783-784);

