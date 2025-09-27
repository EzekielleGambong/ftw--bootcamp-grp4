{{ config(materialized="view", schema="mart") }}

SELECT
    dt.is_on_playlist,
    SUM(fs.line_amount) AS total_revenue,
    COUNT(DISTINCT fs.track_key) AS number_of_tracks
FROM {{ ref('fct_sales') }} fs
JOIN {{ ref('dim_track') }} dt ON fs.track_key = dt.track_key
GROUP BY dt.is_on_playlist