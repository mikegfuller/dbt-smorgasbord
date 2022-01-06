{% macro audit_model_start() %}

{% set insert_start_time %}
insert into {{ target.database }}.{{ target.schema }}.run_audit values ( '{{this.table}}', current_timestamp, null)
{% endset %}

{% if execute %}
{% do run_query(insert_start_time) %}
{% endif %}

{% endmacro %}