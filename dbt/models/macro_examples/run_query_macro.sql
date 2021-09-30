select {{run_query_example()}} as macro_variable, 'another_value' as static_value, id
from {{ref('my_first_dbt_model')}}