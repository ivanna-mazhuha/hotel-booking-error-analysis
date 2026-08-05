# Hotel Booking Error Analysis

## 📌 Project Overview
Power BI dashboard analyzing failed hotel booking attempts across 8 travel providers, built to identify where booking errors concentrate and support prioritized investigation. This is a synthetic dataset designed to closely resemble a real booking-error log.

## 🎯 Business Question
Which providers, countries, and error types generate the most booking failures — by volume and financial impact — and where should investigation be prioritized first?

## 💡 Key Insights
- The problem is concentrated, not evenly spread. The top 3 investigation areas — allotment synchronization (SunInternational Online, Summer Tour, Hotelbeds), stop-sale downloads, and pricing updates — account for approximately 35% of all booking errors, despite involving only 3 of 8 providers.
- A single combination stands out: SunInternational Online in Egypt ("Not enough allotment") accounts for 277 failed attempts alone — the largest single concentration in the dataset, representing 5.5% of all errors and €590K in affected booking value.
- Errors are not concentrated in specific hotels. The top 10 hotels by error count show similar volumes (28–32 errors each), with no clear outlier property — indicating the issue is systemic at the provider/integration level rather than isolated to specific hotels.
- Total financial exposure: failed booking attempts across the 3-month period represent approximately €10.81M in booking value across all 8 providers.

## 📈 Dashboard Pages
### Overview
<img width="1397" height="785" alt="image" src="https://github.com/user-attachments/assets/91132970-a4c1-4974-83cd-d4f4de61e8b0" />
High-level KPIs (Total Errors, Financial Impact, Active Providers, Affected Hotels, Avg Booking Price), monthly error trend, error distribution by provider and error type.

### Root Cause Analysis
<img width="1395" height="782" alt="image" src="https://github.com/user-attachments/assets/fa6ede58-0dee-48b5-bdf3-b44e30855990" />
Provider × Error Type matrix (heatmap), an interactive decomposition tree for drilling from total errors down to provider/country/error combinations, top hotels by error count, and financial impact by provider.

### Action Plan
<img width="1395" height="783" alt="image" src="https://github.com/user-attachments/assets/e7e5c6fb-660d-43a4-8cab-901e82c0455d" />
Ranks provider–error combinations by volume and financial impact, visualizes providers on a volume-vs-impact priority matrix, and lays out the top 3 investigation priorities with supporting figures.

## 🗂️ Data Model
The dashboard uses a star schema consisting of one fact table and four dimension tables.

<img width="1640" height="752" alt="image" src="https://github.com/user-attachments/assets/b5fa3b2b-1d26-4eb2-8411-d188488aef7f" />

- Star schema: fact table `fact_booking_errors` + dimensions `dim_hotels`, `dim_providers`, `dim_error_types`, `dim_date`
- Removed `MainDestination` from `dim_providers` to avoid duplicating geographic data already present in `dim_hotels[Country]` (single source of truth principle)
- dim_date is marked as a Date Table and linked to Reservation Date (the date the booking attempt occurred), not the trip's Start/End Date, since the analysis focuses on when errors happen, not when trips occur

## 🧹 Data Cleaning (Power Query)
- Standardized inconsistent price formats (comma decimals, "PLN" currency suffix, missing values, occasional negative values) → converted to a clean Decimal Number column.
- Cleaned mixed casing and stray whitespace in hotel/provider identifier fields.
- Standardized error messages: translated mixed Polish/English text to English, removed redundant technical prefixes (e.g. "Booking Create Error:"), and extracted clean error descriptions into a separate dimension table (`dim_error_types`).
Example transformation: "Booking Create Error: Brak możliwości założenia rezerwacji winterfejsie." → "Unable to create a reservation in interface".
- Removed a redundant hotelcode column from the fact table — Hotel ID already serves as the unique key linking to dim_hotels.
- Resolved missing Error ID values via Merge Queries against a cleaned reference table, then removed duplicate reference rows.
- Extracted unique client emails into a separate dim_client dimension table (with a surrogate Client ID), replacing raw email text in the fact table — enables accurate distinct-client counting.
- Retained fully identical rows because the source data contains dates only (no timestamps), making it impossible to distinguish between technical duplicates and genuine same-day repeat booking attempts.
- Added `Trip Length` column ([End Date] - [Start Date], set to Whole Number type — safe conversion since source columns are Date-only, no time component).

## 📊 Data Source
- Synthetic dataset simulating a real booking error log
- 3 monthly booking files (March–May 2026), ~5,000 records
- Hotel reference table (500 hotels)
- Provider reference table (8 travel providers)
Note: the dataset contains only failed booking attempts
  

## 🛠️ Tools Used
Power BI, Power Query (M), DAX

## 📁 How to Open
1. Download the .pbix file
2. Open in Power BI Desktop
