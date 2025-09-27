{{ config(materialized="table", schema="clean") }}

SELECT
    customer_id         AS customer_key,
    first_name || ' ' || last_name AS full_name,
    company,
    city,
    state,
    country,
    postal_code,
    support_rep_id      AS employee_key
FROM {{ source('raw', 'customer') }}