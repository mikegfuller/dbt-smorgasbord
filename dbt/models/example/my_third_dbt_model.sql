
select *
from {{ ref('my_first_dbt_model') }}
where id = 2
and this_column_does_not_exist = 'oops'
