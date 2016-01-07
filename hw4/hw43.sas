
data p3a;
input k nk;
datalines;
0 2303 
1 831 
2 565 
3 212 
4 67 
5 23 
6 15 
7 3 
8 1 
9 1
;
run;
data p3a;
set p3a;
log_nk=log(nk);
log_kf=log(fact(k));
phi=log_nk+log_kf-log(4021);output;
run;
axis1 label=(a=90 "Count Metameters");
symbol1  height=0.8 v=dot i=r;

ods rtf file='as.rtf';
proc gplot data=p3a;
plot phi*k/vaxis=axis1;
title "Poisson Model";
run;
ods rtf close;

data p3c;
input lmd @@;
datalines;
1 2 3 4 5 6 7 8 9 10
;
run;
data p3c;
set p3c;
E=lmd/(1-exp(-lmd));
output;
label E="mean of ZTP";
run;
data p3c1;
set p3a;
mean1=k*nk/1718;output;
run;
proc means data=p3c1 noprint;
var mean1;
output out=out sum=sum;
run;
proc print data=out;
run;

data p3c;
set p3c;
if _N_=1 then set out;
drop _TYPE_ _FREQ_;
label sum="sample means";
run;

data p3c2;
set p3a;
if k=0 then probability=2303/4021;
else probability=(1-0.419)*1.33**k/fact(k)*exp(-1.33);
output;
keep k probability;
run;
proc print data=p3c2 noobs;
title "Fitted ZIP Distribution";
run;

data p3d1;
set p3a;
keep nk;
run;
data p3d;
merge p3c2 p3d1;
run;
data p3d;
set p3d;
ExpectedFrequency=probability*4021;output;
run;

proc print data=p3d;
run;

 
