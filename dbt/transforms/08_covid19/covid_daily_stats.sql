{{
  config(
    materialized='table'
  )
}}

SELECT

    CAST("date" AS DATE) AS report_date,

    CAST("location_key" AS VARCHAR) AS location_key,

    CAST(COALESCE("new_confirmed", 0) AS INT) AS daily_confirmed,
    CAST(COALESCE("new_deceased", 0) AS INT) AS daily_deceased,
    CAST(COALESCE("new_recovered", 0) AS INT) AS daily_recovered,
    CAST(COALESCE("new_tested", 0) AS INT) AS daily_tested,

    CAST(COALESCE("cumulative_confirmed", 0) AS INT) AS cumulative_confirmed,
    CAST(COALESCE("cumulative_deceased", 0) AS INT) AS cumulative_deceased,
    CAST(COALESCE("cumulative_tested", 0) AS INT) AS cumulative_tested,
    CAST(COALESCE("cumulative_recovered", 0) AS INT) AS cumulative_recovered

FROM {{ source('raw', 'raw___covid19_ez') }}
