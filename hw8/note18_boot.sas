
goptions cback=white ftext=centb htext=0 htitle=1
         ctext=black;

%macro boot(n1,n2,B,lambda1,lambda2);

/* 
  lambda1, lambda2 = the exponential parameters for 2 distributions
  n1, n2 = sample size for two samples
  B = number of bootstrap samples
*/

proc iml;
 /* initialize variables */
 Y1=j(&n1,1,0);
 Y2=j(&n2,1,0);
 est=j(&B,2,0);
 names ={mdiff vratio}; /*column names of matrix est*/
 Ystar1=j(&n1,1,0);
 Ystar2=j(&n2,1,0);

 do i=1 to &n1;			/* generate initial sample from Exp(lam1) */
  u=ranuni(2);
  Y1[i]=-log(u)/&lambda1;
 end;

 do i=1 to &n2;			/* generate initial sample from Exp(lam2) */
  u=ranuni(2);
  Y2[i]=-log(u)/&lambda2;
 end;

 do imac=1 to &B;		/* Bootstrap loop */
   sy1=0;
   s2y1=0;
   do i=1 to &n1;		/* create Bootstrap sample for Y1 */
    rand=round(&n1*ranuni(2));
    if rand < 1 then rand=1;
    Ystar1[i]=Y1[rand];
    sy1=sy1+Ystar1[i];
    s2y1=s2y1+Ystar1[i]**2;
   end;
   y1bar=sy1/&n1;		/* get sample mean and var for boot sample */
   S2y1=(s2y1-&n1*y1bar**2)/(&n1-1);

   sy2=0;
   s2y2=0;
   do i=1 to &n2;	   /* create Bootstrap sample for Y2 */	
    rand=round(&n2*ranuni(2));
    if rand < 1 then rand=1;
    Ystar2[i]=Y2[rand];
    sy2=sy2+Ystar2[i];
    s2y2=s2y2+Ystar2[i]**2;
   end;
   y2bar=sy2/&n2;     /* get sample mean and var for boot sample */
   S2y2=(s2y2-&n2*y2bar**2)/(&n2-1);
  
   est[imac,1]=y1bar-y2bar; /* difference of two means */
   est[imac,2]=s2y1/s2y2;   /* ratio of two variances */
  end;

  create bootdata var{mdiff vratio};
   append from est;
quit;

proc print data=bootdata;
run;

proc univariate data=bootdata;
 title height=1.2 
  "Distribution of Difference of Two Sample Means from Exp(&lambda1) and Exp(&lambda2)";
 histogram mdiff/cfill=cyan;
run;

proc univariate data=bootdata;
 title height=1.2
  "Distribution of Ratio of Two Sample Variances from Exp(&lambda1) and Exp(&lambda2)";
 histogram vratio/cfill=cyan;
run;


%mend boot;

%boot(120,100,500,1,2);






%macro mctest(data = _last_, y=, B=,n=,mu0=);
/* 
    B = number of bootstrap samples
    n = number of samples
	mu0= hypothesized value under null
*/

data current;
set &data;
run;

proc iml;
/* use work.current; */
 use user.current; 
 read all var {&y} into y;
/* initialize variables */
/* Y=j(&n,1,0); */
 ystar=j(&n,1,0);
 ts=j(&B,2,0);
 names ={stats,indicator};
 
 /* calc tstar and rescale data */
 ysum=0;
 do i=1 to &n;
   ysum=ysum+y[i];
 end;
 ybar = ysum/&n;
 tstar = abs(ybar - &mu0); 
 ynull = y + tstar;

 do imac=1 to &B;			/* boot loop */
   sy=0;
   do i=1 to &n;			/* generate boot sample */
    rand=round(&n*ranuni(9));
    if rand < 1 then rand=1;
    ystar[i]=ynull[rand];
    sy=sy+ystar[i];
   end;
   yb = sy/&n;
   ts[imac,1] = abs(yb - &mu0);
   if ts[imac,1]>tstar then ts[imac,2] = 1; 
   							/* count how may times stat is > tstar */
end;

  create mctestdata var{stats,indicator};
   append from ts;
quit;

proc print data=mctestdata;
run;

proc univariate data = mctestdata;
 var indicator;
output out=out sum=sum n=B;

data out;
 set out;
 ps = (sum + 1)/(B+1);
run;

proc print data=out;
run;

%mend mctest;


data sample;
 input y @@;
 datalines;
 -0.89 -0.47 0.05 0.155 0.279
  0.775 1.0016 1.23 1.89 1.96
;
run;

%mctest(data=sample, y=y, B=100,n=10,mu0=1);





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
 use user.current; 
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


data sample;
 input y @@;
 datalines;
 -0.89 -0.47 0.05 0.155 0.279
  0.775 1.0016 1.23 1.89 1.96
;
run;

%mctestci(data=sample, y=y, B=1000,n=10);

