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
proc glm data=eye alpha=0.01; 
  class eye gender;
  model rating=eye gender eye*gender /clparm ;  
  lsmeans eye*gender/cl;
  lsmeans eye/cl;
  lsmeans gender/cl;
  ods output LSMeans=Means;
run;

data Gmeans;
set means;
if Effect ne 'gender' then delete;
if gender=1 then gender='M';
if gender=2 then gender='F';
run;

title 'lsmeans by gender';
proc sgplot data=Gmeans;
  vbar gender / response=lsmean stat=sum nostatlabel;
  xaxis display=(nolabel);
  yaxis grid;
 run;

data Emeans;
set means;
if Effect ne 'eye' then delete;
if eye=1 then eye='Y';
if eye=2 then eye='N';
run;

title 'lsmeans by eye contact';
proc sgplot data=Emeans;
  vbar eye / response=lsmean stat=sum nostatlabel;
  xaxis display=(nolabel);
  yaxis grid;
 run;

proc glm data=eye alpha=0.025; 
  class eye gender;
  model rating=eye gender eye*gender /clparm ;  
  estimate 'mu2. - mu1.' eye -1 1;
  estimate 'mu.2 - mu.1' gender -1 1;
run;
