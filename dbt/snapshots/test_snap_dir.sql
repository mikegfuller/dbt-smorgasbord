{% snapshot orders_snapshot %}

{{
    config(
      target_database='mike_fuller_sandbox',
      target_schema='snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='updated_at',
    )
}}

select * from {{ ref('orders') }}

{% endsnapshot %}