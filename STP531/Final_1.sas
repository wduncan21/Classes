data wheat;
input variety block growth;
cards;
1 1 9.7
1 2 6.6
1 3 7.6
1 4 8.1
1 5 5.4
2 1 11.8
2 2 9.7
2 3 10.9
2 4 11.3
2 5 10.7
3 1 6.3
3 2 5.3
3 3 4.7
3 4 5.5
3 5 4.5
4 1 4.6
4 2 3.4
4 3 2.7
4 4 3.6
4 5 2.8
;
run;



proc glm data=wheat alpha=0.05;
  class variety block;
  model growth=variety block;
  estimate 'µ.1 vs µ.2' variety 1 -1 0 0;
run;
quit;

proc glm data=wheat alpha=0.05;
  class variety block;
  model growth=variety block;
  estimate 'µ.1 vs µ.2' variety 1 -1 0 0;
run;
quit;
proc glm data=wheat alpha=0.05;
  class variety;
  model growth=variety;
run;
quit;
