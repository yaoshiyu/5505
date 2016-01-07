

options noovp nosource nosource2 nostimer nonotes cleanup;

/* The above options get rid of all printouts in SAS Log window */

%macro simudata;

%do repeat=1 %to 99; /* # of simulations */

%do j=1 %to 15;  /* # of different K's */

data simu;
 if &j=1 then K=1;
 if &j > 1 then K=&j; /* set the actual values of K here */
 do i=1 to 1000; /* sample size n=1000 */
  sum=0;
  do kk=1 to K;
   seed=&repeat*10;
   u=ranuni(seed);
   sum=sum+u;
  end;
  ubar=sum/K;
  ustar=(ubar-0.5)/(1/(12*K))**0.5;
  output;
 end;
 keep K ubar ustar;
run;

proc sort data=simu;
 by ustar;
run;

data simu1;
 set simu;
 ID=_n_;
 ID5=floor(ID/5);
 if ID=ID5*5 and ID < 1000; /* choose every fifth quantiles */
run;

data simu1;
 set simu1;
 zscore=probit((ID-0.5)/1000); /* calculate normal(0,1) quantiles */
 Diff=abs(ustar-zscore);
run;

%if &j=1 %then %do;
 data comb;
   set simu;
 run;	
%end;
%else %do;
  data comb;
   set comb simu;
 run;
%end;


%if &j=1 %then %do;
 data comb1;
   set simu1;
 run;	
%end;
%else %do;
  data comb1;
   set comb1 simu1;
 run;
%end;

%end;

proc univariate data=comb1 noprint;
 var Diff;
output out=out mean=DK;
 by K;
run;

data out;
 set out;
 simu=&repeat;
run;

%if &repeat=1 %then %do;
 data final;
  set out;
  run;
%end;
%else %do;
 data final;
  set final out;
  run;
%end;

proc univariate data=comb noprint normaltest outtable=out;
 var ustar;
 by K;
run;

data out;
 set out;
 simu=&repeat;
 pvalue=_PROBN_;
 keep simu K pvalue;
run;

%if &repeat=1 %then %do;
 data finalnormaltest;
  set out;
  run;
%end;
%else %do;
 data finalnormaltest;
  set finalnormaltest out;
  run;
%end;

%end;

%mend simudata;

%simudata;


options ovp source source2 stimer notes;

proc sort data=final;
 by K DK;
run;

data final;
set final;
if k=4 then delete;
if k=5 then delete;
if k=7 then delete;
if k=8 then delete;
if k=10 then delete;
if k=11 then delete;
if k=13 then delete;
if k=14 then delete;
run;


ods rtf file='Uniformplot.rtf';


proc boxplot data=final;
title 'Boxplot of D_K';
 plot DK*K  /totpanels=1
             boxstyle=schematic
                   notches
                   boxwidthscale=1
                   idsymbol=dot
                   cboxes=black;
run;


proc univariate data=final;
class k;
var DK;
run;


proc sort data=finalnormaltest;
 by K pvalue;
run;


data finalnormaltest;
set finalnormaltest;
if k=4 then delete;
if k=5 then delete;
if k=7 then delete;
if k=8 then delete;
if k=10 then delete;
if k=11 then delete;
if k=13 then delete;
if k=14 then delete;
run;

proc boxplot data=finalnormaltest;
 title 'Boxplot of Normality Test p-values'; 
 plot pvalue*K  /totpanels=1
                  vref=0.05
				  vreflabel='0.05'
                  vreflabpos=1
                  boxstyle=schematic
                   notches
                   boxwidthscale=1
                   idsymbol=dot
                   cboxes=black;
run;

proc univariate data=finalnormaltest;
class k;
var pvalue;
run;
ods rtf close;
