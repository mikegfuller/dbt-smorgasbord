select *
from {{ source('mike_test', 'my_new_table_' ~ var('dynamic_table_id')) }}