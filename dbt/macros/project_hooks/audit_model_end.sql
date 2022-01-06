{% macro audit_model_end() %}

{% set update_end_time %}
update {{ target.database }}.{{ target.schema }}.run_audit set end_time = current_timestamp where table_name = '{{this.table}}'
{% endset %}

{% if execute %}
{% do run_query(update_end_time) %}
{% endif %}

{% endmacro %}