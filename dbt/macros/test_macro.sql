{% macro test_macro() %}

{%- set variant_keys_query -%}
  select current_timestamp
{% endset %}

{% if execute and flags.WHICH in ['compile']  %}
    {% set return_value = 'yep' %}}}
{% else %}
    {% set return_value = 'nope' %}
{% endif %}

{{ return(return_value) }}
  
{% endmacro %}