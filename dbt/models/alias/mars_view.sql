{{
    config(
        materialized='view',
        alias='mars_table',
        schema='test'
    )
}}

select * from {{ ref('mars_table') }}