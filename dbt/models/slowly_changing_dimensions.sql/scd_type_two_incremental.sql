{{
    config(
        materialized='incremental',
        unique_key='row_id',
        merge_update_columns = ['eff_to','current_flg']
    )
}}

with
events as (
    select * from {{ ref('immutable_events') }}
    )

,slowly_changing_dim as (
    select 
{{ dbt_utils.surrogate_key(['id', 'event_dt']) }} as row_id
,events.id
,events.status
,events.event_dt as event_dt
,events.event_dt as eff_from
,case when lead(events.id) over(order by events.id, events.event_dt) = events.id then lead(events.event_dt) over(order by events.id, events.event_dt) else null end as eff_to
,case when lead(events.id) over(order by events.id, events.event_dt) = events.id then 'N' else 'Y' end as current_flg
from events

{% if is_incremental() %}

where id in (
    select id from {{ ref('immutable_events')  }} where event_dt > (select max(event_dt) from {{ this }} )
)

{% endif %}

)

,final as (
    select row_id
    ,id
    ,event_dt
    ,status
    ,eff_from
    ,eff_to
    ,current_flg
    from slowly_changing_dim
)

select * from final