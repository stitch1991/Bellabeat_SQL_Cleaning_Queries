
/*Cleaning Process For dailyActivity_merged Table*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

/*Cleaning for entire table*/

	/*1a) Add Primary Key column to table*/

	/*Create a new column called Row_id that is filled with a consective number series. 
	Assign this column to be the Primary Key*/
	ALTER TABLE bellabeat.dbo.dailyActivity_merged ADD Row_id INT IDENTITY(1,1)
	SELECT * FROM bellabeat.dbo.dailyActivity_merged

	/*1b) Check for NULLS*/
	SELECT
	Id,  
	ActivityDate, 
	TotalSteps, 
	TotalDistance, 
	TrackerDistance, 
	LoggedActivitiesDistance, 
	VeryActiveDistance, 
	ModeratelyActiveDistance,
	LightActiveDistance,
	SedentaryActiveDistance,
	VeryActiveMinutes, 
	FairlyActiveMinutes, 
	LightlyActiveMinutes, 
	SedentaryMinutes, 
	Calories,
	Row_id
	FROM
	bellabeat.dbo.dailyActivity_merged
	WHERE
	Id is NULL OR 
	ActivityDate is NULL OR
	TotalSteps is NULL OR
	TotalDistance is NULL OR
	TrackerDistance is NULL OR
	LoggedActivitiesDistance is NULL OR
	VeryActiveDistance is NULL OR
	ModeratelyActiveDistance is NULL OR
	LightActiveDistance is NULL OR
	SedentaryActiveDistance is NULL OR
	VeryActiveMinutes is NULL OR
	FairlyActiveMinutes is NULL OR
	LightlyActiveMinutes is NULL OR
	SedentaryMinutes is NULL OR
	Calories is NULL OR
	Row_id is NULL
		/*RESULTS RETURNED: None. Table contains no NULL fields*/

	/*1c) Check for blank fields/empty strings*/
	SELECT
	Id,  
	ActivityDate, 
	TotalSteps, 
	TotalDistance, 
	TrackerDistance, 
	LoggedActivitiesDistance, 
	VeryActiveDistance, 
	ModeratelyActiveDistance,
	LightActiveDistance,
	SedentaryActiveDistance,
	VeryActiveMinutes, 
	FairlyActiveMinutes, 
	LightlyActiveMinutes, 
	SedentaryMinutes, 
	Calories,
	Row_id
	FROM
	bellabeat.dbo.dailyActivity_merged
	WHERE
	Id = '' OR 
	ActivityDate = '' OR
	TotalSteps = '' OR
	TotalDistance = '' OR
	TrackerDistance = '' OR
	LoggedActivitiesDistance = '' OR
	VeryActiveDistance = '' OR
	ModeratelyActiveDistance = '' OR
	LightActiveDistance = '' OR
	SedentaryActiveDistance = '' OR
	VeryActiveMinutes = '' OR
	FairlyActiveMinutes = '' OR
	LightlyActiveMinutes = '' OR
	SedentaryMinutes = '' OR
	Calories = '' OR 
	Row_id = ''
		/*RESULTS RETURNED: None. Table contains no blank fields/empty strings*/

	/*1d) Check for duplicate rows. Exclude Primary Key column to ensure duplicate results are returned*/
	SELECT
	Id,  
	ActivityDate, 
	TotalSteps, 
	TotalDistance, 
	TrackerDistance, 
	LoggedActivitiesDistance, 
	VeryActiveDistance, 
	ModeratelyActiveDistance,
	LightActiveDistance,
	SedentaryActiveDistance,
	VeryActiveMinutes, 
	FairlyActiveMinutes, 
	LightlyActiveMinutes, 
	SedentaryMinutes, 
	Calories, 
	COUNT(*)
	FROM bellabeat.dbo.dailyActivity_merged
	GROUP BY
	Id,  
	ActivityDate, 
	TotalSteps, 
	TotalDistance, 
	TrackerDistance, 
	LoggedActivitiesDistance, 
	VeryActiveDistance, 
	ModeratelyActiveDistance,
	LightActiveDistance,
	SedentaryActiveDistance,
	VeryActiveMinutes, 
	FairlyActiveMinutes, 
	LightlyActiveMinutes, 
	SedentaryMinutes, 
	Calories
	HAVING COUNT(*) > 1
		/*RESULTS RETURNED: None. Table contains no duplicate rows*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

/*Column-By-Column Cleaning*/

	/*Id Column*/

	/*2a) Check for blank fields and NULLS*/
	SELECT Row_id, Id FROM bellabeat.dbo.dailyActivity_merged WHERE Id = '' OR Id IS NULL
		/*RESULTS RETURNED: None. Column contains no blank fields or NULL values*/

	/*2b) Check for extra spaces*/
	SELECT Row_id, Id FROM bellabeat.dbo.dailyActivity_merged WHERE Id LIKE ' %' OR Id LIKE '% ' OR Id LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*2c) Check for cells containing extra characters and symbols. Column should only contain numbers*/
	SELECT Row_id, Id FROM bellabeat.dbo.dailyActivity_merged WHERE Id LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*2d) Check that there are 33 unique Id's representing 33 respondents*/
	SELECT DISTINCT Id FROM bellabeat.dbo.dailyActivity_merged
		/*RESULTS RETURNED: Column does contain 33 unique Id's*/

	/*2e) Check Id length. Should all be equal to 10*/
	SELECT LEN(Id) FROM bellabeat.dbo.dailyActivity_merged WHERE LEN(Id) <> 10
		/*RESULTS RETURNED: None. Column contains no cells where string lenght of Id is not 10*/

	/*No change of data type. Leave as VARCHAR data type*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*ActivityDate Column*/

	/*3a) Check for blank cells and NULL values*/
	SELECT Row_id, ActivityDate FROM bellabeat.dbo.dailyActivity_merged WHERE ActivityDate = '' OR ActivityDate IS NULL
		/*RESULTS RETURNED: None. Column contains no blank fields or NULL values*/

	/*3b) Check for extra spaces*/
	SELECT Row_id, ActivityDate FROM bellabeat.dbo.dailyActivity_merged WHERE ActivityDate LIKE ' %' OR ActivityDate LIKE '% ' OR ActivityDate LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*3c) Check for cells containing extra characters and symbols. Column should only contain numbers and the '/' symbol to separate day, month and year*/
	SELECT Row_id, ActivityDate FROM bellabeat.dbo.dailyActivity_merged WHERE ActivityDate LIKE '%[^/0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*3d) Check for cells NOT containing exactly 2 "-"s. Given the date format, there should be exactly 2 "-"'s in each cell*/
	SELECT Row_id, ActivityDate FROM bellabeat.dbo.dailyActivity_merged WHERE ActivityDate NOT LIKE '%-%-%'
		/*RESULTS RETURNED: None. Column contains no cells where there are not exactly 2 "-"s*/

	/*3e) Check that year = 2016*/
	SELECT Row_id, YEAR(ActivityDate) FROM bellabeat.dbo.dailyActivity_merged WHERE YEAR(ActivityDate) <> 2016
		/*RESULTS RETURNED: None. Column contains no cells where year is not 2016*/

	/*3f) Check that month is either April or May. Data was collected only in those 2 months*/
	SELECT Row_id, MONTH(ActivityDate) FROM bellabeat.dbo.dailyActivity_merged WHERE MONTH(ActivityDate) <> 4 AND MONTH(ActivityDate) <> 5
		/*RESULTS RETURNED: None. Column contains no cells where month is not April nor May*/
	
	/*3g) Check that day is not greater than 31. There are only 30/31 days in a month*/
	SELECT Row_id, DAY(ActivityDate) FROM bellabeat.dbo.dailyActivity_merged WHERE DAY(ActivityDate) > 31
		/*RESULTS RETURNED: None. Column contains no cells where day is greater than 31*/

	/*UPDATE TO DATE FORMAT*/

	/*3h) Check the date range. Date should be between 04/12/2016 and 05/12/2016, inclusive.
	Earliest date should be 04/12/2016*/
	SELECT MIN(ActivityDate) FROM bellabeat.dbo.dailyActivity_merged
		/*RESULTS RETURNED: 2016-04-12. This is the column's earliest date, which is correct*/

	/*3i) Latest date should be 05/12/2016*/
	SELECT MAX(ActivityDate) FROM bellabeat.dbo.dailyActivity_merged
		/*RESULTS RETURNED: 2016-05-12. This is the column's latest date, which is correct:*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*TotalSteps Column*/

	/*4a) Check for blanks and NULL values*/
	SELECT Row_id, TotalSteps FROM bellabeat.dbo.dailyActivity_merged WHERE TotalSteps = '' OR TotalSteps IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*4b) Check for extra spaces*/
	SELECT Row_id, TotalSteps FROM bellabeat.dbo.dailyActivity_merged WHERE TotalSteps LIKE ' %' OR TotalSteps LIKE '% ' OR TotalSteps LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*4c) Check for cells containing extra characters and symbols. Column should only contain numeric digits*/
	SELECT Row_id, TotalSteps FROM bellabeat.dbo.dailyActivity_merged WHERE TotalSteps LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*4d) Check for outliers towards the lower values*/
	SELECT Row_id, TotalSteps FROM bellabeat.dbo.dailyActivity_merged ORDER BY TotalSteps
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*4e) Check for outliers toward the higher values*/
	SELECT Row_id, TotalSteps FROM bellabeat.dbo.dailyActivity_merged ORDER BY TotalSteps DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 36019 followed by 29326. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*4f) Check all values are greater than 0*/
	SELECT Row_id, TotalSteps FROM bellabeat.dbo.dailyActivity_merged WHERE TotalSteps < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*TotalDistance Column*/

	/*5a) Check for blanks and NULL values*/
	SELECT Row_id, TotalDistance FROM bellabeat.dbo.dailyActivity_merged WHERE TotalDistance = '' OR TotalDistance IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*5b) Check for extra spaces*/
	SELECT Row_id, TotalDistance FROM bellabeat.dbo.dailyActivity_merged WHERE TotalDistance LIKE ' %' OR TotalDistance LIKE '% ' OR TotalDistance LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*5c) Check for cells containing extra characters and symbols. Column should only contain numeric digits and "." for decimal notation*/
	SELECT Row_id, TotalDistance FROM bellabeat.dbo.dailyActivity_merged WHERE TotalDistance LIKE '%[^.0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO FLOAT*/

	/*5d) Check for outliers towards the lower values*/
	SELECT Row_id, TotalDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY TotalDistance
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*5e) Check for outliers toward the higher values*/
	SELECT Row_id, TotalDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY TotalDistance DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 28.03000069 followed by 26.71999931. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*5f) Check all values are greater than 0 since this is measuring distance covered*/
	SELECT Row_id, TotalDistance FROM bellabeat.dbo.dailyActivity_merged WHERE TotalDistance < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*TrackerDistance Column*/

	/*6a) Check for blanks and NULL values*/
	SELECT Row_id, TrackerDistance FROM bellabeat.dbo.dailyActivity_merged WHERE TrackerDistance = '' OR TrackerDistance IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*6b) Check for extra spaces*/
	SELECT Row_id, TrackerDistance FROM bellabeat.dbo.dailyActivity_merged WHERE TrackerDistance LIKE ' %' OR TrackerDistance LIKE '% ' OR TrackerDistance LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*6c) Check for cells containing extra characters and symbols. Column should only contain numeric digits and "." for decimal notation*/
	SELECT Row_id, TrackerDistance FROM bellabeat.dbo.dailyActivity_merged WHERE TrackerDistance LIKE '%[^.0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO FLOAT*/

	/*6d) Check for outliers towards the lower values*/
	SELECT Row_id, TrackerDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY TrackerDistance
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*6e) Check for outliers toward the higher values*/
	SELECT Row_id, TrackerDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY TrackerDistance DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 28.03000069 followed by 26.71999931. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*6f) Check all values are greater than 0 since this is measuring distance covered*/
	SELECT Row_id, TrackerDistance FROM bellabeat.dbo.dailyActivity_merged WHERE TrackerDistance < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*LoggedActivitiesDistance Column*/

	/*7a) Check for blanks and NULL values*/
	SELECT Row_id, LoggedActivitiesDistance FROM bellabeat.dbo.dailyActivity_merged WHERE LoggedActivitiesDistance = '' OR LoggedActivitiesDistance IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*7b) Check for extra spaces*/
	SELECT Row_id, LoggedActivitiesDistance FROM bellabeat.dbo.dailyActivity_merged WHERE LoggedActivitiesDistance LIKE ' %' OR LoggedActivitiesDistance LIKE '% ' OR LoggedActivitiesDistance LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*7c) Check for cells containing extra characters and symbols. Column should only contain numeric digits and "." for decimal notation*/
	SELECT Row_id, LoggedActivitiesDistance FROM bellabeat.dbo.dailyActivity_merged WHERE LoggedActivitiesDistance LIKE '%[^.0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO FLOAT*/

	/*7d) Check for outliers towards the lower values*/
	SELECT Row_id, LoggedActivitiesDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY LoggedActivitiesDistance
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*7e) Check for outliers toward the higher values*/
	SELECT Row_id, LoggedActivitiesDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY LoggedActivitiesDistance DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 28.03000069 followed by 26.71999931. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*7f) Check all values are greater than 0 since this is measuring distance covered*/
	SELECT Row_id, LoggedActivitiesDistance FROM bellabeat.dbo.dailyActivity_merged WHERE LoggedActivitiesDistance < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*VeryActiveDistance Column*/

	/*8a) Check for blanks and NULL values*/
	SELECT Row_id, VeryActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE VeryActiveDistance = '' OR VeryActiveDistance IS NULL
		/*RESULTS RETURNED: Column does not contain cells with blanks or NULL values*/

	/*8b) Check for extra spaces*/
	SELECT Row_id, VeryActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE VeryActiveDistance LIKE ' %' OR VeryActiveDistance LIKE '% ' OR VeryActiveDistance LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*8c) Check for cells containing extra characters and symbols. Column should only contain numeric digits and "." for decimal notation*/
	SELECT Row_id, VeryActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE VeryActiveDistance LIKE '%[^.0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO FLOAT*/

	/*8d) Check for outliers towards the lower values*/
	SELECT Row_id, VeryActiveDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY VeryActiveDistance
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*8e) Check for outliers toward the higher values*/
	SELECT Row_id, VeryActiveDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY VeryActiveDistance DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 21.92000008 followed by 21.65999985. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*8f) Check all values are greater than 0 since this is measuring distance covered*/
	SELECT Row_id, VeryActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE VeryActiveDistance < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*ModeratelyActiveDistance Column*/

	/*9a) Check for blanks and NULL values*/
	SELECT Row_id, ModeratelyActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE ModeratelyActiveDistance = '' OR ModeratelyActiveDistance IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*9b) Check for extra spaces*/
	SELECT Row_id, ModeratelyActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE ModeratelyActiveDistance LIKE ' %' OR ModeratelyActiveDistance LIKE '% ' OR ModeratelyActiveDistance LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*9c) Check for cells containing extra characters and symbols. Column should only contain numeric digits and "." for decimal notation*/
	SELECT Row_id, ModeratelyActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE ModeratelyActiveDistance LIKE '%[^.0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO FLOAT*/

	/*9d) Check for outliers towards the lower values*/
	SELECT Row_id, ModeratelyActiveDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY ModeratelyActiveDistance
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*9e) Check for outliers toward the higher values*/
	SELECT Row_id, ModeratelyActiveDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY ModeratelyActiveDistance DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 6.480000019 followed by 6.210000038. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*9f) Check all values are greater than 0 since this is measuring distance covered*/
	SELECT Row_id, ModeratelyActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE ModeratelyActiveDistance < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*LightActiveDistance Column*/

	/*10a) Check for blanks and NULL values*/
	SELECT Row_id, LightActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE LightActiveDistance = '' OR LightActiveDistance IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*10b) Check for extra spaces*/
	SELECT Row_id, LightActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE LightActiveDistance LIKE ' %' OR LightActiveDistance LIKE '% ' OR LightActiveDistance LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*10c) Check for cells containing extra characters and symbols. Column should only contain numeric digits and "." for decimal notation*/
	SELECT Row_id, LightActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE LightActiveDistance LIKE '%[^.0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO FLOAT*/

	/*10d) Check for outliers towards the lower values*/
	SELECT Row_id, LightActiveDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY LightActiveDistance
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*10e) Check for outliers toward the higher values*/
	SELECT Row_id, LightActiveDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY LightActiveDistance DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 10.71000004 followed by 10.56999969. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*10f) Check all values are greater than 0 since this is measuring distance covered*/
	SELECT Row_id, LightActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE LightActiveDistance < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*SedentaryActiveDistance Column*/

	/*11a) Check for blanks and NULL values*/
	SELECT Row_id, SedentaryActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE  SedentaryActiveDistance = '' OR  SedentaryActiveDistance IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*11b) Check for extra spaces*/
	SELECT Row_id, SedentaryActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE SedentaryActiveDistance LIKE ' %' OR SedentaryActiveDistance LIKE '% ' OR SedentaryActiveDistance LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*11c) Check for cells containing extra characters and symbols. Column should only contain numeric digits and "." for decimal notation*/
	SELECT Row_id, SedentaryActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE SedentaryActiveDistance LIKE '%[^.0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO FLOAT*/

	/*11d) Check for outliers towards the lower values*/
	SELECT Row_id, SedentaryActiveDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY SedentaryActiveDistance
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*11e) Check for outliers toward the higher values*/
	SELECT Row_id, SedentaryActiveDistance FROM bellabeat.dbo.dailyActivity_merged ORDER BY SedentaryActiveDistance DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 0.109999999 followed by 0.100000001. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*11f) Check all values are greater than 0 since this is measuring distance covered*/
	SELECT Row_id, SedentaryActiveDistance FROM bellabeat.dbo.dailyActivity_merged WHERE SedentaryActiveDistance < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*VeryActiveMinutes Column*/

	/*12a) Check for blanks and NULL values*/
	SELECT Row_id, VeryActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE VeryActiveMinutes = '' OR  VeryActiveMinutes IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*12b) Check for extra spaces*/
	SELECT Row_id, VeryActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE VeryActiveMinutes LIKE ' %' OR VeryActiveMinutes LIKE '% ' OR VeryActiveMinutes LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*12c) Check for cells containing extra characters and symbols. Column should only contain numeric digits*/
	SELECT Row_id, VeryActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE VeryActiveMinutes LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*12d) Check for outliers towards the lower values*/
	SELECT Row_id, VeryActiveMinutes FROM bellabeat.dbo.dailyActivity_merged ORDER BY VeryActiveMinutes
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*12e) Check for outliers toward the higher values*/
	SELECT Row_id, VeryActiveMinutes FROM bellabeat.dbo.dailyActivity_merged ORDER BY VeryActiveMinutes DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 210 followed by 207. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*12f) Check all values are greater than 0 since this is measuring time duration*/
	SELECT Row_id, VeryActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE VeryActiveMinutes < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*FairlyActiveMinutes Column*/

	/*13a) Check for blanks and NULL values*/
	SELECT Row_id, FairlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE  FairlyActiveMinutes = '' OR  FairlyActiveMinutes IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*13b) Check for extra spaces*/
	SELECT Row_id, FairlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE FairlyActiveMinutes LIKE ' %' OR FairlyActiveMinutes LIKE '% ' OR FairlyActiveMinutes LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*13c) Check for cells containing extra characters and symbols. Column should only contain numeric digits*/
	SELECT Row_id, FairlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE FairlyActiveMinutes LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*13d) Check for outliers towards the lower values*/
	SELECT Row_id, FairlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged ORDER BY FairlyActiveMinutes
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*13e) Check for outliers toward the higher values*/
	SELECT Row_id, FairlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged ORDER BY FairlyActiveMinutes DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 143 followed by 125. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*13f) Check all values are greater than 0 since this is measuring time duration*/
	SELECT Row_id, FairlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE FairlyActiveMinutes < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*LightlyActiveMinutes Column*/

	/*14a) Check for blanks and NULL values*/
	SELECT Row_id, LightlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE  LightlyActiveMinutes = '' OR  LightlyActiveMinutes IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*14b) Check for extra spaces*/
	SELECT Row_id, LightlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE LightlyActiveMinutes LIKE ' %' OR LightlyActiveMinutes LIKE '% ' OR LightlyActiveMinutes LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*14c) Check for cells containing extra characters and symbols. Column should only contain numeric digits*/
	SELECT Row_id, LightlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE LightlyActiveMinutes LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*14d) Check for outliers towards the lower values*/
	SELECT Row_id, LightlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged ORDER BY LightlyActiveMinutes
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*14e) Check for outliers toward the higher values*/
	SELECT Row_id, LightlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged ORDER BY LightlyActiveMinutes DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 518 followed by 513. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*14f) Check all values are greater than 0 since this is measuring time duration*/
	SELECT Row_id, LightlyActiveMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE LightlyActiveMinutes < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/


/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*SedentaryMinutes Column*/

	/*15a) Check for blanks and NULL values*/
	SELECT Row_id, SedentaryMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE SedentaryMinutes = '' OR  SedentaryMinutes IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*15b) Check for extra spaces*/
	SELECT Row_id, SedentaryMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE SedentaryMinutes LIKE ' %' OR SedentaryMinutes LIKE '% ' OR SedentaryMinutes LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*15c) Check for cells containing extra characters and symbols. Column should only contain digits*/
	SELECT Row_id, SedentaryMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE SedentaryMinutes LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*15d) Check for outliers towards the lower values*/
	SELECT Row_id, SedentaryMinutes FROM bellabeat.dbo.dailyActivity_merged ORDER BY SedentaryMinutes
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*15e) Check for outliers toward the higher values*/
	SELECT Row_id, SedentaryMinutes FROM bellabeat.dbo.dailyActivity_merged ORDER BY SedentaryMinutes DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 1440 followed by 1440. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*15f) Check all values are greater than 0 since this is measuring time duration*/
	SELECT Row_id, SedentaryMinutes FROM bellabeat.dbo.dailyActivity_merged WHERE SedentaryMinutes < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

	/*Calories Column*/

	/*16a) Check for blanks and NULL values*/
	SELECT Row_id, Calories FROM bellabeat.dbo.dailyActivity_merged WHERE Calories = '' OR   Calories IS NULL
		/*RESULTS RETURNED: None. Column does not contain cells with blanks or NULL values*/

	/*16b) Check for extra spaces*/
	SELECT Row_id, Calories FROM bellabeat.dbo.dailyActivity_merged WHERE Calories LIKE ' %' OR  Calories LIKE '% ' OR  Calories LIKE '% %'
		/*RESULTS RETURNED: None. Column contains no extra spaces*/

	/*16c) Check for cells containing extra characters and symbols. Column should only contain digits*/
	SELECT Row_id, Calories FROM bellabeat.dbo.dailyActivity_merged WHERE Calories LIKE '%[^0-9]%'
		/*RESULTS RETURNED: None. Column contains no extra characters or symbols*/

	/*CHANGE DATA TYPE TO INT*/

	/*16d) Check for outliers towards the lower values*/
	SELECT Row_id, Calories FROM bellabeat.dbo.dailyActivity_merged ORDER BY Calories
		/*RESULTS RETURNED: Column values in Ascending order. Lowest value is 0 and is not considered an outlier value.
		This column does not have unusual values*/

	/*16e) Check for outliers toward the higher values*/
	SELECT Row_id, Calories FROM bellabeat.dbo.dailyActivity_merged ORDER BY Calories DESC
		/*RESULTS RETURNED: Column values in Descending order. Highest value is 4900 followed by 4552. 
		These values are not considered outliers. This column does not have unusual values*/ 

	/*16f) Check all values are greater than 0 since this is measuring time duration*/
	SELECT Row_id, Calories FROM bellabeat.dbo.dailyActivity_merged WHERE Calories < 0
		/*RESULTS RETURNED: Column contains no cells with values less than 0*/

/*Cleaning Complete*/