{{
    config(
        materialized='mike_table'
    )
}}

select * from {{ ref('bookings_snapshot') }}