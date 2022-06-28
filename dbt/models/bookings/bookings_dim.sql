{{
  config(
    materialized = 'table'
    )
}}

select id,
status,
state,
country,
{{ cents_to_dollars('booking_amt',2) }} as booking_usd,
event_dt,
dbt_scd_id,
dbt_updated_at,
dbt_valid_from,
dbt_valid_to,
{{ scd3_cols('status,state', 'id', 'event_dt') }} 
from {{ ref('bookings_snapshot') }}
order by id, event_dt