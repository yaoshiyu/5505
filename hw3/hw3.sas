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

proc univariate data=p2;
var NV VV;
run;

ods rtf file='1.rtf';
proc boxplot data=p2;
plot v*group /totpanels=1
             boxstyle=schematic;
format group g.;
title 'Side-by-side Boxplot for NV & VV'; 
run;
ods rtf close;


data p21(keep=VV) p22(keep=NV);
set stereo;
run;

data p21;
set p21;
if VV=. then delete;
run;


/*lamda=-0.5*/
data p211;
set p21 ;
VV=(VV**(-0.5)-1)*(-2);
run;


proc sort data=p211;
by VV;
run;

proc univariate data=p211 noprint;
var VV;
output out=out_vv n=n median=m;
run;

data p211;
set p211;
if _n_=1 then set out_vv;
run; 

data p211;
set p211;
i=_n_;
l=VV-m;
u=m-VV;
keep i l u n;
run;

data p211_u;
set p211;
if int(n/2)=n/2 then do ;
if i>n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i>(n+1)/2 then delete;
end;
keep u;
run;

data p211_l;
set p211;
if int(n/2)=n/2 then do ;
if i<=n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i<(n+1)/2 then delete;
end;
keep l;
run;

proc sort data=p211_u;
by u;
run;

proc sort data=p211_l;
by l;
run;

data p211_ul;
merge p211_u p211_l;
run;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2 "L") offset=(4);
axis2 label=(height=1.2 "U") offset=(4);

ods rtf file='1.rtf';

proc gplot data=p211_ul;
plot l*u/ haxis=axis2 vaxis=axis1 ;
title 'The Symmetry Plot of VV (lamda=-0.5)';
run;
ods rtf close;


/*lamda=-0.25*/


data p212;
set p21 ;
VV=(VV**(-0.25)-1)/(-0.25);
run;


proc sort data=p212;
by VV;
run;

proc univariate data=p212 noprint;
var VV;
output out=out_vv2 n=n median=m;
run;

data p212;
set p212;
if _n_=1 then set out_vv2;
run; 

data p212;
set p212;
i=_n_;
l=VV-m;
u=m-VV;
keep i l u n;
run;

data p212_u;
set p212;
if int(n/2)=n/2 then do ;
if i>n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i>(n+1)/2 then delete;
end;
keep u;
run;

data p212_l;
set p212;
if int(n/2)=n/2 then do ;
if i<=n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i<(n+1)/2 then delete;
end;
keep l;
run;

proc sort data=p212_u;
by u;
run;

proc sort data=p212_l;
by l;
run;

data p212_ul;
merge p212_u p212_l;
run;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2 "L") offset=(4);
axis2 label=(height=1.2 "U") offset=(4);

ods rtf file='1.rtf';

proc gplot data=p212_ul;
plot l*u/ haxis=axis2 vaxis=axis1 ;
title 'The Symmetry Plot of VV (lamda=-0.25)';
run;

ods rtf close;

/*lamda=0*/

data p213;
set p21 ;
VV=log(VV);
run;


proc sort data=p213;
by VV;
run;

proc univariate data=p213 noprint;
var VV;
output out=out_vv3 n=n median=m;
run;

data p213;
set p213;
if _n_=1 then set out_vv3;
run; 

data p213;
set p213;
i=_n_;
l=VV-m;
u=m-VV;
keep i l u n;
run;

data p213_u;
set p213;
if int(n/2)=n/2 then do ;
if i>n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i>(n+1)/2 then delete;
end;
keep u;
run;

data p213_l;
set p213;
if int(n/2)=n/2 then do ;
if i<=n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i<(n+1)/2 then delete;
end;
keep l;
run;

proc sort data=p213_u;
by u;
run;

proc sort data=p213_l;
by l;
run;

data p213_ul;
merge p213_u p213_l;
run;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2 "L") offset=(4);
axis2 label=(height=1.2 "U") offset=(4);

ods rtf file='1.rtf';
proc gplot data=p213_ul;
plot l*u/ haxis=axis2 vaxis=axis1 ;
title 'The Symmetry Plot of VV (lamda=0)';
run;
ods rtf close;

/*lamda=0.25*/

data p214;
set p21 ;
VV=(VV**0.25-1)/0.25;
run;


proc sort data=p214;
by VV;
run;

proc univariate data=p214 noprint;
var VV;
output out=out_vv4 n=n median=m;
run;

data p214;
set p214;
if _n_=1 then set out_vv4;
run; 

data p214;
set p214;
i=_n_;
l=VV-m;
u=m-VV;
keep i l u n;
run;

data p214_u;
set p214;
if int(n/2)=n/2 then do ;
if i>n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i>(n+1)/2 then delete;
end;
keep u;
run;

data p214_l;
set p214;
if int(n/2)=n/2 then do ;
if i<=n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i<(n+1)/2 then delete;
end;
keep l;
run;

proc sort data=p214_u;
by u;
run;

proc sort data=p214_l;
by l;
run;

data p214_ul;
merge p214_u p214_l;
run;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2 "L") offset=(4);
axis2 label=(height=1.2 "U") offset=(4);

ods rtf file='1.rtf';
proc gplot data=p214_ul;
plot l*u/ haxis=axis2 vaxis=axis1 ;
title 'The Symmetry Plot of VV (lamda=0.25)';
run;
ods rtf close;

/*lamda=0.5*/

data p215;
set p21 ;
VV=(VV**0.5-1)/0.5;
run;


proc sort data=p215;
by VV;
run;

proc univariate data=p215 noprint;
var VV;
output out=out_vv5 n=n median=m;
run;

data p215;
set p215;
if _n_=1 then set out_vv5;
run; 

data p215;
set p215;
i=_n_;
l=VV-m;
u=m-VV;
keep i l u n;
run;

data p215_u;
set p215;
if int(n/2)=n/2 then do ;
if i>n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i>(n+1)/2 then delete;
end;
keep u;
run;

data p215_l;
set p215;
if int(n/2)=n/2 then do ;
if i<=n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i<(n+1)/2 then delete;
end;
keep l;
run;

proc sort data=p215_u;
by u;
run;

proc sort data=p215_l;
by l;
run;

data p215_ul;
merge p215_u p215_l;
run;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2 "L") offset=(4);
axis2 label=(height=1.2 "U") offset=(4);

ods rtf file='1.rtf';
proc gplot data=p215_ul;
plot l*u/ haxis=axis2 vaxis=axis1 ;
title 'The Symmetry Plot of VV (lamda=0.5)';
run;
ods rtf close;


/*NV*/
/*lamda=-0.25*/


data p222;
set p22 ;
NV=(NV**(-0.25)-1)/(-0.25);
run;


proc sort data=p222;
by NV;
run;

proc univariate data=p222 noprint;
var NV;
output out=out_nv1 n=n median=m;
run;

data p222;
set p222;
if _n_=1 then set out_nv1;
run; 

data p222;
set p222;
i=_n_;
l=NV-m;
u=m-NV;
keep i l u n;
run;

data p222_u;
set p222;
if int(n/2)=n/2 then do ;
if i>n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i>(n+1)/2 then delete;
end;
keep u;
run;

data p222_l;
set p222;
if int(n/2)=n/2 then do ;
if i<=n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i<(n+1)/2 then delete;
end;
keep l;
run;

proc sort data=p222_u;
by u;
run;

proc sort data=p222_l;
by l;
run;

data p222_ul;
merge p222_u p222_l;
run;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2 "L") offset=(4);
axis2 label=(height=1.2 "U") offset=(4);

ods rtf file='1.rtf';
proc gplot data=p222_ul;
plot l*u/ haxis=axis2 vaxis=axis1 ;
title 'The Symmetry Plot of NV (lamda=-0.25)';
run;
ods rtf close;

/*lamda=-0.5*/
data p223;
set p22 ;
NV=(NV**(-0.5)-1)/(-0.5);
run;


proc sort data=p223;
by NV;
run;

proc univariate data=p223 noprint;
var NV;
output out=out_nv2 n=n median=m;
run;

data p223;
set p223;
if _n_=1 then set out_nv2;
run; 

data p223;
set p223;
i=_n_;
l=NV-m;
u=m-NV;
keep i l u n;
run;

data p223_u;
set p223;
if int(n/2)=n/2 then do ;
if i>n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i>(n+1)/2 then delete;
end;
keep u;
run;

data p223_l;
set p223;
if int(n/2)=n/2 then do ;
if i<=n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i<(n+1)/2 then delete;
end;
keep l;
run;

proc sort data=p223_u;
by u;
run;

proc sort data=p223_l;
by l;
run;

data p223_ul;
merge p223_u p223_l;
run;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2 "L") offset=(4);
axis2 label=(height=1.2 "U") offset=(4);

ods rtf file='1.rtf';
proc gplot data=p223_ul;
plot l*u/ haxis=axis2 vaxis=axis1 ;
title 'The Symmetry Plot of NV (lamda=-0.5)';
run;
ods rtf close;

/*lamda=0*/
data p221;
set p22 ;
NV=log(NV);
run;


proc sort data=p221;
by NV;
run;

proc univariate data=p221 noprint;
var NV;
output out=out_nv3 n=n median=m;
run;

data p221;
set p221;
if _n_=1 then set out_nv3;
run; 

data p221;
set p221;
i=_n_;
l=NV-m;
u=m-NV;
keep i l u n;
run;

data p221_u;
set p221;
if int(n/2)=n/2 then do ;
if i>n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i>(n+1)/2 then delete;
end;
keep u;
run;

data p221_l;
set p221;
if int(n/2)=n/2 then do ;
if i<=n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i<(n+1)/2 then delete;
end;
keep l;
run;

proc sort data=p221_u;
by u;
run;

proc sort data=p221_l;
by l;
run;

data p221_ul;
merge p221_u p221_l;
run;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2 "L") offset=(4);
axis2 label=(height=1.2 "U") offset=(4);

ods rtf file='1.rtf';
proc gplot data=p221_ul;
plot l*u/ haxis=axis2 vaxis=axis1 ;
title 'The Symmetry Plot of NV (lamda=0)';
run;
ods rtf close;


/*lamda=0.25*/
data p224;
set p22 ;
NV=(NV**(0.25)-1)/(0.25);
run;


proc sort data=p224;
by NV;
run;

proc univariate data=p224 noprint;
var NV;
output out=out_nv4 n=n median=m;
run;

data p224;
set p224;
if _n_=1 then set out_nv4;
run; 

data p224;
set p224;
i=_n_;
l=NV-m;
u=m-NV;
keep i l u n;
run;

data p224_u;
set p224;
if int(n/2)=n/2 then do ;
if i>n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i>(n+1)/2 then delete;
end;
keep u;
run;

data p224_l;
set p224;
if int(n/2)=n/2 then do ;
if i<=n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i<(n+1)/2 then delete;
end;
keep l;
run;

proc sort data=p224_u;
by u;
run;

proc sort data=p224_l;
by l;
run;

data p224_ul;
merge p224_u p224_l;
run;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2 "L") offset=(4);
axis2 label=(height=1.2 "U") offset=(4);

ods rtf file='1.rtf';
proc gplot data=p224_ul;
plot l*u/ haxis=axis2 vaxis=axis1 ;
title 'The Symmetry Plot of NV (lamda=0.25)';
run;
ods rtf close;


/*lamda=0.5*/
data p225;
set p22 ;
NV=(NV**(0.5)-1)/(0.5);
run;


proc sort data=p225;
by NV;
run;

proc univariate data=p225 noprint;
var NV;
output out=out_nv5 n=n median=m;
run;

data p225;
set p225;
if _n_=1 then set out_nv5;
run; 

data p225;
set p225;
i=_n_;
l=NV-m;
u=m-NV;
keep i l u n;
run;

data p225_u;
set p225;
if int(n/2)=n/2 then do ;
if i>n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i>(n+1)/2 then delete;
end;
keep u;
run;

data p225_l;
set p225;
if int(n/2)=n/2 then do ;
if i<=n/2 then delete;
end;
if int(n/2)<n/2 then do ;
if i<(n+1)/2 then delete;
end;
keep l;
run;

proc sort data=p225_u;
by u;
run;

proc sort data=p225_l;
by l;
run;

data p225_ul;
merge p225_u p225_l;
run;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2 "L") offset=(4);
axis2 label=(height=1.2 "U") offset=(4);

ods rtf file='1.rtf';
proc gplot data=p225_ul;
plot l*u/ haxis=axis2 vaxis=axis1 ;
title 'The Symmetry Plot of NV (lamda=0.5)';
run;
ods rtf close;
