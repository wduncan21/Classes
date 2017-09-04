data cracker;
   input y x treat store;
cards;
  38  21  1  1
  39  26  1  2
  36  22  1  3
  45  28  1  4
  33  19  1  5
  43  34  2  1
  38  26  2  2
  38  29  2  3
  27  18  2  4
  34  25  2  5
  24  23  3  1
  32  29  3  2
  31  30  3  3
  21  16  3  4
  28  29  3  5
;
run;

proc glm data=cracker;
 class treat;
 model y = treat x treat*x/solution;
 estimate 'slope for the 1st group' x 1 treat*x 1 0 0;
 estimate 'slope for the 2nd group' x 1 treat*x 0 1 0;
 estimate 'slope for the 3rd group' x 1 treat*x 0 0 1;
 estimate 'u1(25) - u2(25)' treat 1 -1 0 treat*x 25 -25 0;
run;
