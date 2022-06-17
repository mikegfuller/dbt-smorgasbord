{{ config(materialized='view') }}

WITH source AS

(

SELECT

       distinct test_col orig_test_col, {{ str_before('test_col', '-') }} as str_before_test_col, {{ str_after('test_col', '-') }} as str_after_test_col

FROM

    {{ ref('dbt_stg_substring') }}

)

SELECT * FROM source