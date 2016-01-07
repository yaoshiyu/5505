data h;
input h @@;
datalines;
80	77	73	82	78	80	80	74	81	72	76	78	80	71	73
77	78	78	80	82	82	73	82	80	78	83	82	83	79	84
74	82	81	83	80	77	84	83	80	75	77	79	78	79	83
77	84	77	80	82	76	80	78	78	81	80	84	78	75	80
76	76	75	72	76	83	75	80	76	82	84	83	75	84	84
83	82	77	81	84	82	79	81	79	76	85	76	79	76	
81	80	78	77	81	80	83	78	81	85	81	75	72	75	
81	79	82	83	79	80	81	82	71	78	82	84	74	78	
77	77	75	81	83	76	83	85	84	80	82	81	83	73	
84	77	78	79	81	82	75	75	74	79	72	78	84	82	
71	80	79	80	75	76	81	84	81	83	77	83	73	77	
81	78	81	81	76	79	78	77	85	71	80	74	79	85	
79	83	80	81	79	75	81	81	82	78	77	78	72	84	
79	80	86	75	76	79	80	73	69	75	84	80	81	82	
72	83	74	74	83	80	78	73	72	81	75	75	79	80	
75	80	79	82	84	73	83	79	81	79	84	77	77	78	
83	81	77	82	74	80	76	84	80	79	74	84	83	81	
79	79	83	83	83	74	79	81	83	72	79	81	81	81	
79	84	81	75	82	74	77	81	80	78	78	81	75	81	
81	78	75	79	76	79	81	73	82	79	85	79	84	81	
84	82	77	74	77	81	80	79	79	76	81	69	81	82	
81	81	74	80	82	75	80	82	80	82	75	83	82	80	
81	75	81	84	81	77	82	75	78	84	83	76	79	82	
72	80	75	82	80	82	76	83	83	80	82	78	75	78	
82	74	72	76	81	79	79	77	74	83	79	80	78	75	
78	75	77	78	82	82	76	82	76	84	75	81	79	75	
78	83	80	78	73	73	72	79	78	72	78	82	83	80	
83	80	82	74	74	75	81	77	82	76	74	77	76	77	
81	84	82	75	80	80	82	87	80	73	84	82	75	81	
78	85	73	79	80	79	77	75	83	77	80	77	82	76	
;
run;


data height;
set h;
y=h; group='Player'; output;
drop y
;
run;

ods rtf file="height.rtf";
proc boxplot data=height;
plot h*group/     notches
                  boxstyle=schematic 
                  boxwidth=10.0 
                  idsymbol=dot 
                  cboxes=black
                  cboxfill=ywh ;
title "Notched Boxplot for Height";
run;

proc univariate data=h;
var h;
histogram /  normal nrow=1 ncols=2 intertile=2 cfill=vlipb vscale=count;
inset mean='Mean:'(6.2) STD='SD:'(6.2)/ noframe position=ne height=3  ;
run;

Proc univariate data=h noprint;
  qqplot h / Normal(MU=est SIGMA=EST L=1) SQUARE; 
  inset mean='Mean:' (6.2) STD='SD:' (6.2) / noframe position=ne
  height=2 font=swissxb;
run;

ods select BasicIntervals TestsForLocation LocationCounts TestsForNormality;

proc univariate data=h cibasic(alpha=0.05) mu0=79 loccount normal;
   var h;
run;
ods rtf close;

data new;
input h1 @@;
datalines;
84 77.25 77.25 79 73.25 79.5 72 81 77.75 79 79.5 78.25 75 82.25 83.5 82.75 79 78.25 77.25 86 77.25 75 78.25 79 79.5
84 70.5 82.5 74.75 82 83.75 71.5 78 80.75 80 73.75 75.25 76.75 80.75 78.25 81.5 83.5 83.75 76.25 84 76 82.5 84.5 80.5
71.5 77.75 79 74 73 79.25 80 77.75 79 84.5 76.75 75.5 84.25
;
run;

ods rtf file="new.rtf";
proc univariate data=new;
var h1;
histogram /  normal nrow=1 ncols=2 intertile=2 cfill=vlipb vscale=count;
inset mean='Mean:'(6.2) STD='SD:'(6.2)/ noframe position=ne height=3  ;
run;

Proc univariate data=new noprint;
  qqplot h1 / Normal(MU=est SIGMA=EST L=1) SQUARE; 
  inset mean='Mean:' (6.2) STD='SD:' (6.2) / noframe position=ne
  height=2 font=swissxb;
run;

ods select BasicIntervals TestsForLocation LocationCounts TestsForNormality;

proc univariate data=new cibasic(alpha=0.05) mu0=79 loccount normal;
   var h1;
run;
ods rtf close;
