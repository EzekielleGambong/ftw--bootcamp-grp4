{{ config(materialized="table", schema="clean") }}

-- This staging model creates a unique row for each presentation
-- and its calculated start date, adhering to 3NF.

select distinct
    trim(code_module) as code_module,
    trim(code_presentation) as code_presentation,
    -- Determine the start date of the presentation semester
    case
        when substring(code_presentation, 5, 1) = 'J' -- 'J' semester starts in January
            then toDate(concat(substring(code_presentation, 1, 4), '-01-01'))
        when substring(code_presentation, 5, 1) = 'B' -- 'B' semester starts in October
            then toDate(concat(substring(code_presentation, 1, 4), '-10-01'))
    end as presentation_start_date
from {{ source('raw', 'studentRegistration') }}