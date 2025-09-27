{{ config(materialized="view", schema="mart") }}

SELECT
    de.full_name AS employee_name,
    de.title,
    COUNT(DISTINCT fs.customer_key) AS number_of_customers_managed,
    SUM(fs.line_amount) AS total_revenue_from_customers
FROM {{ ref('fct_sales') }} fs
JOIN {{ ref('dim_employee') }} de ON fs.employee_key = de.employee_key
GROUP BY de.full_name, de.title
ORDER BY total_revenue_from_customers DESC