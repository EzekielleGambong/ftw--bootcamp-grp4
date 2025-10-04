{{ config(materialized="view", schema="mart") }}
SELECT
    {{ dbt_utils.generate_surrogate_key(['id_student']) }} AS student_key,
    id_student,
    gender,
    region,
    highest_education,
    age_band
FROM {{ source('raw', 'informations') }}