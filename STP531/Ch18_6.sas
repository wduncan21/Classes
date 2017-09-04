****************************************************** ;
*** Weighted Least Squares
****************************************************** ;

dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

*The ABT example on page 783 and page 787;
data ABT;
  input y group$ j; 

** note. I am using group$, so that the data type of this variable
         will be the same as that in the Means dataset created below;
** we need this for proc sql. This will not change the results of proc glm;
 
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

* 1. checking assumptions & obtain sample variance for each group;
ods graphics on;
proc glm data=ABT plot=diagnostics;
 class group;
 model y = group;
 means group /HOVTEST=BF;
 ods output Means=Means;
run;
ods graphics off;

** From the figures, the normality assumption seems valid. 
** However, we seem to have unequal variances;
** The BF test also indicate that the unconstancy of error variances might be an issue;

* 2. conduct a weighted least sqaures analysis
*** From the SAS output, we can find sample standard deviations for each group.
    We can use them to obtain the weights.;

*** For each observation, we will need to specify the corresponding weights;
*** The data set that we need to use should look like the one on ABTW.txt;
*** You may calculate the weights and enter them on your own;


*** We may also use the following method to create this data set (*optional*);

* 2-1. Use the dataset Means;
*** The dataset Means contains the standard deviation; 
*** We now add a column for weights = 1/(standard devation)^2;

data Means;
 set Means; 
 weights = 1/(SD_y)**2;
run;

*** The next step is to combine the two datasets, ABT and Means;
*** We want to make sure that the observations in the same group 
     have the same weight;
*** We will use proc sql;

proc sql;
 create table ABTW as
 select * 
   from ABT left join Means
   on ABT.group = Means.group;
quit;

* 2-2 Now use proc glm to conduct the weighted least squares analysis;

proc glm data=ABTW;
 class group;
 model y = group;
 weight weights;
run;

quit;
