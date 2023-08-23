{% snapshot example_snapshot %}
{{config(
    target_database='mike_fuller_sandbox',
    target_schema=var('snapshot_schema'),
    unique_key='id',
    strategy=var('strategy'),
    updated_at='updated_at'
)}}
select * from {{ ref('my_first_dbt_model') }}
{% endsnapshot %}