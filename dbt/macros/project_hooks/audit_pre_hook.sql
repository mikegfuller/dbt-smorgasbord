{% macro audit_pre_hook() %}

{% set test_query %}
select current_timestamp
{% endset %}

{% if execute %}
{% set results = run_query(test_query).columns[0].values() %}
{% endif %}

{{ log(results, info=True) }}


{% endmacro %}