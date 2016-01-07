data p1;
input h1 h2;
datalines;
65.8	73.8	
64.4	71.5	
65.6	73.4	
67.0	75.8	
66.1	74.3	
66.1	74.2	
65.9	74.0	
65.3	72.9	
65.0	72.4	
66.2	74.5	
65.1	72.7	
66.2	74.4	
62.9	69.0	
65.6	73.5	
66.2	74.5	
65.2	72.8	
64.8	72.2	
63.4	69.7	
64.2	71.2	
65.1	72.6	
64.2	71.1	
 .      74.3	
 .      68.3	
 .      71.4	
 .      73.9	
 .      72.8	
 .      78.0	
 .      71.0	
 .      72.6	
 .      72.1	
 .      72.5	
 .      73.2	
 .      70.8	
 .      70.7	
 .      72.2	
 .      72.5	
 .      71.0	
 .      73.7	
 .      69.3
 ;


data p11(keep=h1) p12(keep=h2);
set p1;
run;

data p1;
set p1;
h=h1;group=1;output;
h=h2;group=2;output;
run;

data p1;
set p1;
if h=. then delete;
run;

proc sort data=p1;
by group;
run;

proc format;
value group 1='Height1'
            2='Height2';
run; 


goption cback=white ftext=centb htext=0 htitle=1;
axis1 label=(a=90 "Value of H")
      order=(60 to 80 by 2)
      offset=(4);

ods rtf file='p1.rtf';
proc boxplot data=p1;
plot h*group/totpanels=1
             boxstyle=schematic
             notches
			 vaxis=axis1;
format group group.;
title "Notched Boxplot for Height1 and Height2";
run;
ods rtf close;


data p11;
set p11;
if h1=. then delete;
run;

proc sort data=p11;
by h1;
run;

proc sort data=p12;
by h2;
run;

proc means data=p11 noprint;
 var h1;
output out=out1 n=n1 mean=mean1 std=std1;
run;

proc means data=p12 noprint;
 var h2;
output out=out2 n=n2 mean=mean2 std=std2;
run;

proc transpose data=p11 out=p11T prefix=x;
 var h1;
run;

proc transpose data=p12 out=p12T prefix=y;
 var h2;
run;

data comb;
 merge p11T p12T out1 out2;
run;

data comb;
 set comb;
 array x{21} x1-x21; 
 array y{39} y1-y39; 
 if n1 <= n2 then do;
  do i=1 to n1;
   yq=x{i};
   p=(i-0.5)/n1;
   v=n2*p+0.5;
   j=FLOOR(v);
   theta=v-j;
   if j < n2 then 
    xq=(1-theta)*y{j}+theta*y{j+1}; 
   if j=n2 then xq=y{j};
   output;
  end;
 end;
 else do;
  do i=1 to n2;
   xq=y{i};
   p=(i-0.5)/n2;
   v=n1*p+0.5;
   j=FLOOR(v);
   theta=v-j;
   if j < n1 then
    yq=(1-theta)*x{j}+theta*x{j+1};
   if j=n1 then yq=x{j};
   output;
  end;
 end;
 keep yq xq p;
run;

goptions cback=white ftext=centb htext=0 htitle=1;

symbol1 v=dot height=0.6 color=black;
symbol2 i=j l=1  height=0.6 color=blue;

axis1 label=(height=1.2 angle=90 "Height1")
      offset=(4);

axis2 label=(height=1.2 "Height2")
      offset=(4);


ods rtf file='p1.rtf';
proc gplot data=comb;
 plot yq*xq yq*yq/overlay
               vaxis=axis1
               haxis=axis2;
title "Empirical Q-Q Plot for Height1 and Height2";
run;
ods rtf close;


data p13(drop=h1 h2 group);
set p1;
run;

data p13;
set p13;
if h=. then delete;
run;
ods rtf file='p1.rtf';
proc univariate data=p13 noprint;
histogram h /cfill=cyan
             midpoints = 62.5 to 78.5 by 1;
run;

/*mean1=65.252380952 std1=1.009266589 mean2=72.584615385 std2=1.8966089492*/ 

data mixn;
 do i=1 to 1000;
  U=ranuni(2);
  Z=Normal(2);
  if U <=21/60 then Y=65.25+1.01*Z;
  else Y=72.58+1.90*Z;
  output;
 end;
run;


goptions cback=white ftext=centb htext=0 htitle=1
         ctext=black;

proc univariate data=mixn noprint;
 histogram y/cfill=cyan
             midpoints=62.5 to 78.5 by 1;
run;
ods rtf close;

proc univariate data=p13;
var h;
run;

proc univariate data=mixn;
var y;
run;
