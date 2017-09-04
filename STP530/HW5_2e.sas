
PROC IML;
/*
    The regression subroutine
*/
START reg(X,Y,B,YHAT);
  n=NROW(X);
  k=NCOL(X);
  XPX=X`*X;
  XPY=X`*Y;
  IXPX=INV(XPX);
  B=IXPX`*XPY;
  YHAT=X*B;
FINISH;

/* The main program  */

  X={1 1 1,
     1 2 4,
     1 3 9,
     1 4 16,
     1 5 25};
  Y={3, 16, 12, 29, 39};
  RUN REG(X,Y,BETA,YHAT);
  PRINT BETA YHAT;
  RUN;
  quit;


PROC IML;
/*
    The regression subroutine
*/
START reg(X,Y,B,YHAT);
  n=NROW(X);
  k=NCOL(X);
  XPX=X`*X;
  XPY=X`*Y;
  IXPX=INV(XPX);
  B=IXPX`*XPY;
  YHAT=X*B;
FINISH;

/* The main program  */

  X={1 -2 -2,
     1 -1 -1,
     1 0 -2,
     1 1 -1,
     1 2 2};
  Y={3, 16, 12, 29, 39};
  RUN REG(X,Y,BETA,YHAT);
  PRINT BETA YHAT;
  RUN;
  quit;
