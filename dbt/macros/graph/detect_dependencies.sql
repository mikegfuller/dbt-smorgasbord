{% macro list_dependencies(folder_path) %}

{% if execute %}

    {% do log("\n" ~ "model and dependencies:", info=true) %}

        {% for node in graph.nodes.values() | selectattr("resource_type", "equalto", "model")  %}

            {% if node.name.startswith('d_test_table') %}

            {% set depdendency_models = node.depends_on.nodes %}

                {% for i in depdendency_models recursive %}

                    {{ loop(node.depends_on.nodes) }}

                    {% do log(i, info = True) %}

                {% endfor %}

            {% endif %}
        
        {% endfor %}

{% endif %}

{% endmacro %}