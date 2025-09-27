{{ config(materialized="view", schema="mart") }}

SELECT
    dt.media_type_name,
    dd.year,
    SUM(fs.line_amount) AS total_revenue
FROM {{ ref('fct_sales_grp4') }} fs
JOIN {{ ref('dim_track_grp4') }} dt ON fs.track_key = dt.track_key
JOIN {{ ref('dim_date_grp4') }} dd ON fs.date_key = dd.date_key
GROUP BY dt.media_type_name, dd.year
ORDER BY dd.year, total_revenue DESC