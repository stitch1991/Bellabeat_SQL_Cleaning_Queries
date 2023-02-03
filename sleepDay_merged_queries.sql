
/*Cleaning Process For sleepDay_merged Table*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

/*Cleaning for entire table*/

	/*1a) Add Primary Key column to table*/

	/*Create a new column called Row_id that is filled with a consective number series. 
	Assign this column to be the Primary Key*/
	ALTER TABLE bellabeat.dbo.sleepDay_merged ADD Row_id_sleep INT IDENTITY(1,1)
	SELECT * FROM bellabeat.dbo.sleepDay_merged

	/*1b) Check for NULLS*/
	SELECT
	Id,  
	SleepDay, 
	TotalSleepRecords, 
	TotalMinutesAsleep, 
	TotalTimeInBed, 
	Row_id_sleep
	FROM
	bellabeat.dbo.sleepDay_merged
	WHERE
	Id IS NULL OR  
	SleepDay IS NULL OR
	TotalSleepRecords IS NULL OR
	TotalMinutesAsleep IS NULL OR
	TotalTimeInBed IS NULL OR
	Row_id_sleep IS NULL
		/*RESULTS RETURNED: None. Table contains no NULL fields*/

	/*1c) Check for blank fields/empty strings*/
	SELECT
	Id,  
	SleepDay, 
	TotalSleepRecords, 
	TotalMinutesAsleep, 
	TotalTimeInBed, 
	Row_id_sleep
	FROM
	bellabeat.dbo.sleepDay_merged
	WHERE
	Id = '' OR
	SleepDay = '' OR
	TotalSleepRecords = '' OR
	TotalMinutesAsleep = '' OR
	TotalTimeInBed = '' OR
	Row_id_sleep = ''
		/*RESULTS RETURNED: None. Table does not contain blank fields/empty strings*/

	/*1d) Check for duplicate rows. Exclude Primary Key column to ensure duplicate results are returned*/
	SELECT
	Id,  
	SleepDay, 
	TotalSleepRecords, 
	TotalMinutesAsleep, 
	TotalTimeInBed, 
	Row_id_sleep,
	COUNT(*)
	FROM bellabeat.dbo.sleepDay_merged
	GROUP BY
	Id,  
	SleepDay, 
	TotalSleepRecords, 
	TotalMinutesAsleep, 
	TotalTimeInBed, 
	Row_id_sleep
	HAVING COUNT(*) > 1
		/*RESULTS RETURNED: None. Table does not contain duplicate rows*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

/*Column-By-Column Cleaning*/

	/*Id Column*/

	/*2a) Check for blank fields and NULLS*/
	SELECT Row_id_sleep, Id FROM bellabeat.dbo.sleepDay_merged WHERE Id = '' OR Id IS NULL
		/*RESULTS RETURNED: None. Column contains no blank fields or NULL values*/

	/*2b) Check for extra spaces*/
	SELECT Row_id_sleep, Id FROM bellabeat.dbo.sleepDay_merged WHERE Id LIKE ' %' OR Id LIKE '% ' OR Id LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*2c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id_sleep, Id FROM bellabeat.dbo.sleepDay_merged WHERE Id LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*2d) Check for number of unique Id's representing respondents*/
	SELECT DISTINCT Id FROM bellabeat.dbo.sleepDay_merged
		/*RESULTS RETURNED: Column contains 24 unique Id's. There seems to be less respondents for this dataset than the dailyActivity_merged dataset*/

	/*2e) Check Id length. Should all be equal to 10*/
	SELECT LEN(Id) FROM bellabeat.dbo.sleepDay_merged WHERE LEN(Id) <> 10
		/*RESULTS RETURNED: None. Column contains no cells where string lenght of Id is not 10*/

	/*No change of data type. Leave as VARCHAR data type*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*SleepDay Column*/

	/*3a) Check for blank cells and NULL values*/
	SELECT Row_id_sleep, SleepDay FROM bellabeat.dbo.sleepDay_merged WHERE SleepDay = '' OR SleepDay IS NULL
		/*RESULTS RETURNED: None. Column contains no blank fields or NULL values*/

	/*3b) Check for extra spaces*/
	SELECT Row_id_sleep, SleepDay FROM bellabeat.dbo.sleepDay_merged WHERE SleepDay LIKE ' %' OR SleepDay LIKE '% ' OR SleepDay NOT LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces before or after the date and time. There are 2 single spaces 
		that separate the date, time and AM/PM section. These are not considered extra spaces and can remain. Since there should
		only be single spaces, check to ensure that there are only single spaces, as well as no leading or trailing spaces*/

	/*3c) Check for cells containing extra characters and symbols. Column should only contain numbers; the '/' symbol to separate day, month and year;
	the ':' symbol to separate hour, minute and second; single spaces to separate the date, time and AM sections; and the letters 'A', 'P', and'M'*/
	SELECT Row_id_sleep, SleepDay FROM bellabeat.dbo.sleepDay_merged WHERE SleepDay LIKE '%[^APM /:0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*3d) Check for cells NOT containing the correct format of month/day/year hour:min:sec AM-PM */
	SELECT Row_id_sleep, SleepDay FROM bellabeat.dbo.sleepDay_merged WHERE SleepDay NOT LIKE '%/%/% %:%:% %'
		/*RESULTS RETURNED: None. Column contains no cells not in the correct format*/

	/*UPDATE TO DATE-TIME FORMAT*/

	/*3e) Check that year = 2016*/
	SELECT Row_id_sleep, YEAR(SleepDay) FROM bellabeat.dbo.sleepDay_merged WHERE YEAR(SleepDay) <> 2016
		/*RESULTS RETURNED: None. Column contains no cells where year is not 2016*/

	/*3f) Check that month is either April or May. Data was collected only in those 2 months*/
	SELECT Row_id_sleep, MONTH(SleepDay) FROM bellabeat.dbo.sleepDay_merged WHERE MONTH(SleepDay) <> 4 AND MONTH(SleepDay) <> 5
		/*RESULTS RETURNED: None. Column contains no cells where month is not April nor May*/
	
	/*3g) Check that day is not greater than 31. There are only 30/31 days in a month*/
	SELECT Row_id_sleep, DAY(SleepDay) FROM bellabeat.dbo.sleepDay_merged WHERE DAY(SleepDay) > 32 OR DAY(SleepDay) < 1 
		/*RESULTS RETURNED: None. Column contains no cells where day is greater than 31 or less than 1*/

	/*3h) Check that hour is a number between 0 and 23, (24 hour time) inclusive*/
	SELECT Row_id_sleep, DATEPART(HOUR, SleepDay) FROM bellabeat.dbo.sleepDay_merged WHERE DATEPART(HOUR, SleepDay) > 24 OR DATEPART(HOUR, SleepDay) < 0
		/*RESULTS RETURNED: None. Column contains no cells where hour is outside the range of 0 - 23, inclusive*/

	/*3i) Check that minute is a number between 0 and 59, inclusive*/
	SELECT Row_id_sleep, DATEPART(MINUTE, SleepDay) FROM bellabeat.dbo.sleepDay_merged WHERE DATEPART(MINUTE, SleepDay) < 0 OR DATEPART(MINUTE, SleepDay) > 59
		/*RESULTS RETURNED: None. Column contains no cells where minute is outside that range*/

	/*3j) Check that second is a number between 0 and 59, inclusive*/
	SELECT Row_id_sleep, DATEPART(SECOND, SleepDay) FROM bellabeat.dbo.sleepDay_merged WHERE DATEPART(SECOND, SleepDay) < 0 OR DATEPART(SECOND, SleepDay) > 59
		/*RESULTS RETURNED: None. Column contains no cells where second is outside that range*/

	/*3k) Check the date range. Date should be between 04/12/2016 and 05/12/2016, inclusive.
	Earliest date should be 04/12/2016*/
	SELECT MIN(SleepDay) FROM bellabeat.dbo.sleepDay_merged
		/*RESULTS RETURNED: 2016-04-12. This is the column's earliest date which is correct*/

	/*3l) Latest date should be 05/12/2016*/
	SELECT MAX(SleepDay) FROM bellabeat.dbo.sleepDay_merged
		/*RESULTS RETURNED 2016-05-12. This is the column's latest date, which is correct:*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*TotalSleepRecords Column*/

	/*4a) Check for blanks and NULL values*/
	SELECT Row_id_sleep, TotalSleepRecords FROM bellabeat.dbo.sleepDay_merged WHERE TotalSleepRecords = '' OR TotalSleepRecords IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*4b) Check for extra spaces*/
	SELECT Row_id_sleep, TotalSleepRecords FROM bellabeat.dbo.sleepDay_merged WHERE TotalSleepRecords LIKE ' %' OR TotalSleepRecords LIKE '% ' OR TotalSleepRecords LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*4c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id_sleep, TotalSleepRecords FROM bellabeat.dbo.sleepDay_merged WHERE TotalSleepRecords LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*4d) Check for outliers towards the lower values*/
	SELECT Row_id_sleep, TotalSleepRecords FROM bellabeat.dbo.sleepDay_merged ORDER BY TotalSleepRecords
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 1 and is not considered an outlier value.
		This column does not have unusual values*/

	/*4e) Check for outliers toward the higher values*/
	SELECT Row_id_sleep, TotalSleepRecords FROM bellabeat.dbo.sleepDay_merged ORDER BY TotalSleepRecords DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 3 followed by 2. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*4f) Check all values are greater than 0*/
	SELECT Row_id_sleep, TotalSleepRecords FROM bellabeat.dbo.sleepDay_merged WHERE TotalSleepRecords < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*TotalMinutesAsleep Column*/

	/*5a) Check for blanks and NULL values*/
	SELECT Row_id_sleep, TotalMinutesAsleep FROM bellabeat.dbo.sleepDay_merged WHERE TotalMinutesAsleep = '' OR TotalMinutesAsleep IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*5b) Check for extra spaces*/
	SELECT Row_id_sleep, TotalMinutesAsleep FROM bellabeat.dbo.sleepDay_merged WHERE TotalMinutesAsleep LIKE ' %' OR TotalMinutesAsleep LIKE '% ' OR TotalMinutesAsleep LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*5c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id_sleep, TotalMinutesAsleep FROM bellabeat.dbo.sleepDay_merged WHERE TotalMinutesAsleep LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*5d) Check for outliers towards the lower values*/
	SELECT Row_id_sleep, TotalMinutesAsleep FROM bellabeat.dbo.sleepDay_merged ORDER BY TotalMinutesAsleep
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 58 and is not considered an outlier value.
		This column does not have unusual values*/

	/*5e) Check for outliers toward the higher values*/
	SELECT Row_id_sleep, TotalMinutesAsleep FROM bellabeat.dbo.sleepDay_merged ORDER BY TotalMinutesAsleep DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 796 minutes followed by 775 minutes. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*5f) Check all values are greater than 0 since this is measuring time duration*/
	SELECT Row_id_sleep, TotalMinutesAsleep FROM bellabeat.dbo.sleepDay_merged WHERE TotalMinutesAsleep < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*TotalTimeInBed Column*/

	/*6a) Check for blanks and NULL values*/
	SELECT Row_id_sleep, TotalTimeInBed FROM bellabeat.dbo.sleepDay_merged WHERE TotalTimeInBed = '' OR TotalTimeInBed IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*6b) Check for extra spaces*/
	SELECT Row_id_sleep, TotalTimeInBed FROM bellabeat.dbo.sleepDay_merged WHERE TotalTimeInBed LIKE ' %' OR TotalTimeInBed LIKE '% ' OR TotalTimeInBed LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*6c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id_sleep, TotalTimeInBed FROM bellabeat.dbo.sleepDay_merged WHERE TotalTimeInBed LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*6d) Check for outliers towards the lower values*/
	SELECT Row_id_sleep, TotalTimeInBed FROM bellabeat.dbo.sleepDay_merged ORDER BY TotalTimeInBed
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 61 and is not considered an outlier value.
		This column does not have unusual values*/

	/*6e) Check for outliers toward the higher values*/
	SELECT Row_id_sleep, TotalTimeInBed FROM bellabeat.dbo.sleepDay_merged ORDER BY TotalTimeInBed DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 961 minutes followed by 843 minutes. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*6f) Check all values are greater than 0 since this is measuring time duration*/
	SELECT Row_id_sleep, TotalTimeInBed FROM bellabeat.dbo.sleepDay_merged WHERE TotalTimeInBed < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*Cleaning Complete*/