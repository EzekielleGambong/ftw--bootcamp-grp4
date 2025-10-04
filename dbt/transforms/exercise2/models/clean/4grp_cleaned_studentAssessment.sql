{{ config(materialized="table", schema="clean") }}

with raw_student_assessment as (
    select
        toInt32(id_assessment)      as id_assessment,
        toInt32(id_student)         as id_student,
        toInt32(date_submitted)     as date_submitted, -- Note: This assumes date_submitted is a numerical offset (e.g., days from course start)
        toBool(is_banked)           as is_banked,
        toFloat32OrNull(score)      as score,
        _dlt_load_id,
        _dlt_id
    from {{ source('raw', 'studentAssessment') }}
)

select * from raw_student_assessment