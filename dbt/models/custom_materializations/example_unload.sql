{{
    config(
        materialized='table_unload',
        stage_name = '@mike_fuller_demo.analytics.mike_demo_unload'
    )
}}

select * from {{ ref('immutable_events') }}
where event_dt = '2021-03-04' --a conditonal clause here to isolate change records, even something something like current_date