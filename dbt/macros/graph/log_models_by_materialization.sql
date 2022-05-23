{% macro list_models_by_materialization(materialization_type) %}

{% if execute %}

    {% do log("\n" ~ "list of models with materialization type = " ~ materialization_type, info=true) %}

        {% for node in graph.nodes.values() | selectattr("resource_type", "equalto", "model") %}

            {% if node.config.materialized == materialization_type %}

            {% set unique_id = node.unique_id %}

            {% set object_name = unique_id.split('.')[2] %}

            {% do log("alter table blue_db.blue_schema."~ object_name ~ " swap with green_db.green_schema." ~ object_name, info=True) %}

            {% endif %}
        
        {% endfor %}

{% endif %}

{% endmacro %}