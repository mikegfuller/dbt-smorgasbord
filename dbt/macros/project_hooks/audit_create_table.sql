{% macro create_audit_table() %}

{% set create_if_not_exists %}
create table if not exists {{ target.database }}.{{ target.schema }}.run_audit (table_name string, start_time timestamp_ntz, end_time timestamp_ntz)
{% endset %}

{% if execute %}
{% do run_query(create_if_not_exists) %}
{% endif %}

{% endmacro %}