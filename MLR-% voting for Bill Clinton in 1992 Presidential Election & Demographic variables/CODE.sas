proc import datafile="\\apporto.com\dfs\UNCC\Users\athopte_uncc\Downloads\Assign-1\Votes.xls"
DBMS=xls out=votes replace;

proc print data=votes;
run;

proc univariate data=votes normal plot;
var savings poverty;
run;

data votes2;
set votes;
if savings > 165608.5 then delete;
if savings < 408.5 then delete;
if poverty > 32.575 then delete; 
if poverty < -1.625 then delete; 
run;

proc print data=votes2;
run;

data votes3;
set votes2;
LINCOME = log(INCOME);
run;

proc print data=votes3;
run;

proc surveyselect data=votes3 (firstobs=1 obs=500)
sampsize = 500
out=votetrain
method = srs;
run;

proc print data=votetrain;
run;


proc surveyselect data=votes3 (firstobs=501 obs=703)
sampsize = 203
out=votetest
method = srs;
run;

proc print data=votetest;
run;


proc reg data=votetrain;
model votes = savings poverty veterans female density LINCOME / tol vif colin;
run;

proc reg data=votetrain;
model votes = savings poverty veterans female density / tol vif colin;
run;

proc reg data=votetrain;
model votes = poverty veterans female density LINCOME / tol vif colin;
run;

proc reg data=votetrain;
model votes = poverty veterans female density / tol vif colin;
plot r.*p.;
run;

data mod_test; 
set votetest; 
y_bar = -49.64338 + (0.84358*poverty) + (0.70283*veterans) + (1.35214*female) + (0.00273*density);
Predicted_err = ((votes-y_bar)**2);
run;

proc print data=mod_test;run;

proc means data=mod_test Mean;
var Predicted_err;
run;


