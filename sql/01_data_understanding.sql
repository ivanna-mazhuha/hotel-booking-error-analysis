/*
=========================================================
Question 1
=========================================================

Business Question:
Are the three monthly files structurally compatible for merging?

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
