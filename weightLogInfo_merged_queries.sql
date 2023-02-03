
/*Cleaning Process For weightLogInfo_merged Table*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

/*Cleaning for entire table*/

	/*1a) Add Primary Key column to table*/

	/*Create a new column called Row_id that is filled with a consective number series. 
	Assign this column to be the Primary Key*/
	ALTER TABLE bellabeat.dbo.weightLogInfo_merged ADD Row_id INT IDENTITY(1,1)
	SELECT * FROM bellabeat.dbo.weightLogInfo_merged

	/*1b) Check for NULLS*/
	SELECT
	Id,  
	Date, 
	WeightKg, 
	WeightPounds, 
	Fat, 
	BMI, 
	IsManualReport, 
	LogId,
	Row_id
	FROM
	bellabeat.dbo.weightLogInfo_merged
	WHERE
	Id IS NULL OR 
	Date IS NULL OR
	WeightKg IS NULL OR 
	WeightPounds IS NULL OR
	Fat IS NULL OR
	BMI IS NULL OR
	IsManualReport IS NULL OR
	LogId IS NULL OR
	Row_id IS NULL
		/*RESULTS RETURNED: None. Table contains no NULL fields*/

	/*1c) Check for blank fields/empty strings*/
	SELECT
	Id,  
	Date, 
	WeightKg, 
	WeightPounds, 
	Fat, 
	BMI, 
	IsManualReport, 
	LogId,
	Row_id
	FROM
	bellabeat.dbo.weightLogInfo_merged
	WHERE
	Id = '' OR
	WeightKg = '' OR 
	WeightPounds = '' OR
	Fat = '' OR
	BMI = '' OR
	IsManualReport = '' OR
	LogId = '' OR
	Date = '' OR
	Row_id = ''
		/*RESULTS RETURNED: The "Fat" column contains numerous empty cells. Only a few appear to have values. It seems that no other columns
		contain blank cells/empty strings. If you run the above query WITHOUT selecting the "Fat" column, NO RESULTS
		are returned, indicating the other columns all contain values in each row. Since this survey relied on respondent
		inputs, it is possible that they did not input any data for the "Fat" column cells. They can therefore remain blank*/

	/*1d) Check for duplicate rows. Exclude Primary Key column to ensure duplicate results are returned*/
	SELECT
	Id,  
	Date, 
	WeightKg, 
	WeightPounds, 
	Fat, 
	BMI, 
	IsManualReport, 
	LogId, 
	COUNT(*)
	FROM bellabeat.dbo.weightLogInfo_merged
	GROUP BY
		Id,  
	Date, 
	WeightKg, 
	WeightPounds, 
	Fat, 
	BMI, 
	IsManualReport, 
	LogId
	HAVING COUNT(*) > 1
		/*RESULTS RETURNED: None. No duplicate rows in this table*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

/*Column-By-Column Cleaning*/

	/*Id Column*/

	/*2a) Check for blank fields and NULLS*/
	SELECT Row_id, Id FROM bellabeat.dbo.weightLogInfo_merged WHERE Id = '' OR Id IS NULL
		/*RESULTS RETURNED: None. Column contains no blank fields or NULL values*/

	/*2b) Check for extra spaces*/
	SELECT Row_id, Id FROM bellabeat.dbo.weightLogInfo_merged WHERE Id LIKE ' %' OR Id LIKE '% ' OR Id LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*2c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id, Id FROM bellabeat.dbo.weightLogInfo_merged WHERE Id LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*2d) Check number of unique Id's representing respondents*/
	SELECT DISTINCT Id FROM bellabeat.dbo.weightLogInfo_merged
		/*RESULTS RETURNED: Column contains 8 unique Id's for 8 respondents*/

	/*2e) Check Id length. Should all be equal to 10*/
	SELECT LEN(Id) FROM bellabeat.dbo.weightLogInfo_merged WHERE LEN(Id) <> 10
		/*RESULTS RETURNED: None. Column contains no cells where string lenght of Id is not 10*/

	/*No change of data type. Leave as VARCHAR data type*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*Date Column*/

	/*3a) Check for blank cells and NULL values*/
	SELECT Row_id, Date FROM bellabeat.dbo.weightLogInfo_merged WHERE Date = '' OR Date IS NULL
		/*RESULTS RETURNED: None. Column contains no blank fields or NULL values*/

	/*3b) Check for extra spaces*/
	SELECT Row_id, Date FROM bellabeat.dbo.weightLogInfo_merged WHERE Date LIKE ' %' OR Date LIKE '% ' OR Date NOT LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces before or after the date and time. There are 2 single spaces 
		that separate the date, time and AM/PM section. These are not considered extra spaces and can remain. Since there should
		only be single spaces, column was checked to ensure that there are only single spaces, as well as no leading or trailing spaces*/

	/*3c) Check for cells containing extra characters and symbols. Column should only contain numbers; the '/' symbol to separate day, month and year;
	the ':' symbol to separate hour, minute and second; single spaces to separate the date, time and AM sections; and the letters 'A', 'P', and'M'*/
	SELECT Row_id, Date FROM bellabeat.dbo.weightLogInfo_merged WHERE Date LIKE '%[^APM /:0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*3d) Check for cells NOT containing the correct format of month/day/year hour:min:sec AM-PM */
	SELECT Row_id, Date FROM bellabeat.dbo.weightLogInfo_merged WHERE Date NOT LIKE '%/%/% %:%:% %'
		/*RESULTS RETURNED: None. Column contains no cells not in the correct format*/

	/*UPDATE TO DATE-TIME FORMAT*/

	/*3e) Check that year = 2016*/
	SELECT Row_id, YEAR(Date) FROM bellabeat.dbo.weightLogInfo_merged WHERE YEAR(Date) <> 2016
		/*RESULTS RETURNED: None. Column contains no cells where year is not 2016*/

	/*3f) Check that month is either April or May. Data was collected only in those 2 months*/
	SELECT Row_id, MONTH(Date) FROM bellabeat.dbo.weightLogInfo_merged WHERE MONTH(Date) <> 4 AND MONTH(Date) <> 5
		/*RESULTS RETURNED: None. Column contains no cells where month is not April nor May*/
	
	/*3g) Check that day is not greater than 31 or less than 1. There are only 30/31 days in a month*/
	SELECT Row_id, DAY(Date) FROM bellabeat.dbo.weightLogInfo_merged WHERE DAY(Date) > 32 OR DAY(Date) < 0
		/*RESULTS RETURNED: None. Column contains no cells where day is not between 1 and 31*/

	/*3h) Check that hour is a number between 0 and 23, (24 hour time) inclusive*/
	SELECT Row_id, DATEPART(HOUR, Date) FROM bellabeat.dbo.weightLogInfo_merged WHERE DATEPART(HOUR, Date) > 24 OR DATEPART(HOUR, Date) < 0
		/*RESULTS RETURNED: None. Column contains no cells where hour is outside the range of 0 - 23, inclusive*/

	/*3i) Check that minute is a number between 0 and 59, inclusive*/
	SELECT Row_id, DATEPART(MINUTE, Date) FROM bellabeat.dbo.weightLogInfo_merged WHERE DATEPART(MINUTE, Date) < 0 OR DATEPART(MINUTE, DATE) > 59
		/*RESULTS RETURNED: None. Column contains no cells where minute is outside that range*/

	/*3j) Check that second is a number between 0 and 59, inclusive*/
	SELECT Row_id, DATEPART(SECOND, Date) FROM bellabeat.dbo.weightLogInfo_merged WHERE DATEPART(SECOND, Date) < 0 OR DATEPART(SECOND, DATE) > 59
		/*RESULTS RETURNED: None. Column contains no cells where second is outside that range*/

	/*3k) Check the date range. Date should be between 04/12/2016 and 05/12/2016, inclusive.
	Earliest date should be 04/12/2016*/
	SELECT MIN(Date) FROM bellabeat.dbo.weightLogInfo_merged
		/*RESULTS RETURNED: 2016-04-12. This is the column's earliest date, which is correct*/

	/*3l) Latest date should be 05/12/2016*/
	SELECT MAX(Date) FROM bellabeat.dbo.weightLogInfo_merged
		/*RESULTS RETURNED 2016-05-12. This is the column's latest date, which is correct:*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*WeightKg Column*/

	/*4a) Check for blanks and NULL values*/
	SELECT Row_id, WeightKg FROM bellabeat.dbo.weightLogInfo_merged WHERE WeightKg = '' OR WeightKg IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*4b) Check for extra spaces*/
	SELECT Row_id, WeightKg FROM bellabeat.dbo.weightLogInfo_merged WHERE WeightKg LIKE ' %' OR WeightKg LIKE '% ' OR WeightKg LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*4c) Check for cells containing extra characters and symbols. Column should only contain numbers and the decimal point - "."*/
	SELECT Row_id, WeightKg FROM bellabeat.dbo.weightLogInfo_merged WHERE WeightKg LIKE '%[^.0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO FLOAT*/

	/*4d) Check for outliers towards the lower values*/
	SELECT Row_id, WeightKg FROM bellabeat.dbo.weightLogInfo_merged ORDER BY WeightKg
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is approximately 52.599998 and is not considered an outlier value.
		This column does not have unusual values*/

	/*4e) Check for outliers toward the higher values*/
	SELECT Row_id, WeightKg FROM bellabeat.dbo.weightLogInfo_merged ORDER BY WeightKg DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 133.5kg followed by 90.699997kg. 
		The highest value is larger than the 2nd highest value by about 43kg. This seems to be odd when compared with the
		other values. It could potentially be an outlier. This value is at Row_id = 3. It will not be removed from the table but will
		be noted. If analysis is conducted without this value, the table will be first copied, and then this value will be removed from the copy*/ 

	/*4f) Check all values are greater than 0*/
	SELECT Row_id, WeightKg FROM bellabeat.dbo.weightLogInfo_merged WHERE WeightKg < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*WeightPounds Column*/

	/*5a) Check for blanks and NULL values*/
	SELECT Row_id, WeightPounds FROM bellabeat.dbo.weightLogInfo_merged WHERE WeightPounds = '' OR WeightPounds IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*5b) Check for extra spaces*/
	SELECT Row_id, WeightPounds FROM bellabeat.dbo.weightLogInfo_merged WHERE WeightPounds LIKE ' %' OR WeightPounds LIKE '% ' OR WeightPounds LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*5c) Check for cells containing extra characters and symbols. Column should only contain numbers and the decimal point - "."*/
	SELECT Row_id, WeightPounds FROM bellabeat.dbo.weightLogInfo_merged WHERE WeightPounds LIKE '%[^.0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO FLOAT*/

	/*5d) Check for outliers towards the lower values*/
	SELECT Row_id, WeightPounds FROM bellabeat.dbo.weightLogInfo_merged ORDER BY WeightPounds
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is approximately 115.963147 pounds and is not considered an outlier value.
		This column does not have unusual values*/

	/*5e) Check for outliers toward the higher values*/
	SELECT Row_id, WeightPounds FROM bellabeat.dbo.weightLogInfo_merged ORDER BY WeightPounds DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 294.317 pounds followed by 199.959 pounds. 
		The difference between these values is about 94 pounds. This seems to be large in comparison with differences between other values. 
		It could potentially be an outlier. This value is at Row_id = 3. It will not be removed from the table but will
		be noted. If analysis is conducted without this value, the table will be first copied, and then this value will be removed from the copy*/ 

	/*5f) Check all values are greater than 0*/
	SELECT Row_id, WeightPounds FROM bellabeat.dbo.weightLogInfo_merged WHERE WeightPounds < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*Fat Column*/

	/*6a) Check for blanks and NULL values*/
	SELECT Row_id, Fat FROM bellabeat.dbo.weightLogInfo_merged WHERE Fat = '' OR Fat IS NULL
		/*RESULTS RETURNED: 65 rows in this column contain cells with blanks or NULL values. Since this data set consists
		of respondents entering data themselves, these could have been left empty intentionally as respodnents had no values to enter.
		These rows will not be removed but will be noted. If analysis is done that excludes these values, a copy of the table will be made and values
		then removed from the copy. This original table will remain as is*/

	/*6b) Check for extra spaces*/
	SELECT Row_id, Fat FROM bellabeat.dbo.weightLogInfo_merged WHERE Fat LIKE ' %' OR Fat LIKE '% ' OR Fat LIKE '% %'
		/*RESULTS RETURNED: Of the cells containing values, none contain extra spaces*/

	/*6c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id, Fat FROM bellabeat.dbo.weightLogInfo_merged WHERE Fat LIKE '%[^0-9]%'
		/*RESULTS RETURNED: Of the cells containing values, none contain extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*6d) Check for outliers towards the lower values*/
	SELECT Row_id, Fat FROM bellabeat.dbo.weightLogInfo_merged ORDER BY Fat
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is approximately 0 and is not considered an outlier value
		given that many of the cells are empty/have blank values. This column does not have unusual values*/

	/*6e) Check for outliers toward the higher values*/
	SELECT Row_id, Fat FROM bellabeat.dbo.weightLogInfo_merged ORDER BY Fat DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 25 followed by 22. These are the only non zero values in this column.
		These are not considered outlier values*/ 

	/*6f) Check all values are greater than 0*/
	SELECT Row_id, Fat FROM bellabeat.dbo.weightLogInfo_merged WHERE Fat < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*BMI Column*/

	/*7a) Check for blanks and NULL values*/
	SELECT Row_id, BMI FROM bellabeat.dbo.weightLogInfo_merged WHERE BMI = '' OR BMI IS NULL
		/*RESULTS RETURNED: None. Column contains no cells with blank or NULL values*/

	/*7b) Check for extra spaces*/
	SELECT Row_id, BMI FROM bellabeat.dbo.weightLogInfo_merged WHERE BMI LIKE ' %' OR BMI LIKE '% ' OR BMI LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no cells with extra spaces*/

	/*7c) Check for cells containing extra characters and symbols. Column should only contain numbers and the decimal point - "."*/
	SELECT Row_id, BMI FROM bellabeat.dbo.weightLogInfo_merged WHERE BMI LIKE '%[^.0-9]%'
		/*RESULTS RETURNED: None. Column contains no cells with extra characters or symbols*/

	/*CHANGE DATA TYPE TO FLOAT*/

	/*7d) Check for outliers towards the lower values*/
	SELECT Row_id, BMI FROM bellabeat.dbo.weightLogInfo_merged ORDER BY BMI
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is approximately 21.45 and is not considered an outlier value.
		This column does not have unusual values*/

	/*7e) Check for outliers toward the higher values*/
	SELECT Row_id, BMI FROM bellabeat.dbo.weightLogInfo_merged ORDER BY BMI DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 47.54 followed by 28. These are not considered outliers.  
		This column does not have unusual values*/ 

	/*7f) Check all values are greater than 0*/
	SELECT Row_id, BMI FROM bellabeat.dbo.weightLogInfo_merged WHERE BMI < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*IsManualReport Column*/

	/*8a) Check for blanks and NULL values*/
	SELECT Row_id, IsManualReport  FROM bellabeat.dbo.weightLogInfo_merged WHERE IsManualReport = '' OR IsManualReport IS NULL
		/*RESULTS RETURNED: None. Column contains no cells with blank or NULL values*/

	/*8b) Check for extra spaces*/
	SELECT Row_id, IsManualReport FROM bellabeat.dbo.weightLogInfo_merged WHERE IsManualReport LIKE ' %' OR IsManualReport LIKE '% ' OR IsManualReport LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no cells with extra spaces*/

	/*8c) Check for cells containing extra characters and symbols. Column should only contain numbers and the letters in "TRUE" and "FALSE"*/
	SELECT Row_id, IsManualReport FROM bellabeat.dbo.weightLogInfo_merged WHERE IsManualReport LIKE '%[^TRUEFALSE]%'
		/*RESULTS RETURNED: None. Column contains no cells with extra characters or symbols*/

	/*DO NOT CHANGE DATA TYPE*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*LogId Column*/

	/*9a) Check for blanks and NULL values*/
	SELECT Row_id, LogId FROM bellabeat.dbo.weightLogInfo_merged WHERE LogId = '' OR LogId IS NULL
		/*RESULTS RETURNED: None. Column contains no cells with blank or NULL values*/

	/*9b) Check for extra spaces*/
	SELECT Row_id, LogId FROM bellabeat.dbo.weightLogInfo_merged WHERE LogId LIKE ' %' OR LogId LIKE '% ' OR LogId LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no cells with extra spaces*/

	/*9c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id, LogId FROM bellabeat.dbo.weightLogInfo_merged WHERE LogId LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no cells with extra characters or symbols*/

	/*9d) Check number of unique Id's representing respondents*/
	SELECT DISTINCT LogId FROM bellabeat.dbo.weightLogInfo_merged
		/*RESULTS RETURNED: Column contains 56 unique Log Id's*/

	/*9e) Check Id length. Should all be equal to 13*/
	SELECT LEN(LogId) FROM bellabeat.dbo.weightLogInfo_merged WHERE LEN(LogId) <> 13
		/*RESULTS RETURNED: None. Column contains no cells where string lenght of Id is not 13*/

	/*DO NOT CHANGE DATA TYPE. LEAVE AS VARCHAR*/

/*Cleaning Complete*/


