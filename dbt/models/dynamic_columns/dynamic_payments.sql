select 

{%- for payment_method in ["bank_transfer", "credit_card", "gift_card"] %}
sum(case when payment_method = '{{payment_method}}' then amount else 0 end) as {{payment_method}}_amount,
{%- endfor %}

{%- for my_columns in ["column_1", "column_2", "column_3"] %}
{{round_dollars(my_columns)}} as {{my_columns}},
{%- endfor %}

sum(amount) as total_amount
from {{ ref('base_payments') }}
group by 
{%- for my_columns in ["column_1", "column_2", "column_3"] %}
{{my_columns}}{% if not loop.last %},{% endif %}
{%- endfor %}