
select *
from {{ ref('my_first_dbt_model') }}
where id = 2
and sample_column = 'oops'
