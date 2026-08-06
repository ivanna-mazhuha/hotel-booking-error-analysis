/*
Question 1
  What are the most common booking errors?
*/

SELECT
    message,
    COUNT(*) AS total_errors
FROM errors_all
GROUP BY message
ORDER BY total_errors DESC;

/* 
Conclusion:
The raw data contains 27 distinct error messages. However, the results
cannot be interpreted directly because the same business error appears
under multiple text variations (different casing, prefixes, leading spaces,
and multilingual descriptions).

Examples include:
• Not enough allotment
• NOT ENOUGH ALLOTMENT
•  Not enough allotment

These inconsistencies indicate that the raw data requires standardization
before meaningful error-level analysis can be performed.
*/
