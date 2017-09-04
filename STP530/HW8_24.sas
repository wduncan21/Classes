data test;
infile'B:\dropbox\class\Fall 2013\STP530\C8E24.txt';
input y x1 x2;
x1x2=x1*x2;
run;

proc gplot data=test;
plot y*x1=x2;
run;
quit;

proc reg data=test plots=none;
model y=x1 x2 x1x2;
test x2=x1x2=0;
run;
quit;


data new;
set test;
if x2=0 then do;
z1=x1;
y1=y;
end;
if x2=1 then do;
z2=x1;
y2=y;
end;
run;

proc reg data=new noprint;
model y=z1;
output out =temp1 p=p1;
run;

proc reg data=temp1 noprint;
model y=z2;
output out =temp p=p2;
run;
quit;

symbol1 c=black v=circle;
symbol2 c=black v=dot i=none;
symbol3 i=join v=none;
symbol4 i=join v=none;
axis1 label=('valuation');
axis2 label=('price');
proc gplot data=temp;
plot y1*z1 y2*z2 p1*z1 p2*z2/overlay haxis=axis1 vaxis=axis2;
run;
quit;
