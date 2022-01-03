{% macro source_new(source_name, table_name, variable_name) %}
{% if variable_name %}
  {% set rel = builtins.source(source_name, table_name ~ '_' ~ var(variable_name)) %}
  {% set newrel = rel %}
{% else %}
  {% set rel = builtins.source(source_name, table_name) %}
  {% set newrel = rel %}
{% endif %}
{% do return(newrel) %}
{% endmacro %}