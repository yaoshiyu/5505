data life;
 input Y @@;
datalines;
   16.3399 18.3452 10.2016  9.2594 15.9763 13.8556 27.9082 18.8382
    7.3506 16.0676 20.2934 21.4380 17.6096 12.3697 15.8564 11.6764
   11.5214 21.6060 24.1470 13.3556 17.6096 18.8382 18.8382 19.4670
   22.9727 20.0237 17.1630  7.2179 14.7692 11.7675
;
run;
 
proc sort data=life;
by y;
run;

data life;
	set life;
	if _N_=1 then set out;
	i=_N_;
	q=y;
	p=(i-0.5)/n;
run;

goptions cback=white ftext=centb htext=0 htitle=1;
symbol1 v=dot height=0.8;
ods rtf file="1.rtf";


proc univariate data=life noprint;
qqplot y/exponential(THETA=EST SIGMA=EST) SQUARE;
inset mean='Mean:' (6.1) STD='SD:' (6.1) / noframe position=ne
                                 height=2 font=swissxb;
run;

Proc univariate data=life noprint;
qqplot y / Lognormal(SIGMA=EST theta=ESt zeta=est) SQUARE; 
inset mean='Mean:' (6.1) STD='SD:' (6.1) / noframe position=ne
                                 height=2 font=swissxb;
run;

Proc univariate data=life noprint;
  qqplot y / Normal(MU=est SIGMA=EST L=1) SQUARE; 
  inset mean='Mean:' (6.1) STD='SD:' (6.1) / noframe position=ne
                                 height=2 font=swissxb;
run;

ods rtf close;
