{{
    config(
        materialized='table'
    )
}}

{% set my_var='select \'this is a var\'' %}

select 1 as id

{{
    config(
        post_hook = my_var
    )
}}