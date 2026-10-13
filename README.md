# Hotel Revenue & Booking Performance Analytics

## Project Overview

An end-to-end Data Analytics project analyzing hotel booking demand, cancellations, customer behavior, distribution channels, and Average Daily Rate (ADR) across City Hotel and Resort Hotel.

The project follows a practical analytics workflow from Excel data preparation and MySQL data loading to SQL business analysis, Power BI dashboard development, and cross-platform KPI validation.

## Business Objectives

- Evaluate booking volume and cancellation performance across hotels.
- Analyze booking trends and seasonality across the available period.
- Identify cancellation patterns by lead time, market segment, distribution channel, and guest type.
- Compare booking behavior between City Hotel and Resort Hotel.
- Build an interactive Power BI dashboard to support business monitoring and decision-making.

## Tools & Technologies

- **Excel:** Data inspection, preparation, data quality audit, and validation.
- **Power Query:** Data cleaning, duplicate removal, missing-value handling, and analytical column creation.
- **MySQL / SQL:** Database setup, data loading, validation, exploratory analysis, and business analysis.
- **`LOAD DATA LOCAL INFILE`:** Importing the cleaned CSV file into the MySQL staging table.
- **Power BI:** Data modeling and interactive dashboard development.
- **DAX:** KPI measures, cancellation metrics, and time-based calculations.

## Dataset

The project uses the Hotel Booking Demand dataset, containing 119,390 rows and 32 columns in the original CSV used for this project.

The dataset includes bookings from City Hotel and Resort Hotel. Each row represents one booking record.

After exact duplicate removal, the analytical dataset contains **87,395 records**.

Dataset source: [Hotel Booking Demand — Kaggle](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand)

## Project Workflow

1. **Excel Data Preparation:** Audited data quality, removed exact duplicate records, handled selected missing values, and created analytical columns.
2. **MySQL Database Setup:** Created a staging table and a final analytical table.
3. **Data Loading:** Imported the cleaned CSV into MySQL using `LOAD DATA LOCAL INFILE`.
4. **SQL Data Validation:** Checked record counts, missing-value treatment, ADR quality, guest records, and room changes.
5. **SQL Exploratory & Business Analysis:** Analyzed booking trends, cancellations, lead time, market segments, distribution channels, and guest behavior.
6. **Power BI Modeling & DAX:** Connected the final analytical table, created a date table and relationships, and developed KPI measures.
7. **Dashboard Development:** Built three report pages covering executive performance, demand and cancellations, and customer, market, and estimated stay value.
8. **Cross-Platform Validation:** Compared core metrics across Excel, MySQL, and Power BI.

## Key Findings

- **87,395 bookings** remained after exact duplicate removal.
- The overall cancellation rate was **27.49%**.
- City Hotel recorded 53,428 bookings and a 30.04% cancellation rate; Resort Hotel recorded 33,967 bookings and a 23.48% cancellation rate.
- Bookings made 181+ days in advance had a 39.74% cancellation rate, compared with 8.43% for bookings made 0–7 days in advance.
- Online Travel Agency (Online TA) bookings accounted for 51,618 records and had a 35.35% cancellation rate.
- Repeated guests had a 7.64% cancellation rate, compared with 28.30% for new guests.

These are observed patterns in the dataset. They do not establish that lead time, booking channel, or guest type directly causes cancellations.

## Power BI Dashboard

The report contains three pages:

1. **Executive Overview:** Booking KPIs, hotel comparison, demand trend, and market segment analysis.
2. **Demand & Cancellation:** Monthly demand, cancellation trends, lead-time groups, market segments, and distribution channels.
3. **Customer, Market & Revenue:** Customer behavior, market performance, distribution channels, and estimated stay value.

Dashboard screenshots are provided in `PowerBI/Screenshots/`.

## Data Quality & Limitations

- Exact duplicate records were removed during preparation.
- The final analytical dataset contains 87,395 records.
- The dataset includes one negative ADR value and 1,777 zero ADR values; these are tracked through ADR quality classification.
- ADR represents Average Daily Rate, not total revenue.
- Estimated stay value is a proxy based on ADR multiplied by stay nights for completed bookings with valid ADR; it is not actual recorded revenue.
- The dataset covers partial years at the beginning and end of the observation period, so full-year comparisons require caution.
- Observed associations should not be interpreted as causal effects.

## Repository Structure

- `Excel/` — Data preparation, audit, dictionary, and validation workbook.
- `Data/` — Original and cleaned CSV files, if redistribution is permitted.
- `SQL/` — Database setup, data import, validation, exploratory analysis, and business analysis scripts.
- `PowerBI/` — Power BI report and dashboard screenshots.
- `Report/` — Final business report.

## Project Outcome

This project demonstrates an end-to-end analytical workflow combining Excel, Power Query, MySQL, SQL, Power BI, and DAX to transform booking data into validated KPIs, interactive reporting, and actionable business recommendations.