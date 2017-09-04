data mass;
infile'D:\dropbox\class\STP530\C1E27.txt';
input y x;
label x='age'
      y='muscle mass';
run;
/*for Qustion 1.27*/
proc reg data=mass;
model y=x;
output out=regout p=yhat;
run;

symbol1 v=dot i=none color=black;
symbol2 v=none i=join color=black l=1 w=2;

proc sort data=regout;by yhat;run;
proc gplot data=regout;
 plot yhat*x=2 y*x=1 /overlay;
 run;
/* for 2.27*/

