{{ config(materialized="table", schema="clean") }}

-- This model builds the "Registrations" linking table.
-- It should ONLY select the columns related to the registration event.

select
    id_student,
    code_module,
    code_presentation,
    num_of_prev_attempts,
    studied_credits,
    final_result
from {{ source('raw', 'informations') }}