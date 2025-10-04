{{ config(materialized="table", schema="clean") }}

select
    id_student,
    gender,
    region,
    highest_education,
    case
        when trim(imd_band) = '?' then '0%'
        else trim(imd_band)
    end as imd_band,
    age_band,
    disability
from ( -- <--- Subquery starts here
    select
        *,
        row_number() over(partition by id_student order by code_presentation desc) as rn
    from {{ source('raw', 'informations') }}
) as source_data -- <--- Subquery ENDS here, then the alias
where rn = 1 -- <--- The WHERE clause is last, outside the parentheses