{% macro find_string(string_value) %}

{% set search_string = string_value %}
    
{% set models = graph.nodes.values() | selectattr('resource_type', 'eq', 'model') %}

{% set matched_sql_models=[] %}

{% for model in models %}

    {% if search_string in model.raw_code %}
          
        {% do matched_sql_models.append(model.original_file_path)  %}
        
    {% endif %}

{% endfor %}
    
{% for model_path in matched_sql_models | unique %}
    
    {{ log(model_path, info=True) }}

{% endfor %}

{% set generic_tests = graph.nodes.values() | selectattr('resource_type', 'eq', 'test') %}

{% set matched_generic_tests=[] %}

{% for generic_test in generic_tests %}

        {% if search_string in generic_test.column_name %}
          
        {% do matched_generic_tests.append(generic_test.original_file_path)  %}

        {% endif %}

{% endfor %}
    
{% for generic_test_path in matched_generic_tests | unique %}
    
    {{ log(generic_test_path, info=True) }}

{% endfor %}

{% set singular_tests = graph.nodes.values() | selectattr('resource_type', 'eq', 'test') %}

{% set matched_singular_tests=[] %}

{% for singular_test in singular_tests %}

        {% if search_string in singular_test.raw_code %}
          
        {% do matched_singular_tests.append(singular_test.original_file_path)  %}

        {% endif %}

{% endfor %}
    
{% for singular_test_path in matched_singular_tests | unique %}
    
    {{ log(singular_test_path, info=True) }}

{% endfor %}
  
{% endmacro %}