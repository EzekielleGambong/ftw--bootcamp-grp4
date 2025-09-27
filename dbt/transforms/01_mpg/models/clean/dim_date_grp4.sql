{{ config(materialized="table", schema="clean") }}

SELECT
    DISTINCT
    CAST(invoice_date AS DATE) AS date_key,
    EXTRACT(YEAR FROM invoice_date) AS year,
    EXTRACT(MONTH FROM invoice_date) AS month,
    EXTRACT(QUARTER FROM invoice_date) AS quarter
FROM {{ source('raw', 'invoice') }}