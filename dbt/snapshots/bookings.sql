{% snapshot bookings_snapshot %}

{{
    config(
      target_database='mike_fuller_sandbox',
      target_schema='snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='event_dt',
    )
}}

select * from {{ source('scd_demo', 'bookings') }}

{% endsnapshot %}