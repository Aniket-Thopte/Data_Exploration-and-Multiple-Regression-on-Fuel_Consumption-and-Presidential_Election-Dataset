proc import datafile="\\apporto.com\dfs\UNCC\Users\athopte_uncc\Downloads\Exam-1\fuelc.csv"
DBMS=csv out=fuelc replace;
proc print data=fuelc;
run;

proc univariate data=fuelc normal plot;
var distance speed temp_outside gas_type rain sun consume;
run;

data outliers;
set fuelc;
if distance < 1 then delete;
if distance > 29.8 then delete;
run;
proc print data=outliers;
run;

proc surveyselect data=outliers
samprate=0.8
out=sample1
outall method=srs;
run;

proc univariate data=outliers normal plot;
var distance speed temp_outside gas_type rain sun consume;
run;

data train;
set sample1;
if(Selected=1) then output;
run;
proc print data=train;
run;

data test;
set sample1;
if(Selected=0) then output;
run;
proc print data=test;
run;

proc reg data=train;
model consume = distance speed temp_outside gas_type rain sun / tol vif collin;
run;

proc reg data=train;
model consume = distance speed temp_outside rain sun / tol vif collin;
run;

proc reg data=train;
model consume = distance speed temp_outside rain / tol vif collin;
plot r.*p.;
run;

data testing;
set test;
y_bar= (7.06682) + (-0.06723)*distance + (-0.01996)*speed + (-0.03845)*temp_outside + (0.58538)*rain;
predicted_err=((consume-y_bar)**2);
run;
proc print data=testing;
run; 

proc means data=testing Mean;
var predicted_err;
run;
