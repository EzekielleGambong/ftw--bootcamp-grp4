{{ config(materialized="view", schema="mart") }}

SELECT
    dt.artist_name,
    dt.album_title,
    SUM(fs.line_amount) AS total_revenue
FROM {{ ref('fct_sales_grp4') }} fs
JOIN {{ ref('dim_track_grp4') }} dt ON fs.track_key = dt.track_key
GROUP BY dt.artist_name, dt.album_title
ORDER BY total_revenue DESC