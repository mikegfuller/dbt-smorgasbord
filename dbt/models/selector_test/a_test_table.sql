{{
    config(
        tags=["test_tables"],
        materialized='table'
    )
}}

select 1 as id, 'test' as test_descrip