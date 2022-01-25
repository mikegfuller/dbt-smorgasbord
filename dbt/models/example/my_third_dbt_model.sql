
select 1/0 as bogus
from {{ ref('my_first_dbt_model') }}
--where id = 2
