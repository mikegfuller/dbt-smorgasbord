{% macro sk_generator(val_start, val_increment) %}

{% set create_sequence_sql %}

create sequence if not exists {{target.database}}.{{target.schema}}.{{this.table}}_sk 
start with = {{ val_start }}
increment = {{ val_increment }}

{% endset %}

{{ return(create_sequence_sql) }}

{% endmacro %}