select *
from {{ source_new('mike_test', 'my_new_table', 'dynamic_table_id') }}