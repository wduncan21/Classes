data mat;
input y x1 x2;
cards;
3 1 1
16 2 4
12 3 9
29 4 16
39 5 25
;
run;

proc reg data=mat;
model y=x1 x2/ss1 ss2;
output out=fit p=yhat;
run;
proc print data=fit;run;

data ort;
input y x1 x2;
cards;
3 -2 -2
16 -1 -1
12 0 -2
29 1 -1
39 2 2
;
run;

proc reg data=ort;
model y=x1 x2/ss1 ss2;
output out=fit p=yhat;
run;

proc print data=fit;run;
