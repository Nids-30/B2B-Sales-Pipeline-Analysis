/*
PROJECT: B2B Sales Pipeline Analysis

OBJECTIVE:
Analyze B2B sales performance using SQL.

DATABASE: b2b_sales
TABLE: b2b_sales_data

ANALYSIS COVERED:
1. Dataset overview
2. Sales performance and win rate
3. Product revenue analysis
4. Sales agent performance
5. Customer revenue analysis
6. Monthly sales analysis
7. Data quality checks

DATA LIMITATION:
The SQL table contains 6,711 records, while the Excel
dataset contains 8,800 records. The SQL table currently
contains only Won and Lost deal stages.

SQL findings apply to the records available in the SQL
table and do not represent all 8,800 Excel records.
*/

USE b2b_sales;

-- Your existing SQL queries continue below...

ALTER TABLE b2b_sales_data
RENAME COLUMN `ï»¿opportunity_id` TO opportunity_id;
SELECT COUNT(*) AS total_rows
FROM b2b_sales_data;
SELECT
    COUNT(*) AS total_rows,
    COUNT(opportunity_id) AS rows_with_id,
    COUNT(DISTINCT opportunity_id) AS unique_ids
FROM b2b_sales_data;
USE b2b_sales;

SHOW TABLES;
USE b2b_sales;

CREATE TABLE b2b_sales_data_new LIKE b2b_sales_data;
USE b2b_sales;

SELECT
    'original' AS table_name,
    COUNT(*) AS total_rows
FROM b2b_sales_data

UNION ALL

SELECT
    'new' AS table_name,
    COUNT(*) AS total_rows
FROM b2b_sales_data_new;
USE b2b_sales;

SELECT COUNT(*) FROM b2b_sales_data_new;

USE b2b_sales;

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT opportunity_id) AS unique_opportunities,
    COUNT(DISTINCT sales_agent) AS total_sales_agents,
    COUNT(DISTINCT product) AS total_products
FROM b2b_sales_data;
USE b2b_sales;

DESCRIBE b2b_sales_data;
USE b2b_sales;

ALTER TABLE b2b_sales_data
CHANGE COLUMN `ï»¿opportunity_id` opportunity_id TEXT;
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT opportunity_id) AS unique_opportunities,
    COUNT(DISTINCT sales_agent) AS total_sales_agents,
    COUNT(DISTINCT product) AS total_products
FROM b2b_sales_data;
SELECT
    deal_stage,
    COUNT(*) AS opportunity_count
FROM b2b_sales_data
GROUP BY deal_stage
ORDER BY opportunity_count DESC;
SELECT
    SUM(close_value) AS total_won_revenue,
    AVG(close_value) AS average_won_deal_value,
    COUNT(*) AS total_won_deals
FROM b2b_sales_data
WHERE deal_stage = 'Won';
SELECT
    sales_agent,
    SUM(close_value) AS total_revenue,
    COUNT(*) AS won_deals
FROM b2b_sales_data
WHERE deal_stage = 'Won'
GROUP BY sales_agent
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    product,
    SUM(close_value) AS total_revenue,
    COUNT(*) AS won_deals,
    ROUND(AVG(close_value), 2) AS average_deal_value
FROM b2b_sales_data
WHERE deal_stage = 'Won'
GROUP BY product
ORDER BY total_revenue DESC;
SELECT
    MONTH(STR_TO_DATE(close_date, '%m/%d/%Y')) AS month_number,
    DATE_FORMAT(
        STR_TO_DATE(close_date, '%m/%d/%Y'),
        '%b'
    ) AS month_name,
    SUM(close_value) AS total_revenue,
    COUNT(*) AS won_deals
FROM b2b_sales_data
WHERE deal_stage = 'Won'
  AND STR_TO_DATE(close_date, '%m/%d/%Y') IS NOT NULL
GROUP BY month_number, month_name
ORDER BY month_number;
SELECT close_date
FROM b2b_sales_data
WHERE deal_stage = 'Won'
LIMIT 10;
SELECT
    MONTH(STR_TO_DATE(close_date, '%d-%m-%Y')) AS month_number,
    DATE_FORMAT(
        STR_TO_DATE(close_date, '%d-%m-%Y'),
        '%b'
    ) AS month_name,
    SUM(close_value) AS total_revenue,
    COUNT(*) AS won_deals
FROM b2b_sales_data
WHERE deal_stage = 'Won'
  AND STR_TO_DATE(close_date, '%d-%m-%Y') IS NOT NULL
GROUP BY month_number, month_name
ORDER BY month_number;
SELECT
    SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
    SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_deals,
    ROUND(
        100.0 * SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS win_rate_percentage
FROM b2b_sales_data
WHERE deal_stage IN ('Won', 'Lost');
SELECT
    account,
    SUM(close_value) AS total_revenue,
    COUNT(*) AS won_deals,
    ROUND(AVG(close_value), 2) AS average_deal_value
FROM b2b_sales_data
WHERE deal_stage = 'Won'
GROUP BY account
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    sales_agent,
    SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
    SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_deals,
    ROUND(
        100.0 * SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS win_rate_percentage
FROM b2b_sales_data
WHERE deal_stage IN ('Won', 'Lost')
GROUP BY sales_agent
HAVING COUNT(*) >= 50
ORDER BY win_rate_percentage DESC
LIMIT 10;
SELECT
    product,
    COUNT(*) AS lost_deals,
    SUM(close_value) AS total_lost_value,
    ROUND(AVG(close_value), 2) AS average_lost_deal_value
FROM b2b_sales_data
WHERE deal_stage = 'Lost'
GROUP BY product
ORDER BY total_lost_value DESC;
SELECT
    COUNT(*) AS lost_deals,
    SUM(close_value) AS total_close_value,
    SUM(CASE WHEN close_value = 0 THEN 1 ELSE 0 END) AS zero_value_deals,
    SUM(CASE WHEN close_value IS NULL THEN 1 ELSE 0 END) AS missing_value_deals
FROM b2b_sales_data
WHERE deal_stage = 'Lost';
SELECT
    product,
    COUNT(*) AS lost_deals
FROM b2b_sales_data
WHERE deal_stage = 'Lost'
GROUP BY product
ORDER BY lost_deals DESC
SELECT
    product,
    SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
    SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_deals,
    COUNT(*) AS total_deals,
    ROUND(
        100.0 * SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS win_rate_percentage
FROM b2b_sales_data
WHERE deal_stage IN ('Won', 'Lost')
GROUP BY product
ORDER BY win_rate_percentage DESC;
SELECT
    sales_agent,
    COUNT(*) AS lost_deals
FROM b2b_sales_data
WHERE deal_stage = 'Lost'
GROUP BY sales_agent
ORDER BY lost_deals DESC
LIMIT 10;
SELECT
    sales_agent,
    SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
    SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_deals,
    COUNT(*) AS total_deals,
    ROUND(
        100.0 * SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS win_rate_percentage
FROM b2b_sales_data
WHERE deal_stage IN ('Won', 'Lost')
GROUP BY sales_agent
HAVING COUNT(*) >= 50
ORDER BY win_rate_percentage ASC
LIMIT 10;
SELECT
    MONTH(STR_TO_DATE(close_date, '%d-%m-%Y')) AS month_number,
    DATE_FORMAT(
        STR_TO_DATE(close_date, '%d-%m-%Y'),
        '%b'
    ) AS month_name,
    COUNT(*) AS lost_deals
FROM b2b_sales_data
WHERE deal_stage = 'Lost'
  AND STR_TO_DATE(close_date, '%d-%m-%Y') IS NOT NULL
GROUP BY month_number, month_name
ORDER BY month_number;
SELECT
    MONTH(STR_TO_DATE(close_date, '%d-%m-%Y')) AS month_number,
    DATE_FORMAT(
        STR_TO_DATE(close_date, '%d-%m-%Y'),
        '%b'
    ) AS month_name,
    SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
    SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_deals,
    COUNT(*) AS total_closed_deals,
    ROUND(
        100.0 * SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS monthly_win_rate
FROM b2b_sales_data
WHERE deal_stage IN ('Won', 'Lost')
  AND STR_TO_DATE(close_date, '%d-%m-%Y') IS NOT NULL
GROUP BY month_number, month_name
ORDER BY month_number;
SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN engage_date IS NULL OR TRIM(engage_date) = '' THEN 1 ELSE 0 END)
        AS missing_engage_dates,
    SUM(CASE WHEN close_date IS NULL OR TRIM(close_date) = '' THEN 1 ELSE 0 END)
        AS missing_close_dates,
    SUM(CASE WHEN sales_agent IS NULL OR TRIM(sales_agent) = '' THEN 1 ELSE 0 END)
        AS missing_sales_agents,
    SUM(CASE WHEN product IS NULL OR TRIM(product) = '' THEN 1 ELSE 0 END)
        AS missing_products
FROM b2b_sales_data;
SELECT
    opportunity_id,
    COUNT(*) AS occurrence_count
FROM b2b_sales_data
GROUP BY opportunity_id
HAVING COUNT(*) > 1;
SELECT COUNT(*) AS invalid_close_dates
FROM b2b_sales_data
WHERE close_date IS NOT NULL
  AND TRIM(close_date) <> ''
  AND STR_TO_DATE(close_date, '%d-%m-%Y') IS NULL;
  SELECT COUNT(*) AS invalid_engage_dates
FROM b2b_sales_data
WHERE engage_date IS NOT NULL
  AND TRIM(engage_date) <> ''
  AND STR_TO_DATE(engage_date, '%d-%m-%Y') IS NULL;
  USE b2b_sales;

SELECT
    deal_stage,
    COUNT(*) AS total_deals
FROM b2b_sales_data
GROUP BY deal_stage
ORDER BY total_deals DESC;
USE b2b_sales;

SELECT
    COUNT(*) AS total_records,
    MIN(STR_TO_DATE(close_date, '%d-%m-%Y')) AS earliest_close_date,
    MAX(STR_TO_DATE(close_date, '%d-%m-%Y')) AS latest_close_date
FROM b2b_sales_data;