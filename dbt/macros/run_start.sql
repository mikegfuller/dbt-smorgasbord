{% macro run_start() %}

{% if execute %}

{{ log("This is a run start macro", info=True) }}

{% endif %}
    
{% endmacro %}