{{- config(
    materialized = 'view' if flags.FULL_REFRESH else 'table',
    order_by = "1",
    on_schema_change= "sync_all_columns"
)
-}}

{{ log(flags.FULL_REFRESH, info=True) }}

select 1 cd, 'One' name, 'two' another_name