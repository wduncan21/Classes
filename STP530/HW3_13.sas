data copy;
infile 'B:\dropbox\class\STP530\C1E20.txt';
input y x;
run;

proc reg data=copy;
model y=x/lackfit;
run;
