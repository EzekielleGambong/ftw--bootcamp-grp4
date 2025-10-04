{{ config(materialized="table", schema="clean") }}

with raw_vle as (
    select
        trim(code_module)       as code_module,
        trim(code_presentation) as code_presentation,
        toInt32(id_student)     as id_student,
        toInt32(id_site)        as id_site,
        toDateOrNull(toString(date)) as activity_date,
        toInt32(sum_click)      as sum_click
    from {{ source('raw', 'studentinfo') }}
)

select * from raw_vle
