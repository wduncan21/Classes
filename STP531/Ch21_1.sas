dm "output;clear;log;clear;";

data backpain;
 input block treat y;
 cards;
 1 1 1
 1 2 5
 1 3 8
 2 1 2
 2 2 8
 2 3 14
 3 1 7
 3 2 9
 3 3 16
 4 1 6
 4 2 13
 4 3 18
 5 1 12
 5 2 14
 5 3 17
 ;
run;

proc print;
 var block treat y;
run;

proc glm data=backpain;
 class block treat;
 model y = block treat;
 lsmeans treat/adjust=tukey cl;
run;

