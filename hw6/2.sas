data in;
input k n1 n2 n3;
datalines;
0       6           5          1 
1      18          15          3 
2      24          23          8 
3      22          22         14 
4      15          17         18 
5       8          10         18 
6       4           5         15 
7       2           2         10 
8       1           1          7 
9       0           0          4 
10      0           0          2 
;
run;

data in;
set in;
if n1>0 then log_n1=log(n1);
else log_n1=.;
if n2>0 then log_n2=log(n2);
else log_n2=.;
if n3>0 then log_n3=log(n3);
else log_n3=.;
log_kf=log(fact(k));
log_n1=log(n1*fact(k)/11);
log_n2=log(n2*fact(k)/11);
log_n3=log(n3*fact(k)/11);
phi1=log_n1+log_kf-log(11);
phi2=log_n2+log_kf-log(11);
phi3=log_n3+log_kf-log(11);
run;

symbol1  height=0.8 v=dot i=r;

ods rtf file='12.rtf';
proc gplot data=in;
plot phi1*k /overlay legend=legend
vaxis=axis2 haxis=axis1;
title "Poissonness Plot for n1";
run;
proc gplot data=in;
plot phi2*k /overlay legend=legend
vaxis=axis2 haxis=axis1;
title "Poissonness Plot for n2";
run;
proc gplot data=in;
plot phi3*k /overlay legend=legend
vaxis=axis2 haxis=axis1;
title "Poissonness Plot for n3";
run;
ods rtf close;

proc means data=in;
run;
