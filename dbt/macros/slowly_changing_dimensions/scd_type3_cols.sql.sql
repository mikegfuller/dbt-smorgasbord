{% macro scd3_cols(column_list, partition_by_field, order_by_field) %}

{% set scd3_col_list = column_list.split(",") %}
{% set scd3_statements = [] %}

{% for col in scd3_col_list %}

   {%- set scd3_logic -%}
        first_value({{col}}) over (partition by {{ partition_by_field }} order by {{ order_by_field }} nulls last) as {{col}}_orig      
    {%- endset -%}

    {% do scd3_statements.append(scd3_logic) %}
  
{% endfor %}

{% set scd3_sql = scd3_statements | join(',\n') %}

{{ return(scd3_sql) }}
  
{% endmacro %}