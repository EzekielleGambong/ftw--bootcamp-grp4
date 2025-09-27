{{ config(materialized="view", schema="mart") }}

SELECT
    dc.city,
    dc.country,
    COUNT(DISTINCT dc.customer_key) AS number_of_customers,
    AVG(fs.invoice_total) AS average_sale_per_invoice
FROM {{ ref('fct_sales_grp4') }} fs
JOIN {{ ref('dim_customer_grp4') }} dc ON fs.customer_key = dc.customer_key
GROUP BY dc.city, dc.country
HAVING number_of_customers < 5
ORDER BY average_sale_per_invoice DESC