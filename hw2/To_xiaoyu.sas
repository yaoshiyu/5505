/* Problem (i) */
data sample;
input weight;
datalines;
140
145
160
190
155
165
150
190
195
138
160
155
153
145
170
175
175
170
180
135
170
157
130
185
140
120
130
138
121
125
116
145
150
112
125
190
155
170
155
215
150
145
155
155
150
155
150
180
160
135
160
130
155
150
148
155
150
140
180
190
145
150
164
140
142
136
123
155
130
120
130
131
120
118
125
135
125
118
122
115
102
115
150
110
116
108
95
125
133
110
150
108
;
run;
proc sort data=sample;
by weight;
run;

proc transpose data=sample out=sample_t prefix=w;
run;

data a;
set sample_t;
array w[92] w1-w92;
array p[10] p1-p10 (0.01 0.05 0.1 0.25 0.4 0.5 0.6 0.75 0.9 0.99);
array np[10] np1-np10;
array q[10] q1-q10;
do i=1 to 10;
np[i]=int(92*p[i]);
end;
do j=1 to 10;
if np[j]<92*p[j] then q[j]=w[np[j]+1];
else if np[j]=92*p[j] then q[j]=(w[np[j]+1]+w[np[j]])*0.5;
end;
q[4]=(w[23]+w[24])/2;
q[6]=(w[46]+w[47])/2;
q[8]=(w[69]+w[70])/2;
keep q1-q10;
run;

proc print data=a;
run;

/* Problem (ii) */
proc univariate data=sample;
var weight;
run;

q[4]=(w[23]+w[24])/2;
q[6]=(w[46]+w[47])/2;
q[8]=(w[69]+w[70])/2;
