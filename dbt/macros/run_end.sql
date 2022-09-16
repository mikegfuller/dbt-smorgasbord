{% macro run_end() %}

{% if execute %}

{{ log("This is a run end macro", info=True) }}    

{% endif %}
    
{% endmacro %}