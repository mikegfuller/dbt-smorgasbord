{{
    config(
        materialized='table'
    )
}}

with 

events as 
    (select * from {{ ref('immutable_events') }})

,slowly_changing_dimension as (
select 
{{ dbt_utils.surrogate_key(['id', 'event_dt']) }} as row_id
,events.id
,events.status
,events.event_dt as event_dt
,events.event_dt as eff_from
,case when lead(events.id) over(order by id) = id then lead(events.event_dt) over(order by events.id) else null end as eff_to
,case when lead(events.id) over(order by id) = id then 'N' else 'Y' end as current_flg
from events
)

,final as (
    select row_id
    ,id
    ,status
    ,event_dt
    ,eff_from
    ,eff_to
    ,current_flg
    from slowly_changing_dimension
)

select * from final