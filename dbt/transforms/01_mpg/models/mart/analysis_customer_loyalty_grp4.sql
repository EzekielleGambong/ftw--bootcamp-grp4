{{ config(materialized="view", schema="mart") }}

WITH customer_segments AS (
    SELECT
        customer_key,
        CASE 
            WHEN COUNT(DISTINCT invoice_id) > 5 THEN 'Loyal Customer'
            WHEN COUNT(DISTINCT invoice_id) BETWEEN 2 AND 5 THEN 'Regular Customer'
            ELSE 'Infrequent Buyer'
        END AS loyalty_tier
    FROM {{ ref('fct_sales') }}
    GROUP BY customer_key
)
SELECT
    cs.loyalty_tier,
    COUNT(DISTINCT cs.customer_key) AS number_of_customers,
    SUM(fs.line_amount) AS total_revenue
FROM {{ ref('fct_sales') }} fs
JOIN customer_segments cs ON fs.customer_key = cs.customer_key
GROUP BY cs.loyalty_tier
ORDER BY total_revenue DESC