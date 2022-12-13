{%- set this_is_my_var = 'data' %}

{{ log('The variable value is: ' ~ this_is_my_var, info=True) }}

{{
  config(
   materialized='view',
   pre_hook = "{{update_status_to_start('" ~ this_is_my_var ~ "')}}"
  )
}}


  select 1 as test


  