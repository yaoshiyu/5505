data hw2;
set pulse;
run;

proc contents data=hw;
run;

proc print data=hw2;
run;

data hw2;
set hw2;
if pulse1<70 then type1=1;
if pulse1=70 then type1=2;
if pulse1>70 then type1=3;
if pulse2<70 then type2=1;
if pulse2=70 then type2=2;
if pulse2>70 then type2=3;
run;

proc print data=hw2;
run;

proc format;
value typea 1='pulse1<70'
           2='pulse1=70'
	       3='pulse1>70';
run;
proc format;
value typeb 1='pulse2<70'
	         2='pulse2=70'
	         3='pulse2>70';
run;
option nodate nonumber;

ods rtf file="abc.rtf";
proc freq data=hw2;
title 'the number of rates above 70 and below 70 for pulse1 and pulse2'; 
tables type1;
tables type2;
format type1 typea.;
format type2 typeb.;
run;

proc means data=hw2;
var pulse1 pulse2;
run;
ods rtf close;

data hw3;
set pulse;
if pulse1 <=60 then flag=1;
if pulse2 <=60 then flag1=2;
run;

proc print data=hw3;
run;
 
proc format;
value flag 
1="pulse1=<60"
2="pulse2=<60";
run;

proc freq data=hw3;
title 'the number of subjects which had a rate of 60 or lower in pulse1 and pulse2';
tables flag;
tables flag1;
format flag flag1 flag.;
run;

data hw4;
set pulse;
run;

proc sort data=hw4;
   by ran smokes sex activity;
run;

proc print data=hw4;
run;

proc univariate data=hw4 noprint;
   var pulse1;
output out=out mean=mean n=n;
by ran smokes sex activity;
run;

proc sort data=out;
by ran smokes sex activity;
run;

data group;
input g$ @@;
datalines;
g1111 g1112 g1113 g1122 g1211 g1212 g1213 g1222 g2112 g2113
g2121 g2122 g2123 g2211 g2212 g2213 g2221 g2222 g2223
;
run;
data result;
merge out group;
run;

proc print data=result;
run;
ods rtf file="a1.rtf";

pattern color=VLIPB;
axis1 label=(a=90 'Number of Pulse1');
axis2 label=(a=0 'Group');	

proc gchart data=result;
vbar g/discrete sumvar=n width=3 outside=sum raxis=axis1 maxis=axis2
description='There are only 19 combinations out 24 possible outcomes';
title 'Bar Chart of Number of Subjects Within Possible Combinations';
title2 'g(ijkm):i=ran j=smokes k=sex m=activity';
run;

pattern color=VPAPB;
axis1 label=(a=90 'Means of Pulse1');
axis2 label=(a=0 'Group');	


proc gchart data=result;
vbar g/discrete sumvar=mean width=5 outside=mean raxis=axis1 maxis=axis2 
description='There are only 19 combinations out 24 possible outcomes';
title  'Bar Chart of Means of Pulse1';
title2 'g(ijkm):i=ran j=smokes k=sex m=activity';
run;

ods rtf close;

data hw5;
set pulse;
run;

proc sort data=hw5;
   by ran smokes sex activity;
run;

proc print data=hw5;
run;

proc univariate data=hw5 noprint;
   var pulse2;
output out=out1 mean=mean1 n=n1;
by ran smokes sex activity;
run;

proc sort data=out1;
by ran smokes sex activity;
run;

data result1;
merge out1 group;
run;

proc print data=result1;
run;

ods rtf file="a123.rtf";

pattern color=VPAPB;
axis1 label=(a=90 'Means of Pulse2');
axis2 label=(a=0 'Group');	

proc gchart data=result1;
vbar g/discrete sumvar=mean1 width=5 outside=mean1 raxis=axis1 maxis=axis2 
description='There are only 19 combinations out 24 possible outcomes';
title  'Bar Chart of Means of Pulse2';
title2 'g(ijkm):i=ran j=smokes k=sex m=activity';
run;
ods rtf close;

