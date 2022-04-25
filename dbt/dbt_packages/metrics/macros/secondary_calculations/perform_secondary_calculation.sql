{% macro perform_secondary_calculation(metric_name, dimensions, calc_config) %}

    {{ return(adapter.dispatch('perform_secondary_calculation', 'metrics')(metric_name, dimensions, calc_config)) }}

{% endmacro %}

{% macro default__perform_secondary_calculation(metric_name, dimensions, calc_config) %}
    {%- set calc_type = calc_config.calculation %}
    {%- set calc_sql = '' %}
    
    {%- if calc_type == 'period_over_period' %}
        {%- set calc_sql = adapter.dispatch('secondary_calculation_period_over_period', 'metrics')(metric_name, dimensions, calc_config) %}
   
    {%- elif calc_type == 'rolling' %}
        {%- set calc_sql = adapter.dispatch('secondary_calculation_rolling', 'metrics')(metric_name, dimensions, calc_config) %}
    
    {%- elif calc_type == 'period_to_date' %}
        {%- set calc_sql = adapter.dispatch('secondary_calculation_period_to_date', 'metrics')(metric_name, dimensions, calc_config) %}
    
    {%- else %}
        {%- do exceptions.raise_compiler_error("Unknown secondary calculation: " ~ calc_type ~ ". calc_config: " ~ calc_config) %}  
    {%- endif %}

    {{- calc_sql }}

{% endmacro %}