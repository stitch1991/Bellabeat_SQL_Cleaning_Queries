/*Cleaning for entire table*/

	/*1a) 
	Add Primary Key column to table*/

	/*Create a new column called Row_id that is filled with a consective number series. 
	Assign this column to be the Primary Key*/
	ALTER TABLE bellabeat.dbo.heartrate_seconds_merged ADD Row_id INT IDENTITY(1,1)
	SELECT * FROM bellabeat.dbo.heartrate_seconds_merged

	/*1b) 
	Check for NULLS*/
	SELECT
	Id,  
	Time, 
	Value 
	Row_id
	FROM
	bellabeat.dbo.heartrate_seconds_merged
	WHERE
	Id IS NULL OR 
	Time IS NULL OR
	Value IS NULL OR 
	Row_id IS NULL
		/*RESULTS RETURNED: None. Table contains no NULL fields*/

	/*1c) 
	Check for blank fields/empty strings*/
	SELECT
	Id,  
	Time, 
	Value 
	Row_id
	FROM
	bellabeat.dbo.heartrate_seconds_merged
	WHERE
	Id = '' OR 
	Time = '' OR
	Value = '' OR 
	Row_id = ''
		/*RESULTS RETURNED: None. Table contains no NULL fields*/

	/*1d) 
	Check for duplicate rows. Exclude PK column to ensure duplicate results are returned*/
	SELECT
	Id,  
	Time, 
	Value,  
	COUNT(*)
	FROM bellabeat.dbo.heartrate_seconds_merged
	GROUP BY
	Id,  
	Time, 
	Value
	HAVING COUNT(*) > 1
		/*RESULTS RETURNED: None. No dubplicate rows in this table*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

/*Column-By-Column Cleaning*/

	/*Id Column*/

	/*2a) Check for blank fields and NULLS*/
	SELECT Row_id, Id FROM bellabeat.dbo.heartrate_seconds_merged WHERE Id = '' OR Id IS NULL
		/*RESULTS RETURNED: None. Column contains no blank fields or NULL values*/

	/*2b) Check for extra spaces*/
	SELECT Row_id, Id FROM bellabeat.dbo.heartrate_seconds_merged WHERE Id LIKE ' %' OR Id LIKE '% ' OR Id LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*2c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id, Id FROM bellabeat.dbo.heartrate_seconds_merged WHERE Id LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols that are not numbers*/

	/*2d) Check number of unique Id's representing respondents*/
	SELECT DISTINCT Id FROM bellabeat.dbo.heartrate_seconds_merged
		/*RESULTS RETURNED: Column contains 14 unique Id's for 14 respondents.*/

	/*2e) Check Id length. Should all be equal to 10*/
	SELECT LEN(Id) FROM bellabeat.dbo.heartrate_seconds_merged WHERE LEN(Id) <> 10
		/*RESULTS RETURNED: None. Column contains no cells where string lenght of Id is not 10*/

	/*No change of data type. Leave as VARCHAR data type*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*Time Column*/

	/*3a)
	Check for blank cells and NULL values*/
	SELECT Row_id, Time FROM bellabeat.dbo.heartrate_seconds_merged WHERE Time = '' OR Time IS NULL
		/*RESULTS RETURNED: None. Column contains no blank fields or NULL values*/

	/*3b) Check for extra spaces*/
	SELECT Row_id, Time FROM bellabeat.dbo.heartrate_seconds_merged WHERE Time LIKE ' %' OR Time LIKE '% ' OR Time NOT LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces before or after the date and time. There are 2 single spaces 
		that seperate the date, time and AM/PM section. These are not considered extra spaces and can remain. Since there should
		only be single spaces, column was checked to ensure that there are only single spaces, as well as no leading or trailing spaces*/

	/*3c) Check for cells containing extra characters and symbols. Column should only contain numbers; the '/' symbol to seperate day, month and year;
	the ':' symbol to seperate hour, mintute and second; single spaces to seperate the date, time and AM sections; and the letters 'A', 'P', and'M'*/
	SELECT Row_id, Time FROM bellabeat.dbo.heartrate_seconds_merged WHERE Time LIKE '%[^APM /:0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*3d) Check for cells NOT containing the correct format of month/day/year hour:min:sec AM-PM */
	SELECT Row_id, Time FROM bellabeat.dbo.heartrate_seconds_merged WHERE Time NOT LIKE '%/%/% %:%:% %'
		/*RESULTS RETURNED: None. Column contains no cells not in the correct format*/

	/*UPDATE TO DATE-TIME FORMAT*/

	/*3e) Check that year = 2016*/
	SELECT Row_id, YEAR(Time) FROM bellabeat.dbo.heartrate_seconds_merged WHERE YEAR(Time) <> 2016
		/*RESULTS RETURNED: None. Column contains no cells where year is not 2016*/

	/*3f) Check that month is either April or May. Data was collected only in those 2 months*/
	SELECT Row_id, MONTH(Time) FROM bellabeat.dbo.heartrate_seconds_merged WHERE MONTH(Time) <> 4 AND MONTH(Time) <> 5
		/*RESULTS RETURNED: None. Column contains no cells where month is not April nor May*/
	
	/*3g) Check that day is not greater than 31 or less than 1. There are only 30/31 days in a month*/
	SELECT Row_id, DAY(Time) FROM bellabeat.dbo.heartrate_seconds_merged WHERE DAY(Time) > 32 OR DAY(Time) < 0
		/*RESULTS RETURNED: None. Column contains no cells where day is not between 1 and 31, inclusive*/

	/*3h) Check that hour is a number between 0 and 23, (24 hour time) inclusive*/
	SELECT Row_id, DATEPART(HOUR, Time) FROM bellabeat.dbo.heartrate_seconds_merged WHERE DATEPART(HOUR, Time) > 24 OR DATEPART(HOUR, Time) < 0
		/*RESULTS RETURNED: None. Column contains no cells where hour is outside the range of 0 - 23, inclusive*/

	/*3i) Check that minute is a number between 0 and 59, inclusive*/
	SELECT Row_id, DATEPART(MINUTE, Time) FROM bellabeat.dbo.heartrate_seconds_merged WHERE DATEPART(MINUTE, Time) < 0 OR DATEPART(MINUTE, Time) > 59
		/*RESULTS RETURNED: None. Column contains no cells where minute is outside that range*/

	/*3j) Check that second is a number between 0 and 59, inclusive*/
	SELECT Row_id, DATEPART(SECOND, Time) FROM bellabeat.dbo.heartrate_seconds_merged WHERE DATEPART(SECOND, Time) < 0 OR DATEPART(SECOND, Time) > 59
		/*RESULTS RETURNED: None. Column contains no cells where second is outside that range*/

	/*3k) Check the date range. Date should be between 04/12/2016 and 05/12/2016, inclusive.
	Earliest date should be 04/12/2016*/
	SELECT MIN(Time) FROM bellabeat.dbo.heartrate_seconds_merged
		/*RESULTS RETURNED: 2016-04-12. This is the column's earliest date which is correct*/

	/*3l) Latest date should be 05/12/2016*/
	SELECT MAX(Time) FROM bellabeat.dbo.heartrate_seconds_merged
		/*RESULTS RETURNED 2016-05-12. This is the column's latest date, which is correct:*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*Value Column*/

	/*4a) 
	Check for blanks and NULL values*/
	SELECT Row_id, Value FROM bellabeat.dbo.heartrate_seconds_merged WHERE Value = '' OR Value IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*4b) Check for extra spaces*/
	SELECT Row_id, Value FROM bellabeat.dbo.heartrate_seconds_merged WHERE Value LIKE ' %' OR Value LIKE '% ' OR Value LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*4c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id, Value FROM bellabeat.dbo.heartrate_seconds_merged WHERE Value LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*4d) Check for outliers towards the lower values*/
	SELECT Row_id, Value FROM bellabeat.dbo.heartrate_seconds_merged ORDER BY Value
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is approximately 36 and is not considered an outlier value.
		This column does not have unusual values*/

	/*4e) Check for outliers toward the higher values*/
	SELECT Row_id, Value FROM bellabeat.dbo.heartrate_seconds_merged ORDER BY Value DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 203 followed by 202. 
		These are not considered outlier values. This column does not have unusual values*/ 

	/*4f) Check all values are greater than 0*/
	SELECT Row_id, Value FROM bellabeat.dbo.heartrate_seconds_merged WHERE Value < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/


