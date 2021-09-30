{% macro generate_schema_name(schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if target.name in ('prod') and schema_name is not none -%}
        {{ schema_name | trim }}
    {%- else -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}