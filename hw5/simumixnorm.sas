
* 0.6N(0,1)+0.4N(6,4);
data mixn;
 do i=1 to 1000;
  U=ranuni(2);
  Z=Normal(2);
  if U <=0.6 then Y=Z;
  else Y=6+2*Z;
  output;
 end;
run;


goptions cback=white ftext=centb htext=0 htitle=1
         ctext=black;

proc univariate data=mixn noprint;
 histogram y/cfill=cyan;
run;
