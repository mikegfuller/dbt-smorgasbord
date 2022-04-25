
{{ config(
    pre_hook=sk_generator(1,1),
    materialized = 'table'
) }}

select {{ monotonic_sk() }},
'first_record' as descrip
union all
select {{ monotonic_sk() }},
'second_record' as descrip
union all
select {{ monotonic_sk() }},
'third_record' as descrip