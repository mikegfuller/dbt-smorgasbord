{% macro create_snowflake_procs() %}
    
{{ create_snowflake_pi() }}
{{ create_snowflake_hello() }}

{% endmacro %}