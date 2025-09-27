{{ config(materialized="table", schema="clean") }}

SELECT
    employee_id     AS employee_key,
    first_name || ' ' || last_name AS full_name,
    title,
    city,
    country
FROM {{ source('raw', 'employee') }}