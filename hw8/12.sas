/* or use CI approach */
%macro mctestci(data = _last_, y=, B=,n=);
/* 
    B = number of bootstrap samples
    n = number of samples
*/

data current;
set &data;
run;

proc iml;
/* use work.current; */
 use work.current; 
 read all var {&y} into y;
/* initialize variables */
/* Y=j(&n,1,0); */
 ystar=j(&n,1,0);
 ts=j(&B,1,0);
 names ={stats};
 
 do imac=1 to &B;			/* boot loop */
   sy=0;
   do i=1 to &n;			/* generate boot sample */
    rand=round(&n*ranuni(9));
    if rand < 1 then rand=1;
    ystar[i]=y[rand];
    sy=sy+ystar[i];
   end;
   ts[imac] = sy/&n;
end;

  create mctestdata var{stats};
   append from ts;
quit;

proc univariate data = mctestdata;
 var stats;
output out=out pctlpre=P_ pctlpts=2.5 97.5 n=B;

proc print data=out;
run;

%mend mctestci;

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

data t5(keep=d);
set t4;
run;

%mctestci(data=t5, y=d, B=1000,n=10);


