{% macro create_snowflake_hello() %}

{%- call statement('sp_hello', fetch_result=False) -%}

    create or replace procedure sp_hello_world()
    returns string not null
    language javascript
    as
    $$
    return 'hello world';
    $$
    ;

{%- endcall -%}

{% endmacro %}