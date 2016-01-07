data p2a;
input incidents Argentina Turkey;
datalines;
0 46 60
1 15 9
2 5  4
3 3  2
4 5  0
5 1  1
6 1  0
;
run;
data p2a;
set p2a;
log_Ank=log(Argentina);
if Turkey>0 then log_Tnk=log(Turkey);
else log_Tnk=.;
log_kf=log(fact(incidents));
log_AnkN=log(Argentina*fact(incidents)/76);
log_TnkN=log(Turkey*fact(incidents)/76);
phiA=log_Ank+log_kf-log(76);
phiT=log_Tnk+log_kf-log(76);
run;

proc print data=p2a(keep=phiA phiT);
run;

symbol1  height=0.8 v=dot i=r;

ods rtf file='12.rtf';
proc gplot data=p2a;
plot phiA*incidents /overlay legend=legend
vaxis=axis2 haxis=axis1;
title "Poissonness Plot for Argentina";
run;
proc gplot data=p2a;
plot phiT*incidents /overlay legend=legend
vaxis=axis2 haxis=axis1;
title "Poissonness Plot for Turkey";
run;
ods rtf close;

data p2b;
set p2a;
drop phiA phiT log_kf log_AnkN log_TnkN;
run;
data p2b;
set p2b;
/*Argentina*/
/* r=0.5  */
ak1=gamma(incidents+.5)/(gamma(.5)*gamma(incidents+1));
/* r=0.8  */	
ak2=gamma(incidents+.8)/(gamma(.8)*gamma(incidents+1));
/* r=1  */
ak3=gamma(incidents+1)/(gamma(1)*gamma(incidents+1));
/* r=2  */
ak4=gamma(incidents+2)/(gamma(2)*gamma(incidents+1));
/* r=3 */
ak5=gamma(incidents+3)/(gamma(3)*gamma(incidents+1));



phiA1=log_Ank-log(ak1);
phiA2=log_Ank-log(ak2);
phiA3=log_Ank-log(ak3);
phiA4=log_Ank-log(ak4);
phiA5=log_Ank-log(ak5);

label phiA1="r=0.5";
label phiA2="r=0.8";
label phiA3="r=1";
label phiA4="r=2";
label phiA5="r=3";


/*Turkey*/
/* r=0.3  */
at1=gamma(incidents+0.3)/(gamma(0.3)*gamma(incidents+1));
/* r=0.6  */	
at2=gamma(incidents+0.6)/(gamma(0.6)*gamma(incidents+1));
/* r=1  */
at3=gamma(incidents+1)/(gamma(1)*gamma(incidents+1));
/* r=2 */
at4=gamma(incidents+2)/(gamma(2)*gamma(incidents+1));
/* r=3 */
at5=gamma(incidents+3)/(gamma(3)*gamma(incidents+1));

phiT1=log_Tnk-log(at1);
phiT2=log_Tnk-log(at2);
phiT3=log_Tnk-log(at3);
phiT4=log_Tnk-log(at4);
phiT5=log_Tnk-log(at5);

label phiT1="r=0.3";
label phiT2="r=0.6";
label phiT3="r=1";
label phiT4="r=2";
label phiT5="r=3";
output;
run;
legend across=5 frame;
axis1 label=("Number of Accidents");
axis2 label=(a=90 "CountMeters");

ods rtf file='1.rtf';
proc gplot data=p2b;
plot phiA1*incidents phiA2*incidents phiA3*incidents phiA4*incidents phiA5*incidents/overlay legend=legend
vaxis=axis2 haxis=axis1;
title "Negative-binomialness Plot for Argentina";
run;
proc gplot data=p2b;
plot phiT1*incidents phiT2*incidents phiT3*incidents phiT4*incidents phiT5*incidents/overlay legend=legend
vaxis=axis2 haxis=axis1;
title " Negative-binomialness Plot for Turkey";
run;
ods rtf close;
