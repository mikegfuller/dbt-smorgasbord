{{
    config(
        materialized='table',
        post_hook = "my_var"
    )
}}

{% set my_var='select \'this is a var\'' %}

select 1 as id