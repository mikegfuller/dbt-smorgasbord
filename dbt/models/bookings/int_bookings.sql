select 
id,
status,
state,
country,
{{ cents_to_dollars('booking_amt',2) }} as booking_usd,
dbt_scd_id,
dbt_updated_at,
dbt_valid_from,
dbt_valid_to
 from {{ ref('bookings_snapshot') }} 
 order by id, dbt_valid_from