data stereo;
 input NV  VV;
datalines;
      22    19.7
    20.4    16.2
    19.7    15.9
    17.4    15.4
    14.7     9.7
    13.4     8.9
      13     8.6
    12.3     8.6
    12.2     7.4
    10.3     6.3
     9.7     6.1
     9.7     6.0
     9.5     6.0
     9.1     5.9
     8.9     4.9
     8.9     4.6
     8.4     3.8
     8.1     3.6
     7.9     3.5
     7.8     3.3
     6.9     3.3
     6.3     2.9
     6.1     2.8
     5.6     2.7
     4.7     2.4
     4.7     2.3
     4.3     2.0
     4.2     1.8
     3.9     1.7
     3.4     1.7
     3.1     1.6
     3.1     1.4
     2.7     1.2
     2.4     1.1
     2.3     1.0
     2.3       .
     2.1       .
     2.1       .
       2       .
     1.9       .
     1.7       .
     1.7       .
;
run;

data p2;
set stereo;
v=NV ; group=1; output;
v=VV ; group=2; output;
run;

proc sort data=p2;
by group;
run;

proc format;
value g 1='NV'
        2='VV';
run; 

proc boxplot data=p2;
plot v*group ;
format group g.;
title 'Side-by-side Boxplot for NV & VV'; 
run;

data p21(keep=VV) p22(keep=NV);
set stereo;
run;

data lamda;
input lamda1 lamda2 lamda3 lamda4 lamda5;
datalines;
-0.5 -0.25 0 0.25 0.5
;
end;


data p21;
set p21 lamda;
array lamda{5} lamda1-lamda5;
do i=1 to 5;
if lamda{i}=0 then VV=log(VV);
else VV=(VV**lamda{i}-1)/lamda{i};
end;
run;


proc sort data=p21;
by VV;
run;

proc univariate data=p21 noprint;
var VV;
output out=out_vv n=n median=m;
run;

data p21;
set p21;
if _n_=1 then set out_vv;
run; 

data p21;
set p21;
i=_n_;
l=VV-m;
u=m-VV;
keep i l u n;
run;

data p21_u;
set p21;
if int(n/2)=n/2 then do ;
if i>n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i>(n+1)/2 then delete;
end;
keep u;
run;

data p21_l;
set p21;
if int(n/2)=n/2 then do ;
if i<=n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i<(n+1)/2 then delete;
end;
keep l;
run;

proc sort data=p21_u;
by u;
run;

proc sort data=p21_l;
by l;
run;

data p21_ul;
merge p21_u p21_l;
run;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2 "L") offset=(4);
axis2 label=(height=1.2 "U") offset=(4);

proc gplot data=p21_ul;
plot l*u/ haxis=axis2 vaxis=axis1 ;
title 'The Symmetry Plot of VV (lamda=-0.5)';
run;
