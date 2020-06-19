

PROC IMPORT DATAFILE='/home/u39545009/provider/data/hospital.csv'
	DBMS=CSV
	OUT=WORK.hosp;
	GETNAMES=YES;
RUN;

PROC IMPORT DATAFILE='/home/u39545009/provider/data/asc.csv'
	DBMS=CSV
	OUT=WORK.asc;
	GETNAMES=YES;
RUN;

data hosp;
set hosp;
where var8 = 'NY';
type = 'Hospital';
Address = cats(Provider_First_Line_Business_Pr,Provider_Second_Line_Business_P);
drop Provider_First_Line_Business_Pr Provider_Second_Line_Business_P;
Zip = input(Var9,5.);
run;

data asc;
set asc;
where var8 = 'NY';
type = 'Hospital';
Address = cats(Provider_First_Line_Business_Pr,Provider_Second_Line_Business_P);
drop Provider_First_Line_Business_Pr Provider_Second_Line_Business_P;
Zip = input(Var9,5.);
run;





