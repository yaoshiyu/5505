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
     9.2      .
    11.9      .
;
run;


goptions cback=white ftext=centb htext=0 htitle=1;

symbol1 v=dot height=0.8;

proc univariate data=bonus;
  qqplot Male / Normal(MU=est SIGMA=EST L=1) SQUARE; 
  inset mean='Mean:' (6.1) STD='SD:' (6.1) / noframe position=ne
                                 height=2 font=swissxb;
run;


proc capability data=bonus;
  qqplot Male / Normal(MU=est SIGMA=EST L=1); 
run;



*generate U(1,4) data for illustration;
data genunif;
  do i=1 to 100;
  U=ranuni(2);
  U= 3*U+1;
  label U="Empirical Quantiles"; 
  output;
  end;
run;

ods rtf  file="C:\Users\eds12005\Documents\STAT5505-Fa2013\SAS\uniform.rtf";

goptions reset=all;
goptions cback=white ftext=centb htext=0 htitle=1;

symbol1 v=dot height=0.8;
proc univariate data=genunif;
  qqplot U / Beta(alpha=1 beta=1) SQUARE; 
run;


proc capability data=genunif;
  qqplot U / BETA(alpha=1 beta=1); 
run;


ods rtf close;
