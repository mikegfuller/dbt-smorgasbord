{% macro swap_table_env_var(tablename) %}

{% set sql = 'alter table stage.cde.' ~ tablename ~ ' swap with work.cde.' ~ tablename %}

{{ log(sql, info=True) }}

{% set var_sql = 'alter table ' ~ env_var("DBT_BLUE_DB") ~ '.' ~ env_var("DBT_BLUE_SCHEMA") ~ '.' ~ tablename ~ ' swap with ' ~ env_var("DBT_GREEN_DB") ~ '.' ~ env_var("DBT_GREEN_SCHEMA")~ '.' ~ tablename %}

{{ log(var_sql, info=True) }}

{% endmacro %}