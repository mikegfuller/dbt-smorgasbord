{% macro run_query_example() %}
    
{%- set sample_query -%}
select 'this result came from the database at: ' || to_char(current_timestamp)
{%- endset -%}

{% set results = run_query(sample_query) %}
{% if execute %}
{%- set sample_string = results.columns[0].values()[0] -%}
{% endif %}

{%- set sample_string_char = "'" ~ sample_string ~ "'" -%}

{% do log(sample_string_char, True) %}

{{return(sample_string_char)}}

{% endmacro %}