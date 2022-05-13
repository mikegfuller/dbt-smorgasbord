{% macro sk_generator(val_start, val_increment) %}

{% set create_sequence_sql %}

create sequence if not exists {{target.database}}.{{target.schema}}.{{this.table}}_seq
start with = {{ val_start }}
increment = {{ val_increment }}

{% endset %}

{{ return(create_sequence_sql) }}

{% endmacro %}

{% macro monotonic_sk() %}

{% set get_sk_field_query %}

select ''' ~ {{target.database}}.{{target.schema}}.{{this.table}}_seq.nextval ~ '''

{% endset %}

{% set results = run_query(get_sk_field_query) %}

{% if execute %}
{# Return the first column #}
{% set sk_field = results.columns[0].values() %}

{% else %}

{% set sk_field = 1 %}

{% endif %}

{{ return(sk_field) }}

{% endmacro %}