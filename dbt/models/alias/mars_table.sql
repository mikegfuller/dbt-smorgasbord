{{
    config(
        materialized='table',
        alias='mars_table',
        schema='dbt_smograsbord'
    )
}}

select 1 as id