
/*Cleaning Process For minutesMETsNarrow_merged Table*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

/*Cleaning for entire table*/

	/*1a) Add Primary Key column to table*/

	/*Create a new column called Row_id that is filled with a consective number series. 
	Assign this column to be the Primary Key*/
	ALTER TABLE bellabeat.dbo.minuteMETsNarrow_merged ADD Row_id_MET INT IDENTITY(1,1)
	SELECT * FROM bellabeat.dbo.minuteMETsNarrow_merged

	/*1b) Check for NULLS*/
	SELECT
	Id,  
	ActivityMinute, 
	METs,  
	Row_id_MET
	FROM
	bellabeat.dbo.minuteMETsNarrow_merged
	WHERE
	Id IS NULL OR  
	ActivityMinute IS NULL OR
	METs IS NULL OR
	Row_id_MET IS NULL
		/*RESULTS RETURNED: None. Table contains no NULL fields*/

	/*1c) Check for blank fields/empty strings*/
	SELECT
	Id,  
	ActivityMinute, 
	METs,  
	Row_id_MET
	FROM
	bellabeat.dbo.minuteMETsNarrow_merged
	WHERE
	Id = '' OR
	ActivityMinute = '' OR
	METs = '' OR
	Row_id_MET = ''
		/*RESULTS RETURNED: None. Table does not contain blank fields/empty strings*/

	/*1d) Check for duplicate rows. Exclude Primary Key column to ensure duplicate results are returned*/
	SELECT
	Id,  
	ActivityMinute, 
	METs,  
	Row_id_MET,
	COUNT(*)
	FROM bellabeat.dbo.minuteMETsNarrow_merged
	GROUP BY
	Id,  
	ActivityMinute, 
	METs,  
	Row_id_MET
	HAVING COUNT(*) > 1
		/*RESULTS RETURNED: None. Table does not contain duplicate rows*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

/*Column-By-Column Cleaning*/

	/*Id Column*/

	/*2a) Check for blank fields and NULLS*/
	SELECT Row_id_MET, Id FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE Id = '' OR Id IS NULL
		/*RESULTS RETURNED: None. Column contains no blank fields or NULL values*/

	/*2b) Check for extra spaces*/
	SELECT Row_id_MET, Id FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE Id LIKE ' %' OR Id LIKE '% ' OR Id LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*2c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id_MET, Id FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE Id LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*2d) Check for number of unique Id's representing respondents*/
	SELECT DISTINCT Id FROM bellabeat.dbo.minuteMETsNarrow_merged
		/*RESULTS RETURNED: Column contains 33 unique Id's*/

	/*2e) Check Id length. Should all be equal to 10*/
	SELECT LEN(Id) FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE LEN(Id) <> 10
		/*RESULTS RETURNED: None. Column contains no cells where string lenght of Id is not 10*/

	/*No change of data type. Leave as VARCHAR data type*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

/*ActivityMinute Column*/

	/*3a) Check for blank cells and NULL values*/
	SELECT Row_id_MET, ActivityMinute FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE ActivityMinute = '' OR ActivityMinute IS NULL
		/*RESULTS RETURNED: None. Column contains no blank fields or NULL values*/

	/*3b) Check for extra spaces*/
	SELECT Row_id_MET, ActivityMinute FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE ActivityMinute LIKE ' %' OR ActivityMinute LIKE '% ' OR ActivityMinute NOT LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces before or after the date and time. There are 2 single spaces 
		that separate the date, time and AM/PM section. These are not considered extra spaces and can remain. Since there should
		only be single spaces, check to ensure that there are only single spaces, as well as no leading or trailing spaces*/

	/*3c) Check for cells containing extra characters and symbols. Column should only contain numbers; the '/' symbol to separate day, month and year;
	the ':' symbol to separate hour, minute and second; single spaces to separate the date, time and AM sections; and the letters 'A', 'P', and'M'*/
	SELECT Row_id_MET, ActivityMinute FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE ActivityMinute LIKE '%[^APM /:0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*3d) Check for cells NOT containing the correct format of month/day/year hour:min:sec AM-PM */
	SELECT Row_id_MET, ActivityMinute FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE ActivityMinute NOT LIKE '%/%/% %:%:% %'
		/*RESULTS RETURNED: None. Column contains no cells not in the correct format*/

	/*UPDATE TO DATE-TIME FORMAT*/

	/*3e) Check that year = 2016*/
	SELECT Row_id_MET, YEAR(ActivityMinute) FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE YEAR(ActivityMinute) <> 2016
		/*RESULTS RETURNED: None. Column contains no cells where year is not 2016*/

	/*3f) Check that month is either April or May. Data was collected only in those 2 months*/
	SELECT Row_id_MET, MONTH(ActivityMinute) FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE MONTH(ActivityMinute) <> 4 AND MONTH(ActivityMinute) <> 5
		/*RESULTS RETURNED: None. Column contains no cells where month is not April nor May*/
	
	/*3g) Check that day is not greater than 31. There are only 30/31 days in a month*/
	SELECT Row_id_MET, DAY(ActivityMinute) FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE DAY(ActivityMinute) > 32 OR DAY(ActivityMinute) < 1 
		/*RESULTS RETURNED: None. Column contains no cells where day is greater than 31 or less than 1*/

	/*3h) Check that hour is a number between 0 and 23, (24 hour time) inclusive*/
	SELECT Row_id_MET, DATEPART(HOUR, ActivityMinute) FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE DATEPART(HOUR, ActivityMinute) > 24 OR DATEPART(HOUR, ActivityMinute) < 0
		/*RESULTS RETURNED: None. Column contains no cells where hour is outside the range of 0 - 23, inclusive*/

	/*3i) Check that minute is a number between 0 and 59, inclusive*/
	SELECT Row_id_MET, DATEPART(MINUTE, ActivityMinute) FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE DATEPART(MINUTE, ActivityMinute) < 0 OR DATEPART(MINUTE, ActivityMinute) > 59
		/*RESULTS RETURNED: None. Column contains no cells where minute is outside that range*/

	/*3j) Check that second is a number between 0 and 59, inclusive*/
	SELECT Row_id_MET, DATEPART(SECOND, ActivityMinute) FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE DATEPART(SECOND, ActivityMinute) < 0 OR DATEPART(SECOND, ActivityMinute) > 59
		/*RESULTS RETURNED: None. Column contains no cells where second is outside that range*/

	/*3k) Check the date range. Date should be between 04/12/2016 and 05/12/2016, inclusive.
	Earliest date should be 04/12/2016*/
	SELECT MIN(ActivityMinute) FROM bellabeat.dbo.minuteMETsNarrow_merged
		/*RESULTS RETURNED: 2016-04-12. This is the column's earliest date, which is correct*/

	/*3l) Latest date should be 05/12/2016*/
	SELECT MAX(ActivityMinute) FROM bellabeat.dbo.minuteMETsNarrow_merged
		/*RESULTS RETURNED 2016-05-12. This is the column's latest date, which is correct:*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

/*METs Column*/

	/*4a) Check for blanks and NULL values*/
	SELECT Row_id_MET, METs FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE METs = '' OR METs IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*4b) Check for extra spaces*/
	SELECT Row_id_MET, METs FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE METs LIKE ' %' OR METs LIKE '% ' OR METs LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*4c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id_MET, METs FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE METs LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*4d) Check for outliers towards the lower values*/
	SELECT Row_id_MET, METs FROM bellabeat.dbo.minuteMETsNarrow_merged ORDER BY METs
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*4e) Check for outliers toward the higher values*/
	SELECT Row_id_MET, METs FROM bellabeat.dbo.minuteMETsNarrow_merged ORDER BY METs DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 157 followed by 153. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*4f) Check all values are greater than 0*/
	SELECT Row_id_MET, METs FROM bellabeat.dbo.minuteMETsNarrow_merged WHERE METs < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*Cleaning Complete*/