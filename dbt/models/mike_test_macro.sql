{{
    config(
        materialized='table'
    )
}}

{% set my_var=1000 %}

{% set macro_call = "{{my_macro(" ~ my_var ~ ")}}" %}

select 1 as id

{{
    config(
        post_hook = macro_call
    )
}}