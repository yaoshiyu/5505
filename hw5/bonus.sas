data bonus;
 input Male  Female;
 label Male="Empirical Quantiles";
datalines;
    10.4     9.2
     9.7       8
     8.7     8.4
     9.3     7.7
     8.9     9.9
     9.1     6.7
     9.6     7.7
    10.4     9.6
    11.7    11.9
     8.8     6.2
     9.2
    11.9
;
run;

goptions cback=white ftext=centb htext=0 htitle=1;


symbol1 v=dot height=0.8;

Proc univariate data=bonus;
  qqplot Male / Normal(MU=est SIGMA=EST L=1) SQUARE; 
  inset mean='Mean:' (6.1) STD='SD:' (6.1) / noframe position=ne
                                 height=2 font=swissxb;
run;

/*
* vaxis and haxis are available only in proc capability (not in proc
  univariate);

axis1 label=(height=1.0 angle=90 "Empirical Quantiles")
      order=(8 to 12 by 1)
      offset=(2);

axis2 label=(height=1.0 "Normal Quantiles")
      order=(-2 to 2 by 1)
      offset=(2);



 Proc capability data=bonus;
  qqplot Male / Normal(MU=est SIGMA=EST L=1) vaxis=axis1 haxis=axis2; 
run;
*/
