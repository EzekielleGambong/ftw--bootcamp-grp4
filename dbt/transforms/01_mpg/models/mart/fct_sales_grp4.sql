{{ config(materialized="table", schema="mart") }}

SELECT
    il.invoice_line_id,
    i.invoice_id,
    i.customer_id   AS customer_key,
    c.support_rep_id AS employee_key,
    il.track_id     AS track_key,
    CAST(i.invoice_date AS DATE) AS date_key,
    i.total as invoice_total,
    il.quantity,
    il.unit_price,
    (il.quantity * il.unit_price) AS line_amount
FROM {{ source('raw', 'invoice_line') }} il
JOIN {{ source('raw', 'invoice') }} i ON il.invoice_id = i.invoice_id
JOIN {{ source('raw', 'customer') }} c ON i.customer_id = c.customer_id