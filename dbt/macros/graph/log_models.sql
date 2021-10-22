{% macro list_models(folder_path) %}

{% if execute %}

    {% do log("\n" ~ "list of models, materialization and full path:", info=true) %}

        {% for node in graph.nodes.values() | selectattr("resource_type", "equalto", "model") %}

            {% if node.path.startswith(folder_path) %}
  
            {% do log(node.unique_id ~ ", materialized: " ~ node.config.materialized ~ ", path: " ~ node.path, info=true) %}

            {% endif %}
        
        {% endfor %}

    {% do log("\n" ~ "list of just model names:", info=true) %}

        {% for node in graph.nodes.values() | selectattr("resource_type", "equalto", "model") %}

            {% if node.path.startswith(folder_path) %}

            {% set model_name = node.unique_id.split('.')[2] %}

            {% do log(node.unique_id, info=true) %}

            {% endif %}

        {% endfor %}

{% endif %}

{% endmacro %}