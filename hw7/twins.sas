data twins;
input s1 s2;
datalines;
      78      71
      75      70
      68      66
      92      85
      55      60
      74      72
      65      57
      80      75
      98      92
      52      56
      67      63
      55      52
      49      48
      66      67
      75      70
      90      88
      89      80
      73      65
      61      60
      76      74
;
run;

data twins;
set twins;
s=s1;group=1;output;
s=s2;group=2;output;
run;
proc sort data=twins;
by group;
run;
proc format;
value group 1='s1'
            2='s2';
run; 

axis1 label=(a=90 "Value of S");

ods rtf file="1.rtf";

proc boxplot data=twins;
plot s*group/notches;
format group group.;
title "Notched Boxplot for S1 and S2";
run;
ods rtf file="1.rtf";
proc univariate data=twins;
var s;
class group;
histogram /  normal nrow=1 ncols=2 intertile=2 cfill=vlipb vscale=count
midpoints = 47 to 97 by 5;
inset mean='Mean:'(6.2) STD='SD:'(6.2)/ noframe position=ne height=3  ;
format group group.;
run;
ods rtf close;
data t1(keep=s1) t2(keep=s2);
set twins;
run;

proc sort data=t1;
by s1;
run;

proc sort data=t2;
by s2;
run;

data t3;
merge t1 t2; 
run;

data t4;
set twins;
d=s1-s2;
run;

axis1 label=('S1') offset=(4);
axis2 label=('S2') offset=(4);

goptions cback=white ftext=centb htext=0 htitle=1;

symbol1 v=dot height=0.6 color=black;
symbol2 i=j l=1  height=0.6 color=blue;

axis1 label=(height=1.2 angle=90 "S1")
      offset=(4);

axis2 label=(height=1.2 "S2")
      offset=(4);

proc gplot data=t3;
plot s1*s2 /overlay haxis=axis2 vaxis=axis1;
title 'Empirical Q-Q plot for S1 & S2';
run;

Proc univariate data=t1 noprint;
  qqplot s1 / Normal(MU=est SIGMA=EST L=1) SQUARE; 
  inset mean='Mean:' (6.1) STD='SD:' (6.1) / noframe position=ne
                                 height=2 font=swissxb;
run;

Proc univariate data=t2 noprint;
  qqplot s2 / Normal(MU=est SIGMA=EST L=1) SQUARE; 
  inset mean='Mean:' (6.1) STD='SD:' (6.1) / noframe position=ne
                                 height=2 font=swissxb;
run;
ods rtf file="2.rtf";
proc univariate data=t4;
var d;
histogram /normal 
midpoints = -4 to 10 by 2;
inset mean='Mean:'(6.2) STD='SD:'(6.2)/ noframe position=ne height=3  ;
title 'distribution of difference';
run;

Proc univariate data=t4 noprint;
  qqplot d / Normal(MU=est SIGMA=EST L=1) SQUARE; 
  inset mean='Mean:' (6.1) STD='SD:' (6.1) / noframe position=ne
                                 height=2 font=swissxb;
run;
ods rtf close;
proc univariate data=twins;
var s1;
histogram/ normal;
run;

proc univariate data=twins;
var s2;
histogram/ normal;
run;

proc univariate data=t4;
var d;
histogram/ normal;
run;

proc ttest data=twins;
paired s1*s2;
run;


ods rtf close;
