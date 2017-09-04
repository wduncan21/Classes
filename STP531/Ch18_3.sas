******************************************************
***  the Brown-Forsythe test; 
******************************************************;

dm "log;clear;output;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data food;
  input sales design store;
cards;
  11  1  1
  17  1  2
  16  1  3
  14  1  4
  15  1  5
  12  2  1
  10  2  2
  15  2  3
  19  2  4
  11  2  5
  23  3  1
  20  3  2
  18  3  3
  17  3  4
  27  4  1
  33  4  2
  22  4  3
  26  4  4
  28  4  5
;
run;


*** Also introduce one additional use of ODS: see also Ch18_2.sas;
***   I used to use "ods trace on" and "ods trace off" to obtain the Names of ods Tables;
***   the Table names are presetned in the Log Window;
***   We can use ods select to show specific tables;
***   We can also use ods exclude to exclude specified tables; 
 
ods trace on; 

proc glm data=food;
  class design;
  model sales=design;
  means design /HOVTEST=BF;  *** Brown-Forsythe test;
*  ods select HOVFTest; *** only show this table since the other tables are obtained from the previous glm;
run;

ods trace off;

*** Based on the test result (e.g. p-value < 0.05), we do not reject the null hypothesis with alpha = 0.05; 

**** other HOV tests are also available:
http://support.sas.com/documentation/cdl/en/statug/63347/HTML/default/viewer.htm#statug_glm_sect018.htm;

quit;
