data sat;
infile 'B:\dropbox\class\Fall 2013\STP530\C6E15.txt';
input y x1 x2 x3;
run;
proc reg data=sat;
  model y=x1  x2 x3/ss1;
run;
quit;
