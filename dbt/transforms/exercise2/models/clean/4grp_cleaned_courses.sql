{{ config(materialized="table", schema="clean") }}

with raw_courses as (
    select
        trim(code_module)                   as code_module,
        trim(code_presentation)             as code_presentation,
        toInt32(module_presentation_length) as module_presentation_length,
        _dlt_load_id,
        _dlt_id
    from {{ source('raw', 'courses') }}
)

select * from raw_courses