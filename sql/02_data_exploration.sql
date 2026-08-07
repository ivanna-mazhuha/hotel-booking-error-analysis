/*
=========================================================
Question 1
What are the most common booking errors?
=========================================================
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

These inconsistencies indicate that the raw data requires standardization
before meaningful error-level analysis can be performed.
*/

/*
=========================================================
Question 2
Which providers generate the most booking errors?
=========================================================
*/

SELECT
    p.CompanyName,
    COUNT(*) AS total_errors
FROM errors_all e
JOIN providers p
    ON e.providerid = p.providerid
GROUP BY p.CompanyName
ORDER BY total_errors DESC;

/*
Conclusion:

Booking errors are recorded across all eight providers.

SunInternational Online (1,091), Summer Tour (1,012), and Hotelbeds (946)
report the highest number of booking errors, while Restel (274) and Miki Travel (257)
have the lowest error counts in the dataset.

The distribution suggests noticeable differences between providers, which will be
examined further in the next analysis step.
*/

/*
=========================================================
Question 3
Are booking errors evenly distributed across providers?
=========================================================
*/

SELECT
    p.CompanyName,
    COUNT(*) AS total_errors,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM errors_all),
        2
    ) AS percentage_of_total,
    ROUND(
        SUM(COUNT(*)) OVER (ORDER BY COUNT(*) DESC) * 100.0
        / (SELECT COUNT(*) FROM errors_all),
        2
    ) AS cumulative_percentage
FROM errors_all e
JOIN providers p
    ON e.providerid = p.providerid
GROUP BY p.CompanyName
ORDER BY total_errors DESC;

/*
Conclusion:

Booking errors are not evenly distributed across providers.

The top three providers — SunInternational Online (21.5%), Summer Tour (19.94%),
and Hotelbeds (18.64%) — account for approximately 60% of all booking errors.

This indicates that booking failures are concentrated among a small number of
providers, suggesting that investigation and improvement efforts should be
prioritized on these integrations.
*/

/*
=========================================================
Question 4
How many hotels are managed by each provider?
=========================================================
*/

SELECT
    ProviderName,
    COUNT(*) AS total_hotels
FROM hotels
GROUP BY ProviderName
ORDER BY total_hotels DESC;

/*
Conclusion:

The hotel portfolio is evenly distributed across providers.

Each provider manages either 62 or 63 hotels, indicating that provider
size (measured by the number of hotels) is consistent across the dataset.

This balanced distribution allows provider-level comparisons without one
provider dominating simply because it manages substantially more hotels.
*/

/*
=========================================================
Question 5
Which hotels generate the most booking errors?
=========================================================
*/

SELECT
    h.HotelName,
    h.ProviderName,
    h.Country,
    COUNT(*) AS total_errors
FROM errors_all e
JOIN hotels h
    ON e.hotelid = h.hotelid
GROUP BY
    h.HotelName,
    h.ProviderName,
    h.Country
ORDER BY total_errors DESC
LIMIT 10;

/*
Conclusion:

The top 10 hotels have between 28 and 32 booking errors each, with no
single hotel standing out as a major outlier.

This suggests that booking failures are not concentrated in a few specific
properties, but are more likely related to provider-level integration issues.
*/


