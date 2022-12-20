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
,{{ scd2_cols('events.event_dt','events.id') }}
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