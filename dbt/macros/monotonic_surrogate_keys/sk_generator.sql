{% macro sk_generator(val_start, val_increment) %}

{% set create_sequence_sql %}

create sequence if not exists {{target.database}}.{{target.schema}}.{{this.table}}_seq
start with = {{ val_start }}
increment = {{ val_increment }}

{% endset %}

{{ return(create_sequence_sql) }}

{% endmacro %}

{% macro monotonic_sk() %}

{% set sk_field_plus_alias %}

{{target.database}}.{{target.schema}}.{{this.table}}_seq.nextval as {{this.table}}_sk

{% endset %}

{{ return(sk_field_plus_alias) }}

{% endmacro %}