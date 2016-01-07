%inc 'P:\lifenew.sas';

ods rtf file='P:\hw5_2.rtf';

goptions reset=all;
goptions cback=white ftext=centb htext=0 htitle=1;

symbol1 v=dot height=0.8;


proc capability data=life;
  qqplot Y / exponential(sigma=16.4228 theta=0 L=1); 
run;

data loglife;
	set life;
	x=log(y);
run;

proc print data=loglife;
run;

proc capability data=loglife noprint;
	qqplot x / normal(MU=est SIGMA=EST L=1);
run;

proc sort data=life;
	by y;
run;

proc means data=life;
	var y;
output out=out n=n;
run;

data life;
	set life;
	if _N_=1 then set out;
	i=_N_;
	q=y;
	p=(i-0.5)/n;
run;

goptions reset=all;
goptions cback=white ftext=centb htext=0 htitle=1;

symbol1 v=dot height=0.6;

axis1 label=(height=1.2  "Quantiles")
      
      offset=(2);

axis2 label=(height=1.2 "Fraction of the Data")
      order=(0 to 1 by 0.1)
      offset=(4);

proc gplot data=life;
	plot q*p / vaxis=axis1
           		haxis=axis2;
run;

proc univariate data=life noprint;
	histogram y/cfill=cyan;
run;

proc capability data=life noprint;
	qqplot y / normal(MU=est SIGMA=EST L=1);
run;

ods rtf close;
quit;
