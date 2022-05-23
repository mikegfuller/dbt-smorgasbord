{% macro swap_table_env_var(tablename) %}

{% set sql = 'alter table stage.cde.' ~ tablename ~ ' swap with work.cde.' ~ tablename %}

{{ log(sql, info=True) }}

{% set var_sql = 'alter table ' ~ env_var("blue_db") ~ '.' ~ env_var("blue_schema") ~ '.' ~ tablename ~ ' swap with ' ~ env_var("green_db") ~ '.' ~ env_var("green_schema")~ '.' ~ tablename %}

{{ log(var_sql, info=True) }}

{% endmacro %}