{% macro scd_cols(column_list, partition_by_field, order_by_field) %}

{% set scd_col_list = column_list.split(",") %}
{% set scd_statements = [] %}

{% for col in scd_col_list %}

   {%- set scd_logic -%}
        first_value({{col}}) over (partition by {{ partition_by_field }} order by {{ order_by_field }} nulls last) as {{col}}_orig      
    {%- endset -%}

    {% do scd_statements.append(scd_logic) %}
  
{% endfor %}

{% set scd_sql = scd_statements | join(',\n') %}

{{ return(scd_sql) }}
  
{% endmacro %}