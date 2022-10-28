  {% if 1==1 %}
      {% set mat_strat = 'table' %}
  {% elif 1==1 %}
      {% set mat_strat = 'view' %}
  {% else %}
     {% set mat_strat = 'incremental' %}
  {% endif %}


{{ config(
    materialized = mat_strat,
    order_by = "1",
    on_schema_change= "sync_all_columns"
)
}}

{{ log(flags.FULL_REFRESH, info=True) }}

select 1 cd, 'One' name, 'two' another_name