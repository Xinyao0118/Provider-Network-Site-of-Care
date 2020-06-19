

PROC IMPORT DATAFILE='/home/u39545009/provider/data/hospital.csv' replace
	DBMS=CSV
	OUT=WORK.hosp;
	GETNAMES=YES;
RUN;

PROC IMPORT DATAFILE='/home/u39545009/provider/data/asc.csv' replace
	DBMS=CSV
	OUT=WORK.asc;
	GETNAMES=YES;
RUN;

data hosp;
set hosp;
where var8 = 'NY';
type = 'Hospital';
Address = coalescec(Provider_First_Line_Business_Pr,Provider_Second_Line_Business_P);
drop Provider_First_Line_Business_Pr Provider_Second_Line_Business_P;
Zip = input(Var9,5.);
run;

data asc;
set asc;
where var8 = 'NY';
type = 'Asc';
Address = coalescec(Provider_First_Line_Business_Pr,Provider_Second_Line_Business_P);
drop Provider_First_Line_Business_Pr Provider_Second_Line_Business_P;
Zip = input(Var9,5.);
run;

proc sql;
create table nyc as 
select * from hosp
union all 
select * from asc;
quit;

data nyc;
set nyc;
rename Provider_Business_Practice_Loca = City VAR8 = State;
run;

proc geocode
method = street
data = nyc
out = nyc_coded
lookupstreet=SASHELP.GEOEXM; 
run;
data nyc_coded;
set nyc_coded;
rename Y = Longitude X = latitude;
run;

proc export data=nyc_coded
outfile='/home/u39545009/provider/data/nyc.xlsx'
dbms = xlsx
replace;
run;

