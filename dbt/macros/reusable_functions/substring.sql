{% macro str_before(column_name, delimiter) %}

 

    {%- set default_column_name = '' -%}

    {%- set partNumber = 1  -%}

    {%- if column_name is none -%}

        {{ default_column_name }}

    {%- else -%}

        (( split_part( {{ column_name }} , {{ delimiter }} , {{ partNumber }} )) )

    {%- endif -%}

 

{% endmacro %}


{% macro str_after(column_name, delimiter) %}

 

    {%- set default_column_name = '' -%}

    {%- set partNumber = 1  -%}

    {%- set incrNumber = 2  -%}

    {%- if column_name is none -%}

        {{ default_column_name }}

    {%- else -%}

        ((substring( {{ column_name }} , length(split_part( {{ column_name }}, {{ delimiter }}, {{ partNumber }} )) + {{ incrNumber }} , length( {{ column_name }} ))) )

    {%- endif -%}

 

{% endmacro %}