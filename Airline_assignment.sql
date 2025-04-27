--Creating new merged table
CREATE TABLE MergedTable (
    FL_DATE VARCHAR(50),
    OP_CARRIER VARCHAR(50),
    OP_CARRIER_FL_NUM VARCHAR(50),
    ORIGIN VARCHAR(50),
    DEST VARCHAR(50),
    CRS_DEP_TIME VARCHAR(50),
    DEP_TIME VARCHAR(50),
    DEP_DELAY VARCHAR(50),
    TAXI_OUT VARCHAR(50),
    WHEELS_OFF VARCHAR(50),
    WHEELS_ON VARCHAR(50),
    TAXI_IN VARCHAR(50),
    CRS_ARR_TIME VARCHAR(50),
    ARR_TIME VARCHAR(50),
    ARR_DELAY VARCHAR(50),
    CANCELLED VARCHAR(50),
    CANCELLATION_CODE VARCHAR(50),
    DIVERTED VARCHAR(50),
    CRS_ELAPSED_TIME VARCHAR(50),
    ACTUAL_ELAPSED_TIME VARCHAR(50),
    AIR_TIME VARCHAR(50),
    DISTANCE VARCHAR(50),
    CARRIER_DELAY VARCHAR(50),
    WEATHER_DELAY VARCHAR(50),
    NAS_DELAY VARCHAR(50),
    SECURITY_DELAY VARCHAR(50),
    LATE_AIRCRAFT_DELAY VARCHAR(50)
);

--Merging all tables to one table
INSERT INTO MergedTable
SELECT * FROM Year2014
UNION ALL
SELECT * FROM Year2015
UNION ALL
SELECT * FROM Year2016
UNION ALL
SELECT * FROM Year2017
UNION ALL
SELECT * FROM Year2018;

-- Count total rows
Select count(*) from MergedTable As Totalrows;

--Check columns and data types
Select Column_Name, Data_type From INFORMATION_SCHEMA.COLUMNS where Table_name ='MergedTable';

--Checking few sample rows
Select * from MergedTable Tablesample(100);

--removing decimals from time and converting it to HH:MM format
SELECT 
    CRS_DEP_TIME AS Original_CRS_DEP_TIME,
    TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(CRS_DEP_TIME, CHARINDEX('.', CRS_DEP_TIME + '.') - 1), 4), 3, 0, ':')) AS Converted_CRS_DEP_TIME,

    DEP_TIME AS Original_DEP_TIME,
    TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(DEP_TIME, CHARINDEX('.', DEP_TIME + '.') - 1), 4), 3, 0, ':')) AS Converted_DEP_TIME,

    CRS_ARR_TIME AS Original_CRS_ARR_TIME,
    TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(CRS_ARR_TIME, CHARINDEX('.', CRS_ARR_TIME + '.') - 1), 4), 3, 0, ':')) AS Converted_CRS_ARR_TIME,

    ARR_TIME AS Original_ARR_TIME,
    TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(ARR_TIME, CHARINDEX('.', ARR_TIME + '.') - 1), 4), 3, 0, ':')) AS Converted_ARR_TIME,

    WHEELS_ON AS Original_WHEELS_ON,
    TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(WHEELS_ON, CHARINDEX('.', WHEELS_ON + '.') - 1), 4), 3, 0, ':')) AS Converted_WHEELS_ON,

    WHEELS_OFF AS Original_WHEELS_OFF,
    TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(WHEELS_OFF, CHARINDEX('.', WHEELS_OFF + '.') - 1), 4), 3, 0, ':')) AS Converted_WHEELS_OFF

FROM MergedTable;

--Add New Columns to Store Converted Time Values
ALTER TABLE MergedTable 
ADD Sch_Dep_Time TIME(0),
    Act_Dep_Time TIME(0),
    Sch_Arr_Time TIME(0),
    Act_Arr_Time TIME(0),
    Act_Wheels_On TIME(0),
    Act_Wheels_Off TIME(0);

--Update merged table with converted time
UPDATE MergedTable
SET Sch_Dep_Time = TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(CRS_DEP_TIME, CHARINDEX('.', CRS_DEP_TIME + '.') - 1), 4), 3, 0, ':')),
    Act_Dep_Time = TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(DEP_TIME, CHARINDEX('.', DEP_TIME + '.') - 1), 4), 3, 0, ':')),
    Sch_Arr_Time = TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(CRS_ARR_TIME, CHARINDEX('.', CRS_ARR_TIME + '.') - 1), 4), 3, 0, ':')),
    Act_Arr_Time = TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(ARR_TIME, CHARINDEX('.', ARR_TIME + '.') - 1), 4), 3, 0, ':')),
    Act_Wheels_On = TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(WHEELS_ON, CHARINDEX('.', WHEELS_ON + '.') - 1), 4), 3, 0, ':')),
    Act_Wheels_Off = TRY_CONVERT(TIME(0), STUFF(RIGHT('0000' + LEFT(WHEELS_OFF, CHARINDEX('.', WHEELS_OFF + '.') - 1), 4), 3, 0, ':'));

--Calculating time difference
SELECT Sch_Dep_Time, Act_Dep_Time, DEP_DELAY, DATEDIFF(MINUTE, Sch_Dep_time, Act_Dep_Time) AS MinutesDifference
FROM MergedTable Where DEP_DELAY = NULL; 

--Remove Decimal With Rounding from all duration column
UPDATE MergedTable
SET DEP_DELAY = ROUND(DEP_DELAY, 0),
    ARR_DELAY = ROUND(ARR_DELAY, 0),
	CRS_ELAPSED_TIME = ROUND(CRS_ELAPSED_TIME, 0),
	ACTUAL_ELAPSED_TIME = ROUND(ACTUAL_ELAPSED_TIME, 0),
	AIR_TIME = ROUND(AIR_TIME, 0),
	TAXI_OUT = ROUND(TAXI_OUT, 0),
	TAXI_IN = ROUND(TAXI_IN, 0),
	CARRIER_DELAY = ROUND(CARRIER_DELAY, 0),
	WEATHER_DELAY = ROUND(WEATHER_DELAY, 0),
	NAS_DELAY = ROUND(NAS_DELAY, 0),
	SECURITY_DELAY = ROUND(SECURITY_DELAY, 0),
	LATE_AIRCRAFT_DELAY = ROUND(LATE_AIRCRAFT_DELAY, 0);

--Remove Decimal With Rounding from all Distance, Cancelled and Diverted column
UPDATE MergedTable
SET DISTANCE = FLOOR(DISTANCE),
    CANCELLED = FLOOR(CANCELLED),
	DIVERTED = FLOOR(DIVERTED);

--Removing columns not required
ALTER TABLE MergedTable 
DROP COLUMN CRS_DEP_TIME, DEP_TIME, CRS_ARR_TIME, ARR_TIME, WHEELS_ON, WHEELS_OFF;

--Checking count of columns that can be calculated
SELECT Count(Act_Dep_Time)
FROM MergedTable
WHERE Act_Dep_Time <> '00:00:00' and CANCELLED =1;

Select Count(Diverted) From MergedTable where DIVERTED = 1;

SELECT count(*)
FROM MergedTable 
WHERE ARR_DELAY = 0 and Sch_Arr_time <> Act_Arr_Time;

--Calculating NUll Values
Select count(ARR_DELAY)
From MergedTable Where (ARR_DELAY = 0 AND Act_Arr_Time <> Sch_Arr_Time) Or (ARR_DELAY IS NULL AND (Act_Arr_Time is Null or Act_Arr_Time ='00:00:00' ));

Select Count(*)
From MergedTable Where CARRIER_DELAY  =0 And WEATHER_DELAY =0 AND NAS_DELAY =0 AND SECURITY_DELAY =0 AND LATE_AIRCRAFT_DELAY =0;

select Act_Wheels_On, CANCELLED from MergedTable
where Act_Wheels_On ='00:00:00' Or Act_Wheels_On is NULL;

Select count(*)
From MergedTable Where Act_Wheels_On ='' Or Act_Wheels_On is NULL;


--Deleting Rows not required
Delete From MergedTable Where Act_Arr_Time = '00:00:00' And CANCELLED = 0

--Changing to NULL whereever required
UPDATE MergedTable
SET Act_Dep_Time = NULL,
    Act_Arr_Time = NULL,
	DEP_DELAY = NULL,
	ARR_DELAY = NULL
WHERE CANCELLED = 1;

--Updating all cancelled flight time to NULL
Update MergedTable
Set WEATHER_DELAY = NULL,
    NAS_DELAY = NULL,
    SECURITY_DELAY = NULL,
    LATE_AIRCRAFT_DELAY = NULL
where CARRIER_DELAY  is NULL;

--Updating all non- cancelled flight time to HH:MM:SS format
Update MergedTable
Set Act_Arr_Time = '00:00:00' where Act_Arr_Time is NULL AND CANCELLED = 0;

-- Checking changes
Select Act_Wheels_Off, Cancelled From MergedTable Where Act_Wheels_Off Is NULL or Act_Wheels_Off ='00:00:00';

-- Adding calculations to Merged table to calculate dep_delay where possible
ALTER TABLE MergedTable
ADD Cal_ARR_DELAY TIME,
    Cal_CRS_ELAPSED_TIME TIME,
	Cal_ACTUAL_ELAPSED_TIME TIME,
	Cal_AIR_TIME TIME;


UPDATE MergedTable
SET Cal_ARR_DELAY = DATEDIFF(MINUTE, Sch_Dep_time, Act_Dep_Time),
    Cal_CRS_ELAPSED_TIME = DATEDIFF(MINUTE, Sch_Dep_Time, Sch_Arr_Time),
	Cal_ACTUAL_ELAPSED_TIME = DATEDIFF(MINUTE, Act_Dep_Time, Act_Arr_Time),
	Cal_AIR_TIME = DATEDIFF(MINUTE, Act_Wheels_On, Act_Wheels_Off)



