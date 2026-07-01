-- THIS DATASET CONTAINS TEN THOUSAND ROWS OR DATA
-- Creating cafe sales table
CREATE TABLE cafe_sales (
    transaction_id VARCHAR(50) PRIMARY KEY,
    item VARCHAR(50),
    quantity VARCHAR(50),
    price_per_unit VARCHAR(50),
    total_spent VARCHAR(50),
    payment_method VARCHAR(50),
    location VARCHAR(255),
    transaction_date VARCHAR(50)
);

-- DROP TABLE cafe_sales

-- loading the data into the database
copy cafe_sales FROM 'C:/Users/HP/Desktop/cafe_sales.csv' WITH (FORMAT CSV, HEADER TRUE);

-- retreiving the dataset
SELECT *
FROM cafe_sales;

-- Dealing with duplicate values
SELECT *,
	RANK() OVER(PARTITION BY transaction_id,
    item,
    quantity,
    price_per_unit,
    total_spent,
    payment_method,
    location,
    transaction_date ORDER BY transaction_date) AS crank
FROM cafe_sales;

-- CLONING THE CAFE_SALES TABLE IN ORDER TO CREATE A COPY TABLE
CREATE TABLE cafe_salesCopy (
	LIKE cafe_sales INCLUDING ALL
);

-- ADDING THE CRANK COLUMN
ALTER TABLE cafe_salesCopy
ADD COLUMN crank INT;

-- POPULATING THE CAFE_TABLE'S COPY
INSERT INTO cafe_salesCopy
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY transaction_id,
    item,
    quantity,
    price_per_unit,
    total_spent,
    payment_method,
    location,
    transaction_date ORDER BY transaction_date) AS crank
FROM cafe_sales;

-- SEARCHING FOR DUPLICATE VALUES
SELECT *,
	RANK() OVER(PARTITION BY transaction_id,
    item,
    quantity,
    price_per_unit,
    total_spent,
    payment_method,
    location,
    transaction_date ORDER BY transaction_date) AS crank
FROM cafe_salesCopy
WHERE crank > 1; -- THE RESULT SHOWS THAT THIS DATA HAS NO DUPLICATE VALUE AS NO RESULT FOR DUPLICATES.

-- NEXT IS DATA STANDARDIZATION

-- CHECKING THE transaction_id COLUMN FOR ERRORS, NULL VALUES AND EMPTY VALUES
SELECT transaction_id
FROM cafe_salesCopy
WHERE transaction_id IN ('ERROR', NULL, ''); -- NO ANOMALY WITH THE ID COLUMN

-- CHECKING THE transaction_id COLUMN FOR ERRORS, NULL VALUES AND EMPTY VALUES
SELECT 
	*
FROM cafe_salesCopy

-- Creating a view table cafe_sales_stage
CREATE OR REPLACE VIEW cafe_sales_stage AS
SELECT
    TRIM(transaction_id) AS transaction_id,
    NULLIF(TRIM(item), '') AS item,

    NULLIF(TRIM(quantity), '') AS quantity,
    NULLIF(TRIM(price_per_unit), '') AS price_per_unit,
    NULLIF(TRIM(total_spent), '') AS total_spent,

    NULLIF(TRIM(payment_method), '') AS payment_method,
    NULLIF(TRIM(location), '') AS location,
    NULLIF(TRIM(transaction_date), '') AS transaction_date
	
FROM cafe_salesCopy;

-- Data cleaning pipeline for all the columns in the dataset
WITH semicleanedData AS (
    SELECT
        transaction_id,

        -- ITEM CLEANING
        CASE
            WHEN item IS NULL THEN NULL
            WHEN TRIM(item) = '' THEN NULL
            WHEN LOWER(TRIM(item)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown') THEN NULL
            WHEN item ~ '^[0-9]+$' THEN NULL
            WHEN item ~ '^[^a-zA-Z]+$' THEN NULL
            ELSE TRIM(item)
        END AS item,

        -- QUANTITY CLEANING
        CASE
            WHEN quantity IS NULL THEN NULL
            WHEN LOWER(TRIM(quantity)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown') THEN NULL
            WHEN TRIM(quantity) ~ '^[0-9]+$' THEN TRIM(quantity)::INT
            ELSE NULL
        END AS quantity,

        -- PRICE CLEANING
        CASE
            WHEN price_per_unit IS NULL THEN NULL
            WHEN LOWER(TRIM(price_per_unit)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown') THEN NULL
            WHEN TRIM(price_per_unit) ~ '^[0-9]+(\.[0-9]+)?$'
            THEN TRIM(price_per_unit)::NUMERIC(10,2)
            ELSE NULL
        END AS price_per_unit,

        -- TOTAL SPENT CLEANING
        CASE
            WHEN total_spent IS NULL THEN NULL
            WHEN LOWER(TRIM(total_spent)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown') THEN NULL
            WHEN TRIM(total_spent) ~ '^[0-9]+(\.[0-9]+)?$'
            THEN TRIM(total_spent)::NUMERIC(12,2)
            ELSE NULL
        END AS total_spent,

        -- PAYMENT METHOD CLEANING (NEW)
        CASE
            WHEN payment_method IS NULL THEN NULL
            WHEN TRIM(payment_method) = '' THEN NULL
            WHEN LOWER(TRIM(payment_method)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown')
            THEN NULL
            ELSE INITCAP(TRIM(payment_method))
        END AS payment_method,

        -- LOCATION CLEANING (NEW)
        CASE
            WHEN location IS NULL THEN NULL
            WHEN TRIM(location) = '' THEN NULL
            WHEN LOWER(TRIM(location)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown')
            THEN NULL
            ELSE INITCAP(TRIM(location))
        END AS location,

        -- DATE CLEANING
        CASE
            WHEN transaction_date ~ '^\d{4}-\d{2}-\d{2}$'
            THEN transaction_date::DATE
            ELSE NULL
        END AS transaction_date

    FROM cafe_sales_stage
) 
SELECT *
FROM semicleanedData


-- creating a copy of semicleanedData
CREATE TABLE cafe_sales_stageCopy(
	LIKE cafe_sales_stage INCLUDING ALL
);

-- INSERTING THE DETAILS OF THE SEMICLEANEDDATA INTO cafe_sales_stageCopy TABLE
INSERT INTO cafe_sales_stageCopy
WITH semicleanedData AS (
    SELECT
        transaction_id,

        -- ITEM CLEANING
        CASE
            WHEN item IS NULL THEN NULL
            WHEN TRIM(item) = '' THEN NULL
            WHEN LOWER(TRIM(item)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown') THEN NULL
            WHEN item ~ '^[0-9]+$' THEN NULL
            WHEN item ~ '^[^a-zA-Z]+$' THEN NULL
            ELSE TRIM(item)
        END AS item,

        -- QUANTITY CLEANING
        CASE
            WHEN quantity IS NULL THEN NULL
            WHEN LOWER(TRIM(quantity)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown') THEN NULL
            WHEN TRIM(quantity) ~ '^[0-9]+$' THEN TRIM(quantity)::INT
            ELSE NULL
        END AS quantity,

        -- PRICE CLEANING
        CASE
            WHEN price_per_unit IS NULL THEN NULL
            WHEN LOWER(TRIM(price_per_unit)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown') THEN NULL
            WHEN TRIM(price_per_unit) ~ '^[0-9]+(\.[0-9]+)?$'
            THEN TRIM(price_per_unit)::NUMERIC(10,2)
            ELSE NULL
        END AS price_per_unit,

        -- TOTAL SPENT CLEANING
        CASE
            WHEN total_spent IS NULL THEN NULL
            WHEN LOWER(TRIM(total_spent)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown') THEN NULL
            WHEN TRIM(total_spent) ~ '^[0-9]+(\.[0-9]+)?$'
            THEN TRIM(total_spent)::NUMERIC(12,2)
            ELSE NULL
        END AS total_spent,

        -- PAYMENT METHOD CLEANING (NEW)
        CASE
            WHEN payment_method IS NULL THEN NULL
            WHEN TRIM(payment_method) = '' THEN NULL
            WHEN LOWER(TRIM(payment_method)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown')
            THEN NULL
            ELSE INITCAP(TRIM(payment_method))
        END AS payment_method,

        -- LOCATION CLEANING (NEW)
        CASE
            WHEN location IS NULL THEN NULL
            WHEN TRIM(location) = '' THEN NULL
            WHEN LOWER(TRIM(location)) IN ('na', 'n/a', 'null', 'none', 'error', 'unknown')
            THEN NULL
            ELSE INITCAP(TRIM(location))
        END AS location,

        -- DATE CLEANING
        CASE
            WHEN transaction_date ~ '^\d{4}-\d{2}-\d{2}$'
            THEN transaction_date::DATE
            ELSE NULL
        END AS transaction_date

    FROM cafe_sales_stage
) 
SELECT *
FROM cafe_sales_stage

-- CHECKING THE NUMBER OF NULL VALUES IN THE ITEM COLUMN
SELECT COUNT(*)
FROM cafe_sales_stageCopy
	WHERE item IS NULL; -- WE HAVE 969 NULL VALUES IN THE ITEM COLUMN

-- UPDATING THE ITEM COLUMN IN ORDER TO FILL NULL VALUES WITH UKNOWN INSTEAD OF NULL
UPDATE cafe_sales_stageCopy
SET item = CASE WHEN item IS NULL THEN 'Unknown' ELSE item END

SELECT COUNT(*)
FROM cafe_sales_stageCopy
WHERE item IS NULL;-- WE HAVE 0 NULL VALUES AFTER THE UPDATE

-- CHECKING THE NUMBER OF NULL VALUES IN THE QUANTITY COLUMN
SELECT COUNT(*)
FROM cafe_sales_stageCopy
	WHERE quantity IS NULL;-- WE HAVE 479 NULL VALUES 

-- CONVERTING THE QUANTITY COLUMN TO INT DATATYPE FROM TEXT
ALTER TABLE cafe_sales_stageCopy
ALTER COLUMN quantity TYPE INT
	USING quantity::INT;

-- I WANT TO GET THE MEDIAN VALUE OF THE QUANTITY COLUMN
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY quantity)
FROM cafe_sales_stageCopy
WHERE quantity IS NOT NULL;-- 3 IS THE MEDIAN VALUE

-- NEXT IS TO FILL THE NULL VALUES WITH THE MEDIAN VALUE GOTTEN ABOVE
-- SELECT quantity, 
-- 	COALESCE(quantity, 3) AS quantity
-- FROM cafe_sales_stageCopy
UPDATE cafe_sales_stageCopy
SET quantity = COALESCE(quantity, 3);

SELECT *
FROM cafe_sales_stageCopy;

-- CONVERTING THE QUANTITY COLUMN TO NUMERIC DATATYPE FROM TEXT
ALTER TABLE cafe_sales_stageCopy
ALTER COLUMN price_per_unit TYPE NUMERIC(10,2)
	USING price_per_unit::NUMERIC(10,2);

-- GETTING THE MEAN VALUE OF THE price_per_unit COLUMN
SELECT price_per_unit,
		COALESCE(
			price_per_unit,
				(
				SELECT 
					AVG(price_per_unit)
					FROM cafe_sales_stageCopy
				WHERE price_per_unit IS NOT NULL
				)
			) AS avg_price_per_unit
FROM cafe_sales_stageCopy;

-- UPDATING THE price_per_unit COLUMN AND FILLING THE NULL VALUES 
UPDATE cafe_sales_stageCopy
SET price_per_unit =(
						SELECT 
						AVG(price_per_unit)
						FROM cafe_sales_stageCopy
						WHERE price_per_unit IS NOT NULL
           			)   
						WHERE price_per_unit IS NULL;
SELECT *
FROM cafe_sales_stageCopy
-- WHERE price_per_unit IS NULL;

-- CONVERTING THE total_spent COLUMN TO NUMERIC DATATYPE FROM TEXT
ALTER TABLE cafe_sales_stageCopy
ALTER COLUMN total_spent TYPE NUMERIC(10,2)
	USING total_spent::NUMERIC(10,2);

-- GETTING THE MEAN VALUE OF THE price_per_unit COLUMN
SELECT total_spent,
	COALESCE(
				total_spent, 
				(
				SELECT ROUND(AVG(total_spent),2)
				FROM cafe_sales_stageCopy
				WHERE total_spent IS NOT NULL
				)
			) AS avg_t_spent
FROM cafe_sales_stageCopy;

-- UPDATING THE total_spent COLUMN WITH THE MEAN VALUE IN ORDER TO FILL THE NULL VALUES
UPDATE cafe_sales_stageCopy
SET total_spent = (
					SELECT ROUND(AVG(total_spent),2)
					FROM cafe_sales_stageCopy
					WHERE total_spent IS NOT NULL
				) 
					WHERE total_spent IS NULL

-- Finding the percentage of null values for the payment method columns	
SELECT 
    ROUND(
        100 * SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN payment_method IS NOT NULL THEN 1 ELSE 0 END), 0),
        2
    ) AS null_percentage
FROM cafe_sales_stageCopy; -- The payment method has 46.58% null values. This is a lot.

-- NEXT IS THE PAYMENT METHOD. i'LL FILL THE PAYMENT METHOD NULL VALUES WITH UNKNOWN INSTEAD OF DELETING IT	
-- SELECT * FROM paymentPercent;
UPDATE 	cafe_sales_stageCopy
SET payment_method = CASE WHEN payment_method IS NULL THEN 'Unknown' ELSE payment_method END;

-- CHECKING THE PERCENTAGE OF THE NULL VALUES AND THE NOT NULLS FOR THE LOCATION COLUMN
SELECT 
    ROUND(
        100 * SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN location IS NOT NULL THEN 1 ELSE 0 END), 0),
        2
    ) AS null_percentage
FROM cafe_sales_stageCopy; -- 65% of the column is null

-- investigating the number of missing values in relation to the payment method, having checked it, i'll fill with unknown
SELECT 
    payment_method,
    COUNT(*) AS total_records,
    SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END) AS missing_locations
FROM cafe_sales_stageCopy

-- I MADE A MISTAKE FILLING ALL THE ROWS IN THE LOCATION COLUMN WITH UNKNOWN, 
-- I WANT TO RE-ADD THE LOCATION COLUMN FROM THE ORIGINAL CAFE SALES TABLE
-- UPDATE cafe_sales_stageCopy
-- SET location = CASE WHEN location IS NULL THEN 'Unknown' ELSE location END;

-- RESTORING MY BROKEN cafe_sales_stageCopy LOCATION COLUMN
UPDATE cafe_sales_stageCopy c
SET location = s.location
FROM cafe_sales s
WHERE c.transaction_id = s.transaction_id

-- NEXT IS TO FILL THE NULL VALUES WITH UNKNOWN WHILE KEEPING THE VALID VALUES
UPDATE cafe_sales_stageCopy
SET location = CASE 
					WHEN location IS NULL OR location = 'ERROR' THEN 'Unknown' ELSE location
				END
					

-- Fill NULL dates with the previous NON-NULL date

WITH cte AS 
	(
	SELECT transaction_id,
	MAX(transaction_date) OVER(ORDER BY 
	transaction_id ROWS BETWEEN UNBOUNDED PRECEDING AND 
	CURRENT ROW) AS transaction_dateFilled
	FROM cafe_sales_stageCopy
)
UPDATE cafe_sales_stageCopy cs
SET transaction_date = c.transaction_dateFilled
FROM cte c
WHERE cs.transaction_id = c.transaction_id
AND cs.transaction_date IS NULL;

SELECT *
FROM cafe_sales_stageCopy

-- Exploratory Data Analysis

-- Which items generated the highest sales
SELECT
    transaction_date,
    SUM(total_spent) AS total_sales
FROM cafe_sales_stageCopy
GROUP BY transaction_date
ORDER BY total_sales DESC
LIMIT 1;

-- Which day of the week generated the highest sales
SELECT
    TO_CHAR(transaction_date, 'Day') AS day_name,
    SUM(total_spent) AS total_sales
FROM cafe_sales_stageCopy
GROUP BY day_name
ORDER BY total_sales DESC;

-- the percentage of total revenue contributed by each item

SELECT
    item,
    SUM(total_spent) AS item_revenue,
    ROUND(
        100.0 * SUM(total_spent) /
        SUM(SUM(total_spent)) OVER (),
        2
    ) AS revenue_percentage
FROM cafe_sales_stageCopy
GROUP BY item
ORDER BY item_revenue DESC;

-- which items are underperforming
WITH item_sales AS (
    SELECT
        item,
        SUM(total_spent) AS revenue
    FROM cafe_sales_stageCopy
    GROUP BY item
)
SELECT
    item,
    revenue,
    ROUND(
        100.0 * revenue / SUM(revenue) OVER (),
        2
    ) AS revenue_pct
FROM item_sales
WHERE revenue < (
    SELECT SUM(revenue) * 0.05
    FROM item_sales
)
ORDER BY revenue;

-- What is the largest transaction
SELECT MAX(total_spent)
FROM cafe_sales_stageCopy;

-- Which payment method is used most?
SELECT
    payment_method,
    COUNT(*) AS transaction_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS transaction_percentage
FROM cafe_sales_stageCopy
GROUP BY payment_method
ORDER BY transaction_count DESC;

-- Which payment method generates the most revenue?

SELECT
    payment_method,
    SUM(total_spent) AS revenue
FROM cafe_sales_stageCopy
GROUP BY payment_method
ORDER BY revenue DESC;

-- What percentage of transactions use cash/card/mobile payment?
SELECT
    payment_method,
    COUNT(*) AS transaction_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS transaction_percentage
FROM cafe_sales_stageCopy
GROUP BY payment_method
ORDER BY transaction_count DESC;

-- Is there a relationship between payment method and spending amount?

SELECT
    payment_method,
    COUNT(*) AS transactions,
    ROUND(AVG(total_spent), 2) AS avg_spend,
    SUM(total_spent) AS total_revenue
FROM cafe_sales_stageCopy
GROUP BY payment_method
ORDER BY avg_spend DESC;

-- Daily revenue trends
SELECT
    transaction_date::DATE AS sales_date,
    SUM(total_spent) AS daily_revenue
FROM cafe_sales_stageCopy
GROUP BY sales_date
ORDER BY sales_date;

-- Daily Revenue with Day-over-Day Growth
SELECT
    transaction_date::DATE AS sales_date,
    SUM(total_spent) AS daily_revenue,
    ROUND(
        100.0 * (
            SUM(total_spent) -
            LAG(SUM(total_spent)) OVER (ORDER BY transaction_date::DATE)
        ) /
        LAG(SUM(total_spent)) OVER (ORDER BY transaction_date::DATE),
        2
    ) AS growth_pct
FROM cafe_sales_stageCopy
GROUP BY sales_date
-- HAVING daily_revenue IS NOT NULL
ORDER BY sales_date;

-- 30-Day Moving Average Trend

WITH daily_sales AS (
    SELECT
        transaction_date::DATE AS sales_date,
        SUM(total_spent) AS daily_revenue
    FROM cafe_sales_stageCopy
    GROUP BY sales_date
)
SELECT
    sales_date,
    daily_revenue,
    ROUND(
        AVG(daily_revenue) OVER (
            ORDER BY sales_date
            ROWS BETWEEN 30 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_30d
FROM daily_sales
ORDER BY sales_date;

-- Week-over-week growth
WITH weekly_sales AS (
    SELECT
        DATE_TRUNC('week', transaction_date::DATE) AS week_start,
        SUM(total_spent) AS weekly_revenue
    FROM cafe_sales_stageCopy
    GROUP BY week_start
),
weekly_growth AS (
    SELECT
        week_start,
        weekly_revenue,
        LAG(weekly_revenue) OVER(ORDER BY week_start) AS prev_week_revenue
    FROM weekly_sales
)
SELECT
    week_start,
    weekly_revenue,
    ROUND(
        (weekly_revenue - prev_week_revenue)
        * 100.0
        / prev_week_revenue,
        2
    ) AS wow_growth_pct
FROM weekly_growth
WHERE prev_week_revenue IS NOT NULL
ORDER BY week_start;