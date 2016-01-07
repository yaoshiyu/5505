data hw2;
set pulse;
run;

proc print data=height;
run;

data height;
set hw2;
y=HEIGHT; group='People'; output;
drop y;
run;

proc boxplot data=height;
plot HEIGHT*group/boxstyle=schematic 
                  boxwidth=10.0 
                  idsymbol=dot 
                  cboxes=black
                  cboxfill=ywh ;
run;

data weight;
set hw2;
y=wEIGHT; group='People'; output;
drop y;
run;

proc boxplot data=weight;
plot wEIGHT*group/boxstyle=schematic 
                  boxwidth=10.0 
                  idsymbol=dot 
                  cboxes=black
                  cboxfill=ywh ;
run;

data height2;
set hw2;
do height=height*2.54;
end;
x=HEIGHT; group="People";
output;
drop x;
run;

proc print data=height2;
run;

proc boxplot data=height2;
plot HEIGHT*group/boxstyle=schematic boxwidth=10.0 idsymbol=dot cboxes=black
 cboxfill=ywh ;
run;

proc univariate data=hw2;
var weight;
output out=out mean=Mean var=Var range=Range max=Max std=Std median=Median min=Min Q3=Q3 Q1=Q1;
run;


data out;
set out;
IQR=Q3-Q1;
Upper=Q3+1.5*IQR;
Lower=Q1-1.5*IQR;
run;

proc print data=out noobs;
run;

proc print data=out noobs label;
label Upper="Upper adjacent value"
Lower="Lower adjacent value";
run;

ods rtf file="his.rtf";
proc univariate data=hw2;
var weight; 
histogram weight / normal;
run;
ods rtf close;

data q;
set pulse;
keep weight
run;

proc sort data=q;
by weight;
run;

proc print data=q;
run;

proc transpose data=q out=qq prefix=w;
run;

data a;
set qq;
array w[92] w1-w92;
array p[10] p1-p10 (0.01 0.05 0.1 0.25 0.4 0.5 0.6 0.75 0.9 0.99);
array np[10] np1-np10;
array q[10] q1-q10;
do i=1 to 10;
np[i]=int(92*p[i]);
end;
do j=1 to 10;
if np[j]<92*p[j] then q[j]=w[np[j]+1];
else if np[j]=92*p[j] then q[j]=0.5*(w[np[j]+1]+w[np[j]]);
end;
keep q1-q10;
run;
proc print data=a;
run;

proc univariate data=q;
output out=out1 pclpre=p pctlpts=(1 5 10 25 40 50 60 75 90 99);
run;

proc print data=out1;
run; 


data compare;
set pulse;
run;

data compare;
set compare;
y=pulse1; g='pulse1'; output;
y=pulse2; g='pulse2'; output;
run;

proc sort data=compare;
by g;
run;

axis1 label=('Pulse');

ods rtf file="p1p2.rtf";
 
proc boxplot data=compare;
plot y*g/vaxis=axis1 boxstyle=schematic
boxwidth=10.0 idsymbol=star cboxes=dagr cboxfill=ywh;
title 'Comparison Between Pulse1 and Pulse2';
run;


proc boxplot data=compare;
plot y*g/vaxis=axis1 
         boxstyle=schematic
         notches
         boxwidth=5.0 
         idsymbol=star 
         cboxes=dagr 
         cboxfill=ywh;
title 'Comparison Between Pulse1 and Pulse2';
run;
ods rtf close;
