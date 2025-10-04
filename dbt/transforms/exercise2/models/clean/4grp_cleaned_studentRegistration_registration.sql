{{ config(materialized="table", schema="clean") }}

with raw_registrations as (
    select
        trim(code_module) as code_module,
        trim(code_presentation) as code_presentation,
        toInt32(id_student) as id_student,
        toInt32OrNull(nullif(trim(date_registration), '?')) as registration_offset_days,
        toInt32OrNull(nullif(trim(date_unregistration), '?')) as unregistration_offset_days
    from {{ source('raw', 'studentRegistration') }}
)

-- 2. Join with the presentations staging model to get the start date
select
    reg.id_student,
    reg.code_module,
    reg.code_presentation,
    -- Calculate the actual registration date by adding the offset days
    if(
        reg.registration_offset_days is not null,
        addDays(pres.presentation_start_date, reg.registration_offset_days),
        null
    ) as registration_date,
    -- Calculate the actual unregistration date
    if(
        reg.unregistration_offset_days is not null,
        addDays(pres.presentation_start_date, reg.unregistration_offset_days),
        null
    ) as unregistration_date
from raw_registrations as reg
join {{ ref('stg_presentations') }} as pres
    on reg.code_module = pres.code_module
    and reg.code_presentation = pres.code_presentation