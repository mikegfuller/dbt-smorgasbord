{{
    config(
        tags=["test_views"],
        materialized='view'
    )
}}

select id, test_descrip
from {{ ref('b_test_view') }}