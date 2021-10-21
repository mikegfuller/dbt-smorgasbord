{% macro example_query() %}

{% do run_query('select current_timestamp()') %}
    
{% endmacro %}