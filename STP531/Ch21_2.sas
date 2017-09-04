/*
 Example from the SAS textbook (sec. 3.5)
 Five methods of applying irrigration (IRRIG) are applied 
 to a Valencia orange tree grove. The trees in the grove 
 are arranged in eight blocks (BLOC) to account for local variation.
 Variation among trees within a block is minimized.
 Assignment of the irrigation method to trees within each 
 block is ranodm; we have a RCBD. At harvet, for each plot the 
 fruit is weighted in pounds. The objective is to determine 
 if method of irrigation affects fruit weight (FRUITWT)
*/
 
dm "output;clear;log;clear";

* 1. data --- a skill to learn;
data methods;
 input irrig $ @@;
  do bloc = 1 to 8;
    input fruitwt @@;
    output;
  end; 
datalines;
 trickle   450 469 249 125 280 352 221 251
 basin     358 512 281  58 352 293 283 186
 spray     331 402 183  70 258 281 219  46
 sprnkler  317 423 379  63 289 239 269 357
 flood     245 380 263  62 336 282 171  98
;
run;

proc sort; 
 by bloc irrig;
run;

proc print;
 var bloc irrig fruitwt;
run;


proc glm;
 class bloc irrig;
 model fruitwt = bloc irrig;
 lsmeans irrig/adjust=tukey cl alpha=0.1;
run;


