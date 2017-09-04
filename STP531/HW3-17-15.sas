dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data therapy;
input time group $;
cards;
29 abelow
42 abelow
38 abelow
40 abelow
43 abelow
40 abelow
30 abelow
42 abelow
30 baverage
35 baverage
39 baverage
28 baverage
31 baverage
31 baverage
29 baverage
35 baverage
29 baverage
33 baverage
26 cabove
32 cabove
21 cabove
20 cabove
23 cabove
22 cabove
;
run;

proc glm data=therapy alpha = 0.01; 
  class group;
  model time=group /clparm; *produces confidence limits for the parameter estimates;
  estimate 'd1vsd2 v. d2vsd3' group 1 -2 1;
run;

quit;

proc glm data=therapy alpha = 0.0125; 
  class group;
  model time=group /clparm; *produces confidence limits for the parameter estimates;
  estimate 'd1 v. d2' group 1 -1 0;
  estimate 'd2 v. d3' group 0 1 -1;
  estimate 'd1 v. d3' group 1 0 -1;
  estimate 'd1vsd2 v. d2vsd3' group 1 -2 1;

run;

quit;
