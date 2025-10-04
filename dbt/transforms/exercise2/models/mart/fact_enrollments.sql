{{ config(materialized="table", schema="mart") }}

-- This joins everything together to create the fact table
WITH student_registrations AS (
    SELECT * FROM {{ source('raw', 'studentRegistration') }}
),

dim_student AS (
    SELECT * FROM {{ ref('dim_student') }}
),

dim_module_presentation AS (
    SELECT * FROM {{ ref('dim_module_presentation') }}
)

SELECT
    -- Create surrogate keys for the fact table and dimensions
    {{ dbt_utils.generate_surrogate_key(['reg.id_student', 'reg.code_module', 'reg.code_presentation']) }} AS enrollment_key,
    ds.student_key,
    dmp.module_presentation_key,

    -- This is the logic to calculate our primary fact: the dropout flag
    CASE WHEN reg.date_unregistration IS NOT NULL THEN 1 ELSE 0 END AS is_dropout,
    
    reg.date_registration -- Or your calculated relative days
    
FROM student_registrations AS reg
LEFT JOIN dim_student AS ds ON reg.id_student = ds.id_student
LEFT JOIN dim_module_presentation AS dmp 
    ON reg.code_module = dmp.code_module 
    AND reg.code_presentation = dmp.code_presentation