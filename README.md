# Hotel Booking Error Analysis

## 📌 Project Overview
Data analysis focused on identifying the root causes of hotel booking errors across 8 hotel providers and improving booking quality.


## 🎯 Business Question
Which providers/hotels generate the most booking failures, and what is the underlying cause, so operations can prioritize fixes.

## 📊 Data Source
- Synthetic dataset simulating a real booking error log
- 3 monthly files (March–May 2026), ~5,000 records
- Supporting dimension table: 500 hotels with provider, country, region, city, stars
- Supporting dimension table: 8 travel providers (provider ID, provider name)
- Provider details (provider name) are kept in a separate dimension table rather than embedded in the fact table, following star schema design 
  (single source of truth, avoids duplicated provider names across 5,000 rows)
  
Note: dataset contains only FAILED booking attempts — no success data, so metrics reflect error structure, not conversion rate.

## 🧹 Data Cleaning (Power Query)
- Inconsistent price formats (comma decimals, "PLN" suffix, missing values) → standardized to Decimal Number.
- Standardized error messages: translated mixed Polish/English text to English, removed redundant technical prefixes (e.g. "Booking Create 
  Error:"), and extracted clean error descriptions into a separate dimension table (`dim_error_types`).
Example transformation: "Booking Create Error: Brak możliwości założenia rezerwacji winterfejsie." → "Unable to create a reservation in interface"
- Removed `hotelcode` column from the fact table — redundant with `Hotel ID`, which already serves as the unique key linking to `dim_hotels`
- Missing Error ID values → resolved via Merge Queries with clean error reference table.
- Extracted unique client emails into a separate `dim_client` dimension table (with surrogate Client ID), replacing raw email in the fact table — enables accurate distinct-client counting and avoids duplicated email text across ~5,000 fact rows
- Identified rows that are fully identical across all fields (Trip ID, Reservation Date, Error ID, Price). Because the dataset only records
  date (not timestamp), these cannot be reliably distinguished between (a) technical log duplication or (b) a genuine same-day repeat attempt 
  by the same client. Given this ambiguity, these rows were NOT removed, to avoid understating real repeat-attempt volume.
- Added `Trip Length` column ([End Date] - [Start Date], set to Whole Number type — safe conversion since source columns are Date-only, no time component)

## 🗂️ Data Model
<img width="1596" height="732" alt="image" src="https://github.com/user-attachments/assets/2f7bd287-a607-415e-8be3-c31c9520b336" />


- Star schema: fact table `fact_booking_errors` + dimensions `dim_hotels`, `dim_providers`, `dim_error_types`, `dim_date`
- Removed `MainDestination` from `dim_providers` to avoid duplicating geographic data already present in `dim_hotels[Country]` (single source of truth principle)

## 📈 Dashboard Pages
### 1. Overview

### 2. Root Cause Analysis

### 3. Action Plan


## 💡 Key Insights
- 

## 🛠️ Tools Used
Power BI, Power Query (M), DAX

## 📁 How to Open

