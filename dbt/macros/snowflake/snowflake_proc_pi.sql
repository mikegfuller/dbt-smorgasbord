{% macro create_snowflake_pi() %}

{%- call statement('sp_pi', fetch_result=False) -%}

    create or replace procedure {{target.schema}}.sp_pi()
    returns float not null
    language javascript
    as
    $$
    return 3.1415926;
    $$
    ;

{%- endcall -%}

{% endmacro %}