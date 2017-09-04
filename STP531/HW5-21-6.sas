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

proc glm data=test alpha=0.1;
 class treat block;
 model y = treat block;
 lsmeans treat/adjust=tukey cl pdiff;
 ods output LSMeans=Means;
run;
quit;

title 'lsmeans by training method';
proc sgplot data=means;
  vbar treat / response=lsmean stat=sum nostatlabel;
  xaxis display=(nolabel);
  yaxis grid;
 run;
