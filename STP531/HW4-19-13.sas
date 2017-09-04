dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data eye;
input rating eye gender id;
cards;
11.0      1      1      1
    7.0      1      1      2
   12.0      1      1      3
    6.0      1      1      4
   10.0      1      1      5
   15.0      1      2      1
   12.0      1      2      2
   14.0      1      2      3
   11.0      1      2      4
   16.0      1      2      5
   12.0      2      1      1
   16.0      2      1      2
   10.0      2      1      3
   13.0      2      1      4
   14.0      2      1      5
   14.0      2      2      1
   17.0      2      2      2
   13.0      2      2      3
   20.0      2      2      4
   18.0      2      2      5
;
run;

proc glm data=eye;
  class gender eye;
  model rating=gender eye gender*eye; 
  output out=Means p=yhat r=r;
run;
