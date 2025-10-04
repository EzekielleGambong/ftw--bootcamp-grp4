{{ config(materialized="view", schema="mart") }}
SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['code_module', 'code_presentation']) }} AS module_presentation_key,
    code_module,
    code_presentation
FROM {{ source('raw', 'studentRegistration') }}