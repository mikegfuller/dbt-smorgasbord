{%- set sample_query -%}
select 'this result came from the database at: ' || to_char(current_timestamp)
{%- endset -%}

{% set results = run_query(sample_query) %}
{% if execute %}
{%- set sample_string = results.columns[0].values()[0] -%}
{% endif %}

{%- set sample_string_variable = "'" ~ sample_string ~ "'" -%}

select {{sample_string_variable}} as dynamic_value, 'another_value' as static_value, id
from {{ref('my_first_dbt_model')}}