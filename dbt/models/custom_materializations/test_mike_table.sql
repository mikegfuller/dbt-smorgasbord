{{
  config(
    materialized = 'mike_table',
    snowflake_stage = 'mike_fuller_demo.analytics.mike_demo_unload'
    )
}}

select 1 as id