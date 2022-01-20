{% macro add_immutable_events() %}

{% set insert_changed_record %}
 insert into {{target.database}}.{{target.schema}}.immutable_events values (3, 'closed', current_date) 
 {% endset %}

{% do run_query(insert_changed_record) %}

{% set insert_new_record %}
 insert into {{target.database}}.{{target.schema}}.immutable_events values (4, 'open', current_date) 
 {% endset %}

{% do run_query(insert_new_record) %}
    
{% endmacro %}