{% macro sample_template(field_list, table_name) %}

select {{ field_list }}
from {{ref(table_name)}}
    
{% endmacro %}