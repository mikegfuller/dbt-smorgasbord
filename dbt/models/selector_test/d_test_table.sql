{{
    config(
        tags=["test_tables"],
        materialized='table'
    )
}}

select id, test_descrip
from {{ ref('c_test_view') }}