data p29;
input date mmddyy8. eq $ vote;
datalines;
7/21/13 eq1 8
4/8/12  eq1 10
2/4/97  eq1 19
5/7/96  eq1 12
10/6/95 eq1 9
10/3/95 eq1 19
9/27/95 eq1 12
4/30/92 eq1 8
7/21/13 eq2 54
4/8/12  eq2 44
2/4/97  eq2 61
5/7/96  eq2 41
10/6/95 eq2 52
10/3/95 eq2 52
9/27/95 eq2 54
4/30/92 eq2 46
;
run;
proc print data=p29;
run;

axis1 label=(a=90 'Votes');
axis2 label=none value=none;

pattern1 color=purple;
pattern2 color=VLIB;
ods rtf file="b.rtf";
proc gchart data=p29;
vbar  eq/group=date subgroup=eq sumvar=vote 
raxis=axis1 maxis=axis2   nozero
outside=sum width=5 ;
title 'OPINION OF EQUAL TREATMENT';
format date date9.;
run;
ods rtf close;
data p30;
input attitude percent;
datalines;
1   26 
2   40  
3   32 
4   2  
;
run;

proc format;
value att
 1='Justified'
 2='Unjustified'
 3="Don't know enough to say"
 4='No opinion';
 run;
pattern1 color=VLIB;
pattern2 color=CYAN;
pattern3 color=VLIPB;
pattern4 color=PURPLE;

ODS RTF FILE="A.rtf";

proc gchart data=p30;
pie attitude/ sumvar=percent discrete   percent=arrow noheading explode=1;
format attitude att.;
title "The attitude of shooting";
run;

ODS RTF CLOSE;
