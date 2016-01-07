

%inc 'ozone.sas';

data ozone;
 set ozone;
 length month $10.;
 Stmf=Stmfmay; Ykrs=Ykrsmay; month='May'; group=1; output;
 Stmf=Stmfjune; Ykrs=Ykrsjune; month='June'; group=2; output;
 Stmf=Stmfjuly; Ykrs=Ykrsjuly; month='July'; group=3; output;
 Stmf=Stmfaugust; Ykrs=Ykrsaugust; month='August'; group=4; output;
 Stmf=Stmfsept; Ykrs=Ykrssept; month='September'; group=5; output;
run;

data ozone;
 set ozone;
 if month='September';
run;


data stmf;
 set ozone;
 if Stmf=. then delete;
 keep Stmf;
run;

proc sort data=stmf;
 by Stmf;
run;

data Ykrs;
 set ozone;
 if Ykrs=. then delete;
 keep Ykrs;
run;

proc sort data=Ykrs;
 by Ykrs;
run;

proc means data=stmf noprint;
 var stmf;
output out=outs n=ns;
run;

proc means data=Ykrs noprint;
 var Ykrs;
output out=outy n=ny;
run;

proc transpose data=stmf out=stmfT prefix=stmf;
 var stmf;
run;

proc transpose data=Ykrs out=YkrsT prefix=Ykrs;
 var Ykrs;
run;

data comb;
 merge stmfT YkrsT outs outy;
run;

data comb;
 set comb;
 array stmf{31} stmf1-stmf31; 
 array Ykrs{31} Ykrs1-Ykrs31; 
 if ns <= ny then do;
  do i=1 to ns;
   yq=Stmf{i};
   p=(i-0.5)/ns;
   v=ny*p+0.5;
   j=FLOOR(v);
   theta=v-j;
   if j < ny then 
    xq=(1-theta)*Ykrs{j}+theta*Ykrs{j+1}; 
   if j=ny then xq=Ykrs{j};
   output;
  end;
 end;
 else do;
  do i=1 to ny;
   xq=Ykrs{i};
   p=(i-0.5)/ny;
   v=ns*p+0.5;
   j=FLOOR(v);
   theta=v-j;
   if j < ns then
    yq=(1-theta)*stmf{j}+theta*stmf{j+1};
   if j=ns then yq=stmf{j};
   output;
  end;
 end;
 keep yq xq p;
run;


goptions cback=white ftext=centb htext=0 htitle=1;

symbol1 v=dot height=0.6 color=black;
symbol2 i=j l=1  height=0.6 color=blue;

axis1 label=(height=1.2 angle=90 "Stamford Ozone")
      offset=(2);

axis2 label=(height=1.2 "Yonkers Ozone")
      offset=(2);

proc gplot data=comb;
 plot yq*xq yq*yq/overlay
               vaxis=axis1
               haxis=axis2;
run;
