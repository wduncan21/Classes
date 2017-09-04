data solution;
input y x;
cards;
   0.07    9.0
   0.09    9.0
   0.08    9.0
   0.16    7.0
   0.17    7.0
   0.21    7.0
   0.49    5.0
   0.58    5.0
   0.53    5.0
   1.22    3.0
   1.15    3.0
   1.07    3.0
   2.84    1.0
   2.57    1.0
   3.10    1.0
;
run;

proc glm data=solution alpha=.025;
class x;
model y=x;
run;
quit;

proc glm data=solution alpha = 0.0125; 
  class x;
  model y=x /clparm; *produces confidence limits for the parameter estimates;
  estimate 'd1 v. d3' x 1 -1 0 0 0;
  estimate 'd3 v. d5' x 0 1 -1 0 0;
  estimate 'd5 v. d7' x 0 0 1 -1 0;
  estimate 'd7 v. d9' x 0 0 0 1 -1;
 run;
 quit;
