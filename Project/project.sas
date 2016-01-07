data bos;
set bos;
team=1;
run;

data dal;
set dal;
team=2;
run;

data hou;
set hou;
team=3;
run;

data lal;
set lal;
team=4;
run;

data mia;
set mia;
team=5;
run;

data sas;
set sas;
team=6;
run;

data team;
set bos dal hou lal mia sas;
run;

proc format;
value team 1='Celtics'
           2='Mavericks'
		    3='Rockets'
			4='Lakers'
			5='Heat'
			6='Spurs';
run; 

ods rtf file='box.rtf';
proc boxplot data=team;
plot srs*team/   notches
                  boxstyle=schematic 
                  boxwidth=10.0 
                  idsymbol=dot 
                  cboxes=black
                  cboxfill=ywh ;
format team team.;
run;

ods rtf close;

data sw;
input team g$  num;
datalines ;
1  s -0.13764
2  s -0.05328
3  s  0.819207
4  s  0.330791
5  s  1.56071
6  s  1.480788
1  w  0.002623
2  w  0.002623
3  w  0.317329
4  w  0.317329
5  w  1.969539
6  w  1.340126

;
run;

axis1 label=(a=90 'number');
axis2 label=none value=none;
pattern1 color=purple;
pattern2 color=VLIB;

ods rtf file="bar.rtf";
proc gchart data=sw;
vbar g /group=team subgroup=g sumvar=num 
raxis=axis1 maxis=axis2   nozero
outside=sum width=5 ;
title 'Bar Chart of SRS and Winning Game';
format team team.;
run;
ods rtf close;

ods ods rtf file="dd.rtf";
proc boxplot data=team;
plot drtg*team/   notches
                  boxstyle=schematic 
                  boxwidth=10.0 
                  idsymbol=dot 
                  cboxes=black
                  cboxfill=ywh ;
title 'Boxplot of Defensive Rating';
format team team.;
run;


proc boxplot data=team;
plot ddrb*team/   notches
                  boxstyle=schematic 
                  boxwidth=10.0 
                  idsymbol=dot 
                  cboxes=black
                  cboxfill=ywh ;
title 'Boxplot of Difference in Defensive Rebound';
format team team.;
run;

proc boxplot data=team;
plot sb*team/   notches
                  boxstyle=schematic 
                  boxwidth=10.0 
                  idsymbol=dot 
                  cboxes=black
                  cboxfill=ywh ;
title 'Boxplot of the Sum of Steal and Block';
format team team.;
run;
ods rtf close;


data dsd;
input team g$  num;
datalines ;
1  di -0.42581
2  di -0.4988
3  di 0.687373
4  di 1.101013
5  di 0.736037
6  di 0.875944
1  sb -0.24746
2  sb 0.371185
3  sb -0.19443
4  sb -0.48608
5  sb 0.804235
6  sb 0.75857
1  dr 0.86651
2  dr -0.199964
3  dr -0.066655
4  dr -0.233291
5  dr 0.7332
6  dr 1.43308
;
run;

proc gchart data=dsd;
vbar g /group=team subgroup=g sumvar=num 
raxis=axis1 maxis=axis2   nozero
outside=sum width=5 ;
title 'Bar Chart of Difference in Defensive Rebounds, steals+blocks and Defensive Rating';
format team team.;
run;

data fao;
input team g$  num;
datalines ;
1  fg 0.716546
2  fg 0.53741
3  fg 0.477697
4  fg 0.298561
5  fg 2.567624
6  fg 1.671941
1  as 0.243782
2  as 0.773376
3  as 0.739751
4  as 0.033626
5  as 0.638876
6  as 2.051127
1  or -0.83021
2  or 0.000001
3  or 1.126708
4  or 0.563354
5  or 1.897614
6  or 0.711605
;
run;


ods rtf file="fao.rtf";
proc gchart data=fao;
vbar g /group=team subgroup=g sumvar=num 
raxis=axis1 maxis=axis2   nozero
outside=sum width=5 ;
title 'Bar Chart of Field Goal Percentage, Assists and Offensive Rating';
format team team.;
run;
ods rtf close;

ods rtf file="box2.rtf";
proc boxplot data=team;
plot fg*team/   notches
                  boxstyle=schematic 
                  boxwidth=10.0 
                  idsymbol=dot 
                  cboxes=black
                  cboxfill=ywh ;
title 'Boxplot of Field Goal Percentage';
format team team.;
run;


proc boxplot data=team;
plot astg*team/   notches
                  boxstyle=schematic 
                  boxwidth=10.0 
                  idsymbol=dot 
                  cboxes=black
                  cboxfill=ywh ;
title 'Boxplot of Assists';
format team team.;
run;

proc boxplot data=team;
plot ortg*team/   notches
                  boxstyle=schematic 
                  boxwidth=10.0 
                  idsymbol=dot 
                  cboxes=black
                  cboxfill=ywh ;
title 'Boxplot of Offensive Rating';
format team team.;
run;
ods rtf close;


data sb;
set bos sas;
run;

ods rtf file="box3.rtf";
proc boxplot data=sb;
plot wg*team/     notches
                  boxstyle=schematic 
                  boxwidth=10.0 
                  idsymbol=dot 
                  cboxes=black
                  cboxfill=ywh ;
format team team.;
run;
ods rtf close;
