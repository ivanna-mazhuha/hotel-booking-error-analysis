/*
Project: Hotel Booking Error Analysis
Purpose: Initial SQL exploration of raw booking error data before 
         cleaning in Power Query and modeling in Power BI.
Tool: DuckDB
*/

/*
=========================================================
Question 1
What does the raw data actually look like?
=========================================================
*/
SELECT * 
FROM errors_march 
LIMIT 5;

SELECT *
FROM hotels
LIMIT 5;

SELECT *
FROM providers
LIMIT 5;

/*
Conclusion:
Initial look at the raw data shows that table errors_march has 12 columns 
including booking dates, provider/hotel identifiers, error codes and messages, and price.
Some columns (e.g. Price, message) show visible formatting inconsistencies.

Hotels table contains hotel attributes, including hotel name,
provider name, country, region, city, and star rating.

Providers table maps each ProviderID to a company name and its primary destination.
Each provider is linked to a single primary destination country.

These datasets will be joined to enrich the analysis with geographical and provider information.
*/

/*
=========================================================
Question 2
Are the three monthly files structurally compatible for merging?
=========================================================

*/

DESCRIBE errors_march;
DESCRIBE errors_april;
DESCRIBE errors_may;

/*
Conclusion:
All three monthly files have identical column names, column order,
and data types (12 columns each). The only observation is that
the Price column was imported as VARCHAR rather than a numeric type,
which will require cleaning before analysis.

The datasets can be safely combined using UNION ALL.
*/

/*
=========================================================
Creating a unified analytical table
=========================================================
*/
CREATE TABLE errors_all AS
SELECT * FROM errors_march
UNION ALL
SELECT * FROM errors_april
UNION ALL
SELECT * FROM errors_may;

SELECT COUNT(*) AS total_rows 
FROM errors_all;

/*
Conclusion:
The three monthly datasets were successfully combined into a single
table containing 5,075 booking error records.

This unified table will be used for all subsequent exploration and
data quality analysis.
*/
/*
=========================================================
Question 3
What time period does the dataset cover?
=========================================================
*/
SELECT MIN(Date) AS earliest_date,
       MAX(Date) AS latest_date,
       COUNT(*) AS total_rows
FROM errors_all;

/*
Conclusion:
The dataset covers booking errors recorded between March 1, 2026
and May 31, 2026, matching the expected three-month reporting period.
*/
/*
=========================================================
Question 4
What information is available for analysis?
=========================================================
*/
SELECT COUNT(DISTINCT providerid) AS providers,
       COUNT(DISTINCT hotelid) AS hotels,
       COUNT(DISTINCT no) AS error_types
FROM errors_all;

/*
Conclusion:
The dataset contains booking errors from 8 travel providers,
covering 492 hotels and 9 distinct error types.

This provides sufficient coverage for provider-, hotel-, and
error-level analysis.
*/
/*
=========================================================
Question 5
Are there missing values across all columns?
=========================================================
*/
SELECT
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN tripid IS NULL THEN 1 ELSE 0 END) AS missing_tripid,
    SUM(CASE WHEN ClientEmail IS NULL OR ClientEmail = '' THEN 1 ELSE 0 END) AS missing_email,
    SUM(CASE WHEN startdate IS NULL THEN 1 ELSE 0 END) AS missing_startdate,
    SUM(CASE WHEN enddate IS NULL THEN 1 ELSE 0 END) AS missing_enddate,
    SUM(CASE WHEN providerid IS NULL THEN 1 ELSE 0 END) AS missing_providerid,
    SUM(CASE WHEN hotelcode IS NULL OR hotelcode = '' THEN 1 ELSE 0 END) AS missing_hotelcode,
    SUM(CASE WHEN hotelid IS NULL THEN 1 ELSE 0 END) AS missing_hotelid,
    SUM(CASE WHEN no IS NULL THEN 1 ELSE 0 END) AS missing_error_id,
    SUM(CASE WHEN message IS NULL OR message = '' THEN 1 ELSE 0 END) AS missing_message,
    SUM(CASE WHEN Hotelname IS NULL OR Hotelname = '' THEN 1 ELSE 0 END) AS missing_hotelname,
    SUM(CASE WHEN Price IS NULL OR Price = '' THEN 1 ELSE 0 END) AS missing_price
FROM errors_all;

/*
Conclusion:
Checked all 12 columns for missing values. Only no, Hotelname, Price showed missing data 
(45, 155, 190 rows respectively) — these will require handling before analysis. 
All other columns are fully populated.
*/
/*
=========================================================
Question 6
Are there any fully duplicated booking records?
=========================================================
*/

SELECT
    Date,
    tripid,
    ClientEmail,
    startdate,
    enddate,
    providerid,
    hotelcode,
    hotelid,
    no,
    message,
    Hotelname,
    Price,
    COUNT(*) AS duplicate_count
FROM errors_all
GROUP BY
    Date,
    tripid,
    ClientEmail,
    startdate,
    enddate,
    providerid,
    hotelcode,
    hotelid,
    no,
    message,
    Hotelname,
    Price
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

/*
Conclusion:
75 fully duplicated booking records were identified across all 12 columns.
Since the dataset contains only booking dates (without timestamps), 
it is not possible to determine whether these records represent duplicate log entries
or legitimate repeated booking attempts.
*/


