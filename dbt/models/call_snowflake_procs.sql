{{
    config(
        pre_hook="call sp_pi()"
    )
}}

select 'snowflake_pi' as proc_description
union all 
select 'snowflake_hello' as proc_description

{{
    config(
        post_hook="call sp_hello_world()"
    )
}}