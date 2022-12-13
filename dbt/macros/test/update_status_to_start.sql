{% macro update_status_to_start(input_val) %}

{{ log('The input val is: ' ~ input_val, info=True) }}

select {{input_val}} as test_col
    
{% endmacro %}