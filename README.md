# ☕ Cafe Sales Analysis Using SQL

## Portfolio Case Study

Cafe Sales Analysis 

<img width="901" height="504" alt="Sales Dashboard pbi" src="https://github.com/user-attachments/assets/6f26994c-bbbf-4a51-b027-fe2c1ab8def0" />


## Executive Summary

This case study presents an end-to-end SQL analytics project conducted on a café sales dataset containing approximately 10,000 transaction records. The project demonstrates the complete analytics lifecycle, including data ingestion, data quality assessment, cleaning, transformation, exploratory data analysis (EDA), trend analysis, and business insight generation. PostgreSQL was used as the primary analytical tool.

The objective was not only to answer business questions but also to establish a repeatable data-cleaning framework capable of transforming raw operational data into a reliable source for decision-making. The project highlights practical SQL techniques including Common Table Expressions (CTEs), window functions, aggregate functions, data type conversions, statistical imputation, ranking functions, and date analysis.


## Business Problem

Cafés generate thousands of transactions over time, creating valuable data that can help managers optimize inventory, staffing, pricing strategies, promotions, and customer experience. However, business decisions based on inaccurate or incomplete data can lead to poor outcomes.

This project was designed to address three key challenges:
1. Improve data quality.
2. Identify sales and revenue patterns.
3. Generate actionable business insights from transaction data.


## Project Objectives

- Import and structure transactional sales data.
- Assess data quality issues.
- Remove inconsistencies and standardize values.
- Handle missing values using appropriate statistical methods.
- Analyze revenue performance.
- Evaluate payment method preferences.
- Identify underperforming and high-performing products.
- Analyze sales trends over time.
- Demonstrate professional SQL skills.

## Dataset Overview

- The dataset contains the following variables:
- Transaction ID: unique transaction identifier.
- Item: product purchased.
- Quantity:  number of units sold.
- Price_per_Unit: selling price of each item.
- Total Spent: total transaction amount.
- Payment Method: customer payment channel.
- Location: sales location.
- Transaction Date: date of purchase.

The dataset contained approximately 10,000 records and represented transactional activity across multiple products and locations.

## Data Quality Assessment

- A systematic review of the dataset was conducted before analysis. The assessment focused on:
- Duplicate records
- Missing values
- Invalid entries
- Data type inconsistencies
- Formatting issues
- Date quality issues

This stage established the foundation for reliable reporting and analysis.

## Duplicate Detection

Duplicate detection was performed using the ROW_NUMBER() window function. Records were partitioned across all key fields and ranked to identify exact duplicates.

The investigation confirmed that no duplicate records existed within the dataset. This result increased confidence in the reliability of subsequent analyses.


## Data Standardization

A staging view was created to standardize data. Text fields were trimmed to remove leading and trailing spaces. Blank values were converted to NULL values using NULLIF(). This step ensured consistency across all records before further cleaning activities.


## Data Cleaning Strategy

- Multiple cleaning rules were applied:

Item:
- Invalid values such as ERROR, UNKNOWN, NULL and numeric-only entries were removed.
- Missing values were replaced with 'Unknown'.

Quantity:
- Converted from text to integer.
- Missing values were replaced using the median value.

Price per Unit:
- Converted from text to numeric.
- Missing values were replaced using the mean value.

Total Spent:
- Converted from text to numeric.
- Missing values were replaced using the mean value.

Payment Method:
- Standardized using INITCAP().
- Missing values replaced with 'Unknown'.

Location:
- Invalid values corrected.
- Missing values replaced with 'Unknown'.

Transaction Date:
- Converted into DATE format.
- Missing dates filled using the previous valid transaction date.

## Missing Value Treatment

Missing value treatment was selected according to variable type. Median imputation was chosen for Quantity because it is less sensitive to outliers. Mean imputation was used for Price per Unit and Total Spent because these variables are continuous measures. Categorical variables such as Item, Payment Method, and Location were assigned the label 'Unknown' to preserve records while clearly identifying missing information.


## Exploratory Data Analysis Framework

- The EDA stage focused on answering practical business questions:
- Which day generated the highest sales?
- Which products contribute most revenue?
- Which products underperform?
- What is the largest transaction?
- Which payment method is most popular?
- Which payment method generates the most revenue?
- How does spending differ across payment methods?
- What are the daily revenue trends?
- What is the day-over-day growth rate?
- What is the long-term revenue trend?
- How does revenue change week-over-week?

## Revenue Analysis

Revenue analysis focused on understanding overall financial performance. Aggregation functions were used to identify total sales values and determine periods of exceptional performance.

The analysis enables management to identify peak business periods and evaluate operational effectiveness.


## Product Performance Analysis

- Revenue contribution by item was calculated using percentage-of-total revenue metrics.

This analysis helps identify:
- Star products.
- Core revenue drivers.
- Menu optimization opportunities.
- Products requiring promotional support.

Underperforming products were identified as items contributing less than five percent of overall revenue.

## Payment Method Analysis

Payment-method analysis examined transaction frequency, revenue generation, and average customer spend.

The analysis provides insight into customer purchasing behaviour and payment preferences, supporting decisions related to digital payment infrastructure and checkout processes.


## Trend Analysis

Trend analysis was conducted at multiple levels:

Daily Revenue:
Revenue generated on each day.

Day-over-Day Growth:
Percentage change compared with the previous day.

30-Day Moving Average:
A smoothing technique used to identify underlying trends while reducing short-term volatility.

Week-over-Week Growth:
Comparison of weekly performance over time.

These metrics provide a strong foundation for forecasting and operational planning.


## Business Insights

1. Data quality directly impacts reporting reliability.

2. Product revenue is concentrated among a subset of items, suggesting that some products contribute disproportionately to business performance.

3. Underperforming items present opportunities for promotional campaigns or menu redesign.

4. Payment methods influence transaction behaviour and revenue generation.

5. Trend analysis reveals performance fluctuations that can support inventory planning and staffing decisions.

6. Window functions provide powerful capabilities for business intelligence directly within SQL.


## Recommendations

- Short-Term Recommendations:
- Maintain routine data-quality audits.
- Monitor missing-value rates.
- Review cookie products which are mostly underperforming within the data collected and look for another market for it, or properly market it for the right audience.

## Skills Demonstrated

- This project demonstrates:

Technical Skills:
- PostgreSQL
- Data Cleaning
- Data Validation
- Data Transformation
- SQL Window Functions
- Common Table Expressions
- Statistical Imputation
- Trend Analysis

Business Skills:
- Analytical Thinking
- Problem Solving
- Business Intelligence
- Insight Generation
- Data Storytelling

## Portfolio Value

This project showcases the ability to work with imperfect real-world data, develop repeatable cleaning procedures, and generate meaningful business insights. It demonstrates readiness for data analyst roles requiring SQL, data quality management, and business reporting skills.


## Conclusion

This portfolio project demonstrates an end-to-end SQL analytics workflow, from raw data ingestion to business insight generation. Through structured data cleaning, statistical imputation, exploratory analysis, and trend evaluation, the project transformed transactional café sales data into actionable business intelligence. The project reflects the technical and analytical competencies expected of professional data analysts and provides a strong example of SQL-driven decision support.
