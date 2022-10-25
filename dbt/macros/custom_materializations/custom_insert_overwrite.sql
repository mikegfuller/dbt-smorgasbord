{% materialization insert_overwrite, adapter='snowflake'  %}
    
    {%- set target_relation = this -%}  

    {% set order_by = config.get("order_by") %}

    {%- set tmp_identifier = target_relation.identifier ~ "_temp" %}
    
    {%- set tmp_relation = target_relation.incorporate(path = {"identifier": tmp_identifier, "schema": config.get('temp_schema', default=target_relation.schema)}) -%}
    
    {%- set existing_relation = load_relation(this) -%}

    {% set on_schema_change = incremental_validate_on_schema_change(config.get('on_schema_change'), default='ignore') %}

    {% set target_relation = target_relation.incorporate(type='table') %}
    
    {% if existing_relation.is_view %}

        {{ log("Dropping relation " ~ target_relation ~ " because it is a view and this model is a table.")}}

        {% do adapter.drop_relation(existing_relation) %}

    {% endif %}

    --------------------------------------------------------------------------------------------------------------------

    -- check if the target table exists already or not
    
    {% if existing_relation is none or should_full_refresh() or existing_relation.is_view %} -- if doesnt exists then use CTAS to create the table
        {%- set build_sql =   build_insert_overwrite_initial_sql_without_temp_table(target_relation, tmp_relation, order_by) %}
    {% elif on_schema_change in ('append_new_columns','sync_all_columns') %}   -- if exists and schema change is not ignore then create temp table
        {%- set build_sql = build_insert_overwrite_sql_with_temp_table(target_relation, tmp_relation, order_by, on_schema_change) %}
    {% else %} -- If exists then do insert overwrite, we will not be creating temp table for this  
        {%- set build_sql = build_insert_overwrite_sql_without_temp_table(target_relation, order_by) %}
    {% endif %}
    
    --------------------------------------------------------------------------------------------------------------------

    -- setup
    {{ run_hooks(pre_hooks, inside_transaction=False) }}

    -- `BEGIN` happens here:
    {{ run_hooks(pre_hooks, inside_transaction=True) }}

    --------------------------------------------------------------------------------------------------------------------

    -- build model

    {%- call statement('main') -%}
        {{ build_sql }}
    {% endcall %}
    
    --------------------------------------------------------------------------------------------------------------------

    {{ run_hooks(post_hooks, inside_transaction=True) }}

    -- `COMMIT` happens here

    {{ adapter.commit() }}

    {{ run_hooks(post_hooks, inside_transaction=False) }}

    --------------------------------------------------------------------------------------------------------------------    

    {% set target_relation = this.incorporate(type='table') %}
    
    {% do persist_docs(target_relation, model) %}
    
    {{ return({'relations': [target_relation]}) }}

{% endmaterialization %}

{#

After that, let’s create the macros that will generate the query for both scenarios:

-   When the target does not exist then do (initial load)
-   when it already exists then do insert overwrite

You can add these macros to the same file with the materialization macros.

For the initial load process, we create the temporary table with our model SQL. 

Then we define the initial_sql to select from the temporary table.

#}

{%- macro build_insert_overwrite_initial_sql_with_temp_table(target_relation, temp_relation, order_by) -%}    
    {{ create_table_as(True, temp_relation, sql) }}
    {%- set initial_sql -%}
        select
             *
        from
            {{ temp_relation }}
        {% if order_by -%}
        order by 
            {{ order_by }}
        {%- endif %}
    {%- endset -%}

    {{ create_table_as(False, target_relation, initial_sql) }}

{%- endmacro -%}

{%- macro build_insert_overwrite_initial_sql_without_temp_table(target_relation, temp_relation, order_by) -%}
    
    {%- set initial_sql -%}
            {{ sql }}
        {% if order_by -%}
        order by 
            {{ order_by }}
        {%- endif %}
    {%- endset -%}

    {{ create_table_as(False, target_relation, initial_sql) }}

{%- endmacro -%}


{#
When the table already exists, we’ll insert the data from the temporary table and add the processed_timestamp column as well.
#}

{%- macro build_insert_overwrite_sql_with_temp_table(target_relation, temp_relation, order_by, on_schema_change) -%}    

    {%- set columns = adapter.get_columns_in_relation(target_relation) -%}
    {%- set csv_colums = get_quoted_csv(columns | map(attribute="name")) -%}

    {%- call statement('create_temp_relation') -%}
    {{ create_table_as(True, temp_relation, sql) }}
    {%- endcall -%}
    
     {#-- Process schema changes. Returns dict of changes if successful. Use source columns for upserting/merging --#}

     {% do adapter.expand_target_column_types(
           from_relation=temp_relation,
           to_relation=target_relation) %}

    {% set columns = process_schema_changes(on_schema_change, temp_relation, target_relation) %}

    {% if not columns %}
      {% set columns = adapter.get_columns_in_relation(target_relation) %}
    {% endif %}
    {%- set csv_colums = get_quoted_csv(columns | map(attribute="name")) %}

    insert overwrite into {{ target_relation }} ({{ csv_colums }})
    select 
         {{ csv_colums }}
    from
         {{ temp_relation }}
    {% if order_by -%}
        order by 
            {{ order_by }}
    {%- endif %}
{%- endmacro -%}

{%- macro build_insert_overwrite_sql_without_temp_table(target_relation, order_by) -%}
    {%- set columns = adapter.get_columns_in_relation(target_relation) -%}
    {%- set csv_colums = get_quoted_csv(columns | map(attribute="name")) -%}
    
    insert overwrite into {{ target_relation }} ({{ csv_colums }})
    {{ sql }}
    {% if order_by -%}
        order by 
            {{ order_by }}
    {%- endif %}
{%- endmacro -%}
