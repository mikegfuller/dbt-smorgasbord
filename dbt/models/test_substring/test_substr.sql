{{ config(materialized='view') }}

WITH source AS

(

SELECT

       distinct atwrt org_atwrt, {{ str_before('atwrt', '\'-\'') }} as str_before_atwrt, {{ str_after('atwrt', '\'-\'') }} as str_after_atwrt

FROM

    {{ ref('dbt_stg_ausp') }}

)

SELECT * FROM source;