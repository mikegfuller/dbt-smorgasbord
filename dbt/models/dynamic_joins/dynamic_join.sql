select my_first_model.id
from
{{ ref('my_first_dbt_model') }} my_first_model

{% if var('var_int') >= 1 and var('var_int') <= 3 -%}

join {{ ref('my_second_dbt_model') }} my_second_model
on my_first_model.id = my_second_model.id

{% else -%}

join {{ ref('my_third_dbt_model') }} my_third_dbt_model
on my_first_model.id = my_third_dbt_model.id

{% endif %}

