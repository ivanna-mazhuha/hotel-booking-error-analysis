/*
=========================================================
Question 1
What does the raw data actually look like?
=========================================================
*/
SELECT * 
FROM errors_march 
LIMIT 5;

/*
Conclusion:
Initial look at the raw data shows 12 columns including booking dates,
provider/hotel identifiers, error codes and messages, and price.
Some columns (e.g. Price, message) show visible formatting 
inconsistencies.
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
Combining the three monthly tables into a single dataset
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
