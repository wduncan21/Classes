data test;
infile'B:\dropbox\class\Fall 2013\STP530\C9E15.txt';
input y x1 x2 x3;
run;

proc reg data=test;
model y=x1-x3/vif;
output out=res r=r p=yhat;
run;
quit;

proc gplot data=res;
plot r*yhat;
run;
quit;

proc reg data=test noprint;
model y x1=x2 x3;
output out=temp1 r=ry rx;
model y x2= x1 x3;
output out=temp2 r=ry rx;
model y x3= x1 x2;
output out=temp3 r=ry rx;
run;
symbol1 v=dot c=black;
axis1 label=('e(Y|X X)');
proc gplot data=temp1;
plot ry*rx/vaxis=axis1;
label rx='e(X1|X2 X3)';
run;
quit;
proc gplot data=temp2;
plot ry*rx/vaxis=axis1;
label rx='e(X2|X1 X3)';
run;
quit;
proc gplot data=temp3;
plot ry*rx/vaxis=axis1;
label rx='e(X3|X1 X2)';
run;
quit;


data new;
set test;
lny=log(y);
lnx1=log(x1);
lnx2=log(140-x2);
lnx3=log(x3);
run;
proc reg data=new;
model lny=lnx1-lnx3/vif influence;
output out=result1 cookd=cookd dffits=dffits;
ods output outputstatistics=result2;
run;
quit;
proc print data=result1;
var cookd;
run;

data t;
tvalue=tinv(0.99848485,28);
run;
proc print data=t;
run;


data result1;
set result1;
percent1=100*probf(cookd,4,29);
run;

proc print data=result1;
   var percent1;
run;
