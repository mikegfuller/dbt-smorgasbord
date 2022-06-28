{{
    config(
        materialized='scd_current_only'
    )
}}

select * from {{ ref('bookings_snapshot') }}