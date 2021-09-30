{{
    config(
        tags=["test_views"],
        materialized='view'
    )
}}

--new comment to trigger another run
select id, test_descrip
from {{ ref('a_test_table') }} a